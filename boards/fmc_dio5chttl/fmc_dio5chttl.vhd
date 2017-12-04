-------------------------------------------------------------------------------
-- Title      : FMC DIO 5ch TTL a HDL module
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : fmc_dio5chttl.vhd
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2015-09-11
-- Last update: 2016-02-10
-- Platform   : FPGA-generics
-- Standard   : VHDL
-------------------------------------------------------------------------------
-- Description:
-- fmc_dio5chttl integrates I2C Master, 1-Wire Master and GPIO-RAW
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2016 Piotr Miedzik
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.fmc_general_pkg.all;
use work.wishbone_pkg.all;
use work.wishbone_gsi_lobi_pkg.all;
use work.wb_helpers_pkg.all;

use work.fmc_dio5chttl_pkg.all;
use work.fmc_helper_pkg.all;
use work.fmc_wishbone_pkg.all;


entity fmc_dio5chttl is

  generic (
    g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
    g_address_granularity    : t_wishbone_address_granularity := WORD;
    
    g_enable_system_i2c      : boolean := true;

	g_fmc_id              : natural                        := 1;
	g_fmc_map             : t_fmc_pin_map_vector           := c_fmc_pin_nullvector
    );

  Port (
    clk_i : in STD_LOGIC;
    rst_n_i : in STD_LOGIC;

    port_fmc_io: inout t_fmc_signals_bidir;

    s_wb_m2s       : in  t_wishbone_slave_in;
    s_wb_s2m       : out t_wishbone_slave_out;
           
    raw_o: out STD_LOGIC_VECTOR (6 downto 0);
    raw_i: in  STD_LOGIC_VECTOR (6 downto 0)
    );

end fmc_dio5chttl;

architecture Behavioral of fmc_dio5chttl is


component xwb_decoupler is
  Port (
    enable_i      : in std_logic;
	
	--== Wishbone ==--	
	s_wb_m2s      : in  t_wishbone_slave_in;
    s_wb_s2m      : out t_wishbone_slave_out;

	m_wb_m2s       : out t_wishbone_slave_in;
    m_wb_s2m       : in  t_wishbone_slave_out
    
    );
end component xwb_decoupler;


