-------------------------------------------------------------------------------
-- Title      : FMC DIO 32ch LVDS a HDL module
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : fmc_dio_32chlvdsa.vhd
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2017-02-27
-- Platform   : FPGA-generics
-- Standard   : VHDL
-------------------------------------------------------------------------------
-- Description:
-- fmc_dio_32chttla integrates I2C Master, GPIO-RAW and SPI master
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2017 Piotr Miedzik
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

use work.fmc_general_pkg.all;
use work.wishbone_pkg.all;
use work.wishbone_gsi_lobi_pkg.all;
use work.wb_helpers_pkg.all;

use work.fmc_dio_32chttla_pkg.all;
use work.fmc_helper_pkg.all;
use work.fmc_wishbone_pkg.all;


entity fmc_dio_32chttla is

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

    slave_i       : in  t_wishbone_slave_in;
    slave_o       : out t_wishbone_slave_out;
           
    raw_o: out STD_LOGIC_VECTOR (31 downto 0);
    raw_i: in  STD_LOGIC_VECTOR (31 downto 0)
    );

end fmc_dio_32chttla;

architecture Behavioral of fmc_dio_32chttla is

	constant fmc_dio_32chttla_iodelay_in: t_iodelay_map_vector:= fmc_extract_by_direction(dir_type => DIRIN, idelay_map => fmc_dio_32chttla_pin_map);
	constant fmc_dio_32chttla_iodelay_out: t_iodelay_map_vector:= fmc_extract_by_direction(dir_type => DIROUT, idelay_map => fmc_dio_32chttla_pin_map);
	
    constant c_test_bool :boolean := write_xdc("fmc"& integer'image(g_fmc_id) &"_loc.xdc", g_fmc_id , g_fmc_map, fmc_dio_32chttla_pin_map);

  --== Internal Wishbone Crossbar configuration ==--
  -- Number of master port(s) on the wishbone crossbar
  constant c_NUM_WB_MASTERS : integer := 4;
  constant c_WB_MASTER_SYSTEM : natural := 0;  -- Mezzanine system I2C interface (EEPROM)

  -- Number of slave port(s) on the wishbone crossbar
  constant c_NUM_WB_SLAVES : integer := 1;

  constant c_WB_SLAVE_FMC_CSR     : natural := 0;  -- Mezzanine system I2C interface (EEPROM)
  constant c_WB_SLAVE_FMC_SYS_I2C : natural := 1; -- Mezzanine system I2C interface (EEPROM)
  constant c_WB_SLAVE_FMC_GPIO    : natural := 2;  -- Mezzanine onewire interface
  constant c_WB_SLAVE_FMC_GPIO2   : natural := 3;  -- Mezzanine onewire interface
  

    -- @todo: export sdb layouts to pkg files  
  -- Wishbone crossbar layout
  constant c_INTERCONNECT_LAYOUT_req : t_sdb_record_array(c_NUM_WB_MASTERS-1 downto 0) :=
    (
      c_WB_SLAVE_FMC_CSR      => f_sdb_auto_device(c_xwb_fmc_csr_sdb_f, true),
      c_WB_SLAVE_FMC_SYS_I2C  => f_sdb_auto_device(c_xwb_i2c_master_sdb, g_enable_system_i2c),
      c_WB_SLAVE_FMC_GPIO     => f_sdb_auto_device(c_xwb_gpio_raw_sdb, true),
      c_WB_SLAVE_FMC_GPIO2    => f_sdb_auto_device(c_xwb_gpio_raw_sdb, true)
      );
-- sdb header address
  constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(c_INTERCONNECT_LAYOUT_req'range) := f_sdb_auto_layout(c_INTERCONNECT_LAYOUT_req);
   -- Self Describing Bus ROM Address. It will be an addressed slave as well.
  constant c_SDB_ADDRESS                    : t_wishbone_address := f_sdb_auto_sdb(c_INTERCONNECT_LAYOUT_req);
  constant tmp2: boolean := sdb_dump_to_file("fmc"& integer'image(g_fmc_id) &"_SDB_dio32chttla.txt", c_INTERCONNECT_LAYOUT, c_SDB_ADDRESS);
   
    -- Wishbone buse(s) from crossbar master port(s)
  signal cnx_master_out : t_wishbone_master_out_array(c_NUM_WB_MASTERS-1 downto 0);
  signal cnx_master_in  : t_wishbone_master_in_array(c_NUM_WB_MASTERS-1 downto 0);

  -- Wishbone buse(s) to crossbar slave port(s)
  signal cnx_slave_out : t_wishbone_slave_out_array(c_NUM_WB_SLAVES-1 downto 0);
  signal cnx_slave_in  : t_wishbone_slave_in_array(c_NUM_WB_SLAVES-1 downto 0);


  --== Wishbone I2C master ==--
  signal sys_scl_in : std_logic;
  signal sys_scl_out: std_logic;
  signal sys_scl_oe_n: std_logic;
  signal sys_sda_in: std_logic;
  signal sys_sda_out: std_logic;
  signal sys_sda_oe_n: std_logic;



  --== Wishbone GPIO RAW signals ==--
  constant c_num_io : natural := 32;
--  signal r_input: std_logic_vector(c_num_io-1 downto 0);
--  signal r_output: std_logic_vector(c_num_io-1 downto 0);
  signal r_input: std_logic_vector( 48-1 downto 0);
  signal r_output: std_logic_vector( 48-1 downto 0);

  signal s_dir_oe          : std_logic_vector(c_num_io-1 downto 0);
  signal s_dir_oen         : std_logic_vector(48-1 downto 0);


  signal s_fmc_in1: t_fmc_signals_in; -- signals from iob to extractor
  signal s_fmc_in_raw: t_fmc_signals_in; -- raw interface from extractor (ungrupped pins)
  signal s_fmc_out1: t_fmc_signals_out;
  signal s_fmc_out_raw: t_fmc_signals_out;
  signal s_fmc_dir1: t_fmc_signals_out;  
  signal s_fmc_dir2: t_fmc_signals_out;
  
  signal port_fmc_in: t_fmc_signals_in; -- dummy signals
  
  signal s_fmc_enable : std_logic;
begin


 cmp_fmc_adapter_iob: fmc_adapter_iob
 	generic map(
 		g_connector      => FMC_LPC,
 		g_use_jtag       => false,
 		g_use_inout      => true,
 		g_fmc_id         => g_fmc_id,
 		g_fmc_map        => g_fmc_map,
 		g_fmc_idelay_map => fmc_dio_32chttla_pin_map
 	)
 	port map(
 		port_fmc_io    => port_fmc_io,
 		port_fmc_in_i  => port_fmc_in,
 		port_fmc_out_o => open,
        
 		fmc_in_o       => s_fmc_in1,
        
 		fmc_out_i      => s_fmc_out1,        
 		fmc_out_dir_i  => s_fmc_dir1
 	);

   
  cmp_extractor : fmc_adapter_extractor
  	generic map(
        g_count_per_group => 8,
  		g_fmc_id         => g_fmc_id,
  		g_fmc_connector  => FMC_LPC,
  		g_fmc_map        => g_fmc_map,
  		g_fmc_idelay_map => fmc_dio_32chttla_iodelay_in
  	)
  	port map(
  		fmc_in_i     => s_fmc_in1, -- input from iob
  		fmc_in_o     => s_fmc_in_raw, -- raw interfece for group = -1
  		fmc_groups_o => r_input    -- interface from grups
  );
  
   cmp_injector : fmc_adapter_injector
   	generic map(
        g_count_per_group => 8,
   		g_fmc_id         => g_fmc_id,
   		g_fmc_connector  => FMC_LPC,
   		g_fmc_map        => g_fmc_map,
   		g_fmc_idelay_map => fmc_dio_32chttla_iodelay_out
   	)
   	port map(
   		fmc_out_i    => s_fmc_out_raw, -- input value from ungrupped pins
   		fmc_dir_i    => s_fmc_dir2, -- input directon from ungrupped pins (unused)
        
   		fmc_out_o    => s_fmc_out1, -- output to IOB
        fmc_dir_o    => s_fmc_dir1,
        
   		groups_i     => r_output,
   		groups_dir_i => s_dir_oen
   	);
    
    s_dir_oen( 7 downto  0) <= "00000000" when s_dir_oe( 0) = '1' else "11111111"; 
    s_dir_oen(15 downto  8) <= "00000000" when s_dir_oe( 8) = '1' else "11111111";
    s_dir_oen(23 downto 16) <= "00000000" when s_dir_oe(16) = '1' else "11111111";
    s_dir_oen(31 downto 24) <= "00000000" when s_dir_oe(24) = '1' else "11111111";
    
    
    --
    --        Function table 
    -- +-----+-----+-----------------+
    -- |   INPUTS  |    Operation    |
    -- | OEn | DIR |                 |
    -- +-----+-----+-----------------+ 
    -- |  L  |  L  | B data to A bus | <-- output
    -- |  L  |  H  | A data to B bus | <-- input
    -- |  H  |  X  |    Isolation    |   
    -- +-----+-----+-----------------+
    --
    
    -- isolation when fmc module is disabled
    -- OE outputs are inverted on FMC module
    r_output(35 downto 32) <= "1111" when s_fmc_enable = '1' else "0000";
    
    --
    r_output(36)           <= '0' when s_dir_oe( 0) = '1' else '1';
    r_output(37)           <= '0' when s_dir_oe( 8) = '1' else '1';
    r_output(38)           <= '0' when s_dir_oe(16) = '1' else '1';
    r_output(39)           <= '0' when s_dir_oe(24) = '1' else '1';
     
    
    
  -- @todo: final extractor

  cnx_slave_in(c_WB_MASTER_SYSTEM) <= slave_i;
  slave_o <= cnx_slave_out(c_WB_MASTER_SYSTEM);

  cmp_sdb_crossbar : xwb_sdb_crossbar
    generic map (
      g_num_masters => c_NUM_WB_SLAVES,
      g_num_slaves  => c_NUM_WB_MASTERS,
      g_registered  => true,
      g_wraparound  => true,
      g_layout      => c_INTERCONNECT_LAYOUT,
      g_sdb_addr    => c_SDB_ADDRESS,
      g_sdb_name    => "fmc-dio-32chlvdsa" )
    port map (
      clk_sys_i => clk_i,
      rst_n_i   => rst_n_i,
      slave_i   => cnx_slave_in,
      slave_o   => cnx_slave_out,
      master_i  => cnx_master_in,
      master_o  => cnx_master_out
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
	s_wb_m2s     => cnx_master_out(c_WB_SLAVE_FMC_CSR),
    s_wb_s2m     => cnx_master_in(c_WB_SLAVE_FMC_CSR),
    
    
    pg_m2c_i => '0',
    pg_c2m_i => '0',
    prsntl_i => '1',
    fmc_enable_o => s_fmc_enable
    );

  U_I2C_SYS: if g_enable_system_i2c = true generate
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

      slave_i => cnx_master_out(c_WB_SLAVE_FMC_SYS_I2C),
      slave_o => cnx_master_in(c_WB_SLAVE_FMC_SYS_I2C),
      desc_o  => open,

      scl_pad_i(0)    => sys_scl_in,
      scl_pad_o(0)    => sys_scl_out,
      scl_padoen_o(0) => sys_scl_oe_n,
      sda_pad_i(0)    => sys_sda_in,
      sda_pad_o(0)    => sys_sda_out,
      sda_padoen_o(0) => sys_sda_oe_n
      );
    end generate U_I2C_SYS;

BLK_IO: block

signal local_wb_m2s       : t_wishbone_slave_in;
signal local_wb_s2m       : t_wishbone_slave_out;

begin 
  cmp_xwb_decoupler: xwb_decoupler 
  Port map (
    enable_i      => s_fmc_enable,
	
	--== Wishbone ==--	
	s_wb_m2s      => cnx_master_out(c_WB_SLAVE_FMC_GPIO),
    s_wb_s2m      => cnx_master_in(c_WB_SLAVE_FMC_GPIO),

	m_wb_m2s      => local_wb_m2s,
    m_wb_s2m      => local_wb_s2m
    
    );

    -- todo -> add synchronized output from external
    U_GPIO : xwb_gpio_raw
    generic map(
      g_interface_mode                        => g_interface_mode,
      g_address_granularity                   => g_address_granularity,
      g_num_pins                              => c_num_io,
      g_with_builtin_tristates                => false,
      g_debug                                 => false,
      g_feedback_direction                    => false
      )
    port map(
      clk_sys_i                               => clk_i,
      rst_n_i                                 => rst_n_i,

      -- Wishbone
      slave_i                                 => local_wb_m2s,
      slave_o                                 => local_wb_s2m,
	 
      desc_o                                  => open,    -- Not implemented

      --gpio_b : inout std_logic_vector(g_num_pins-1 downto 0);
      gpio_out_o                              => r_output(31 downto 0),
      gpio_in_i                               => r_input(31 downto 0),
      gpio_oe_i                               => open,
      gpio_oe_o                               => s_dir_oe,
      gpio_term_o                             => open,

      -- AltF raw interface    
      raw_o => raw_o,
      raw_i => raw_i
      );
 
end block BLK_IO;
 

BLK_IO2: block

signal local_wb_m2s       : t_wishbone_slave_in;
signal local_wb_s2m       : t_wishbone_slave_out;

begin 
  cmp_xwb_decoupler: xwb_decoupler 
  Port map (
    enable_i      => s_fmc_enable,
	
	--== Wishbone ==--	
	s_wb_m2s      => cnx_master_out(c_WB_SLAVE_FMC_GPIO2),
    s_wb_s2m      => cnx_master_in(c_WB_SLAVE_FMC_GPIO2),

	m_wb_m2s      => local_wb_m2s,
    m_wb_s2m      => local_wb_s2m
    
    );

    -- todo -> add synchronized output from external
    U_GPIO : xwb_gpio_raw
    generic map(
      g_interface_mode                        => g_interface_mode,
      g_address_granularity                   => g_address_granularity,
      g_num_pins                              => 3,
      g_with_builtin_tristates                => false,
      g_debug                                 => false,
      g_feedback_direction                    => false
      )
    port map(
      clk_sys_i                               => clk_i,
      rst_n_i                                 => rst_n_i,

      -- Wishbone
      slave_i                                 => local_wb_m2s,
      slave_o                                 => local_wb_s2m,
	 
      desc_o                                  => open,    -- Not implemented

      --gpio_b : inout std_logic_vector(g_num_pins-1 downto 0);
      gpio_out_o                              => r_output(42 downto 40),
      gpio_in_i                               => r_input(42 downto 40),
      gpio_oe_i                               => "000",
      gpio_oe_o                               => open,
      gpio_term_o                             => open,

      -- AltF raw interface    
      raw_o => open,
      raw_i => (others => '0')
      );
 
end block BLK_IO2;
 
end Behavioral;