--  attribute black_box : string;
--  attribute black_box of Behavioral: architecture is "yes";

  constant c_num_io : natural := 5;
  constant c_num_gpio : natural :=  c_num_io+2;

	constant fmc_dio5chttl_iodelay_in: t_iodelay_map_vector:= fmc_extract_by_direction(dir_type => DIRIN, idelay_map => fmc_dio5chttl_pin_map);
	constant fmc_dio5chttl_iodelay_out: t_iodelay_map_vector:= fmc_extract_by_direction(dir_type => DIROUT, idelay_map => fmc_dio5chttl_pin_map);
	
    constant c_test_bool :boolean := write_xdc("fmc"& integer'image(g_fmc_id) &"_loc.xdc", g_fmc_id , g_fmc_map, fmc_dio5chttl_pin_map);

  --== Internal Wishbone Crossbar configuration ==--
  -- Number of master port(s) on the wishbone crossbar
  constant c_WB_MASTER_SYSTEM : natural := 0;  -- Mezzanine system I2C interface (EEPROM)

  -- Number of slave port(s) on the wishbone crossbar
  constant c_NUM_WB_UPSTREAM : integer := 1;

  constant c_NUM_WB_DEVICES : integer := 4;

  constant c_WB_SLAVE_FMC_CSR     : natural := 0;  -- Mezzanine CSR interface
  constant c_WB_SLAVE_FMC_SYS_I2C : natural := 1;  -- Mezzanine system I2C interface (EEPROM)
  constant c_WB_SLAVE_FMC_ONEWIRE : natural := 2;  -- Mezzanine onewire interface
  constant c_WB_SLAVE_FMC_GPIO    : natural := 3;  -- Mezzanine onewire interface

    -- @todo: export sdb layouts to pkg files  
  -- Wishbone crossbar layout
  constant c_INTERCONNECT_LAYOUT_req : t_sdb_record_array(c_NUM_WB_DEVICES-1 downto 0) :=
    (
      c_WB_SLAVE_FMC_CSR     => f_sdb_auto_device(c_xwb_fmc_csr_sdb_f, true),
      c_WB_SLAVE_FMC_SYS_I2C => f_sdb_auto_device(c_xwb_i2c_master_sdb, g_enable_system_i2c),
      c_WB_SLAVE_FMC_ONEWIRE => f_sdb_auto_device(c_xwb_onewire_master_sdb, true),
      c_WB_SLAVE_FMC_GPIO    => f_sdb_auto_device(c_xwb_gpio_raw_sdb, true)
      );
-- sdb header address
  constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(c_INTERCONNECT_LAYOUT_req'range) := f_sdb_auto_layout(c_INTERCONNECT_LAYOUT_req);
   -- Self Describing Bus ROM Address. It will be an addressed slave as well.
  constant c_SDB_ADDRESS                    : t_wishbone_address := f_sdb_auto_sdb(c_INTERCONNECT_LAYOUT_req);
  constant tmp2: boolean := sdb_dump_to_file("fmc"& integer'image(g_fmc_id) &"_SDB_dio5chttla.txt", c_INTERCONNECT_LAYOUT, c_SDB_ADDRESS);

   
  signal s_wishbone_m2s :  t_wishbone_slave_in_array(c_NUM_WB_UPSTREAM-1 downto 0);
  signal s_wishbone_s2m :  t_wishbone_slave_out_array(c_NUM_WB_UPSTREAM-1 downto 0);
  
  signal m_wishbone_s2m :  t_wishbone_master_in_array(c_NUM_WB_DEVICES-1 downto 0);
  signal m_wishbone_m2s :  t_wishbone_master_out_array(c_NUM_WB_DEVICES-1 downto 0);


  --== Wishbone I2C master ==--
  signal sys_scl_in : std_logic;
  signal sys_scl_out: std_logic;
  signal sys_scl_oe_n: std_logic;
  signal sys_sda_in: std_logic;
  signal sys_sda_out: std_logic;
  signal sys_sda_oe_n: std_logic;

  --== Wishbone 1-Wire master ==--
  signal mezz_owr_en: std_logic_vector(0 downto 0);
  signal mezz_owr_i: std_logic_vector(0 downto 0);

  --== Wishbone GPIO RAW signals ==--
  signal r_input: std_logic_vector(c_num_gpio-1 downto 0);
  signal r_output: std_logic_vector(c_num_gpio-1 downto 0);

  signal s_dir_oe: std_logic_vector(c_num_gpio-1 downto 0);
  signal s_term: std_logic_vector(c_num_gpio-1 downto 0);
  signal s_dir_oen: std_logic_vector(c_num_gpio-1 downto 0);


  signal port_fmc_in_i: t_fmc_signals_in;
  signal port_fmc_out_o: t_fmc_signals_out;


  signal s_fmc_in1: t_fmc_signals_in;
  signal s_fmc_in2: t_fmc_signals_in;
  signal s_fmc_out1: t_fmc_signals_out;
  signal s_fmc_out2: t_fmc_signals_out;
  signal s_fmc_dir1: t_fmc_signals_out;  
  signal s_fmc_dir2: t_fmc_signals_out;
  
  signal s_groups_in:std_logic_vector(8 - 1 downto 0);
  signal s_groups_out:std_logic_vector(3 * 8 - 1 downto 0);
  signal s_groups_dir:std_logic_vector(3 * 8 - 1 downto 0);
  
  signal s_fmc_enable: std_logic;
begin


 cmp_fmc_adapter_iob: fmc_adapter_iob
 	generic map(
 		g_connector      => FMC_LPC,
 		g_use_jtag       => false,
 		g_use_inout      => true,
 		g_fmc_id         => g_fmc_id,
 		g_fmc_map        => g_fmc_map,
 		g_fmc_idelay_map => fmc_dio5chttl_pin_map
 	)
 	port map(
 		port_fmc_io    => port_fmc_io,
 		port_fmc_in_i  => port_fmc_in_i,
 		port_fmc_out_o => port_fmc_out_o,
 		fmc_in_o       => s_fmc_in1,
 		fmc_out_i      => s_fmc_out1,
 		fmc_out_dir_i  => s_fmc_dir1
 	);

  --@todo: check and fix fmc_adapter_extractor & fmc_adapter_injector   
  cmp_extractor : fmc_adapter_extractor
  	generic map(
  		g_fmc_id         => g_fmc_id,
  		g_fmc_connector  => FMC_LPC,
  		g_fmc_map        => g_fmc_map,
  		g_fmc_idelay_map => fmc_dio5chttl_iodelay_in
  	)
  	port map(
  		fmc_in_i     => s_fmc_in1,
  		fmc_in_o     => s_fmc_in2,
  		fmc_groups_o => s_groups_in
  );
  
   cmp_injector : fmc_adapter_injector
   	generic map(
   		g_fmc_id         => g_fmc_id,
   		g_fmc_connector  => FMC_LPC,
   		g_fmc_map        => g_fmc_map,
   		g_fmc_idelay_map => fmc_dio5chttl_iodelay_out
   	)
   	port map(
   		fmc_out_i    => s_fmc_out2,
   		fmc_dir_i    => s_fmc_dir2,
   		fmc_out_o    => s_fmc_out1,
   		fmc_dir_o    => s_fmc_dir1,
   		groups_i     => s_groups_out,
   		groups_dir_i => s_groups_dir
   	);
  -- @todo: final extractor
  
  
  r_input(0) <= s_groups_in(0);
  r_input(1) <= s_groups_in(1);
  r_input(2) <= s_groups_in(2);
  r_input(3) <= s_groups_in(3);
  r_input(4) <= s_groups_in(4);

  

  s_groups_out(16 + 0) <= s_term(0);
  s_groups_out(16 + 1) <= s_term(1);
  s_groups_out(16 + 2) <= s_term(2);
  s_groups_out(16 + 3) <= s_term(3);
  s_groups_out(16 + 4) <= s_term(4);
  s_groups_dir(16 + 4 downto 16) <= (others => '0');
  

  s_dir_oen <= not s_dir_oe;
  s_groups_out(8 + 0) <= s_dir_oen(0);
  s_groups_out(8+ 1) <= s_dir_oen(1);
  s_groups_out(8+ 2) <= s_dir_oen(2);
  s_groups_out(8+ 3) <= s_dir_oen(3);
  s_groups_out(8+ 4)  <= s_dir_oen(4);
  s_groups_dir(8+4 downto 8) <= (others => '0');

  s_groups_out(0) <= r_output(0);
  s_groups_out(1) <= r_output(1);
  s_groups_out(2) <= r_output(2);
  s_groups_out(3) <= r_output(3);
  s_groups_out(4) <= r_output(4);
  s_groups_dir(4 downto 0) <= (others => '0');


  r_input(5) <= '0';
  r_input(6) <= '0';
  s_fmc_out2.LA_P(01) <= r_output(5);
  s_fmc_dir2.LA_P(01) <= s_dir_oen(5);

  s_fmc_out2.LA_N(01) <= r_output(6);
  s_fmc_dir2.LA_N(01) <= s_dir_oen(6);


  s_wishbone_m2s(0) <= s_wb_m2s;
  s_wb_s2m <= s_wishbone_s2m(0);

  cmp_sdb_crossbar : xwb_sdb_crossbar
    generic map (
      g_num_masters => c_NUM_WB_UPSTREAM,
      g_num_slaves  => c_NUM_WB_DEVICES,
      g_registered  => true,
      g_wraparound  => true,
      g_layout      => c_INTERCONNECT_LAYOUT,
      g_sdb_addr    => c_SDB_ADDRESS,
      g_sdb_name    => f_string_fix_len2("fmc-dio-5chttla", 19, ' ', false)
    )
    port map (
      clk_sys_i => clk_i,
      rst_n_i   => rst_n_i,
      slave_i   => s_wishbone_m2s,
      slave_o   => s_wishbone_s2m,
      master_i  => m_wishbone_s2m,
      master_o  => m_wishbone_m2s
   );

cmp_fmc_csr: xwb_fmc_csr
    generic  map (
    g_interface_mode         => g_interface_mode,
    g_address_granularity    => g_address_granularity,  
  
    g_enable_system_i2c   => g_enable_system_i2c,
    g_enable_pg_m2c       => false,
    g_enable_pg_c2m       => false,
    g_enable_prsntl       => false,
    
    g_fmc_id              => g_fmc_id
    )
  Port map  (
    clk_i        => clk_i,
    rst_n_i      => rst_n_i,
	
	--== Wishbone ==--	
	s_wb_m2s     => m_wishbone_m2s(c_WB_SLAVE_FMC_CSR),
    s_wb_s2m     => m_wishbone_s2m(c_WB_SLAVE_FMC_CSR),
    
    
    pg_m2c_i => '0',
    pg_c2m_i => '0',
    prsntl_i => '1',
    fmc_enable_o => s_fmc_enable
    );

U_I2C: if g_enable_system_i2c = true generate
  ------------------------------------------------------------------------------
  -- Mezzanine system managment I2C master
  --    Access to mezzanine EEPROM
  ------------------------------------------------------------------------------
  cmp_fmc_sys_i2c : xwb_i2c_master
    generic map(
      g_interface_mode      => g_interface_mode,
      g_address_granularity => g_address_granularity
      )
    port map (
      clk_sys_i => clk_i,
      rst_n_i   => rst_n_i,

      slave_i => m_wishbone_m2s(c_WB_SLAVE_FMC_SYS_I2C),
      slave_o => m_wishbone_s2m(c_WB_SLAVE_FMC_SYS_I2C),
      desc_o  => open,

      scl_pad_i(0)    => sys_scl_in,
      scl_pad_o(0)    => sys_scl_out,
      scl_padoen_o(0) => sys_scl_oe_n,
      sda_pad_i(0)    => sys_sda_in,
      sda_pad_o(0)    => sys_sda_out,
      sda_padoen_o(0) => sys_sda_oe_n
      );
end generate;



BLK_ONEWIRE: block

signal local_wb_m2s       : t_wishbone_slave_in;
signal local_wb_s2m       : t_wishbone_slave_out;

begin 
  cmp_xwb_decoupler: xwb_decoupler 
  Port map (
    enable_i      => s_fmc_enable,
	
	--== Wishbone ==--	
	s_wb_m2s      => m_wishbone_m2s(c_WB_SLAVE_FMC_ONEWIRE),
    s_wb_s2m      => m_wishbone_s2m(c_WB_SLAVE_FMC_ONEWIRE),

	m_wb_m2s      => local_wb_m2s,
    m_wb_s2m      => local_wb_s2m
    
    );
  ------------------------------------------------------------------------------
  -- Mezzanine 1-wire master
  --    DS18B20 (thermometer + unique ID)
  ------------------------------------------------------------------------------
  cmp_fmc_onewire : xwb_onewire_master
    generic map(
      g_interface_mode      => g_interface_mode,
      g_address_granularity => g_address_granularity,
      g_num_ports           => 1,
      g_ow_btp_normal       => "5.0",
      g_ow_btp_overdrive    => "1.0"
      )
    port map(
      clk_sys_i => clk_i,
      rst_n_i   => rst_n_i,

      slave_i => local_wb_m2s,
      slave_o => local_wb_s2m,
      desc_o  => open,

      owr_pwren_o => open,
      owr_en_o    => mezz_owr_en,
      owr_i       => mezz_owr_i
      );

end block BLK_ONEWIRE;



BLK_GPIO: block

signal local_wb_m2s       : t_wishbone_slave_in;
signal local_wb_s2m       : t_wishbone_slave_out;

begin 
cmp_xwb_decoupler: xwb_decoupler 
  Port map (
    enable_i      => s_fmc_enable,
	
	--== Wishbone ==--	
	s_wb_m2s      => m_wishbone_m2s(c_WB_SLAVE_FMC_GPIO),
    s_wb_s2m      => m_wishbone_s2m(c_WB_SLAVE_FMC_GPIO),

	m_wb_m2s      => local_wb_m2s,
    m_wb_s2m      => local_wb_s2m
    
    );
    
  cmp_IO : xwb_gpio_raw
    generic map(
      g_interface_mode                        => g_interface_mode,
      g_address_granularity                   => g_address_granularity,
      g_num_pins                              => c_num_gpio,
      g_with_builtin_tristates                => false,
      g_debug                                 => false
      )
    port map(
      clk_sys_i                               => clk_i,
      rst_n_i                                 => rst_n_i,

      -- Wishbone
      slave_i                                 => local_wb_m2s,
      slave_o                                 => local_wb_s2m,
	 
      desc_o                                  => open,    -- Not implemented

      --gpio_b : inout std_logic_vector(g_num_pins-1 downto 0);
      gpio_out_o                              => r_output,
      gpio_in_i                               => r_input,
      gpio_oe_o                               => s_dir_oe,
      gpio_term_o                             => s_term,

      -- AltF raw interface    
      raw_o => raw_o,
      raw_i => raw_i
      );
end block BLK_GPIO;
 
end Behavioral;
