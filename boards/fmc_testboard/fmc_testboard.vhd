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


use work.fmc_testboard_pkg.all;
use work.fmc_helper_pkg.all;


entity fmc_testboard is

  generic (
    g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
    g_address_granularity    : t_wishbone_address_granularity := WORD;  
  
    g_enable_system_i2c   : boolean := true;
    
    g_fmc_id              : natural                        := 1;
	g_fmc_map             : t_fmc_pin_map_vector           := c_fmc_pin_nullvector
    );

  Port (
    clk_i        : in std_logic;
    rst_n_i      : in std_logic;
	
	--== Wishbone ==--	
	s_wb_m2s     : in  t_wishbone_slave_in;
    s_wb_s2m     : out t_wishbone_slave_out;
    
    --== FMC abstraction layer ==--
    port_fmc_io: inout t_fmc_signals_bidir
    );

end fmc_testboard;

architecture Behavioral of fmc_testboard is


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

component xwb_fmc_csr is
    generic (
    g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
    g_address_granularity    : t_wishbone_address_granularity := WORD;  
  
    g_enable_system_i2c   : boolean := true;
    g_enable_pg_m2c       : boolean := false;
    g_enable_pg_c2m       : boolean := false;
    g_enable_prsntl       : boolean := false;
    
    g_fmc_id              : natural := 1
    );
  Port (
    clk_i        : in std_logic;
    rst_n_i      : in std_logic;
	
	--== Wishbone ==--	
	s_wb_m2s     : in  t_wishbone_slave_in;
    s_wb_s2m     : out t_wishbone_slave_out;
    
    
    pg_m2c_i : in std_logic := '1';
    pg_c2m_i : in std_logic  := '1';
    prsntl_i : in std_logic  := '1';
        
        
        fmc_enable_o: out std_logic
    
    
    );
end component;

  constant g_num_io : natural := 80+80;
  constant c_iodelaymap : t_iodelay_map_vector(fmc_testboard_pin_map_single'range) := fmc_testboard_pin_map_single;
  constant c_test_bool :boolean := write_xdc("fmc"& integer'image(g_fmc_id) &"_loc.xdc", g_fmc_id , g_fmc_map, fmc_testboard_pin_map_single);
  
  
  constant c_NUM_WB_UPSTREAM : integer := 1;
  constant c_WB_MASTER_SYSTEM : natural := 0;  -- Mezzanine system I2C interface (EEPROM)

  -- Number of slave port(s) on the wishbone crossbar
  constant c_NUM_WB_DEVICES : integer := 3;
 
  constant c_WB_SLAVE_FMC_CSR      : natural := 0;  -- Mezzanine onewire interface
  constant c_WB_SLAVE_FMC_SYS_I2C  : natural := 1;  -- Mezzanine onewire interface
  constant c_WB_SLAVE_FMC_GPIO     : natural := 2;  -- Mezzanine onewire interface

    -- @todo: export sdb layouts to pkg files  
  -- Wishbone crossbar layout
  constant c_INTERCONNECT_LAYOUT_req : t_sdb_record_array(c_NUM_WB_DEVICES-1 downto 0) :=
    (
      c_WB_SLAVE_FMC_CSR     => f_sdb_auto_device(c_xwb_i2c_master_sdb, true),
      c_WB_SLAVE_FMC_SYS_I2C => f_sdb_auto_device(c_xwb_i2c_master_sdb, g_enable_system_i2c),
      c_WB_SLAVE_FMC_GPIO    => f_sdb_auto_device(c_xwb_gpio_raw_sdb, true)
      );
-- sdb header address
  constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(c_INTERCONNECT_LAYOUT_req'range) := f_sdb_auto_layout(c_INTERCONNECT_LAYOUT_req);
   -- Self Describing Bus ROM Address. It will be an addressed slave as well.
  constant c_SDB_ADDRESS                    : t_wishbone_address := f_sdb_auto_sdb(c_INTERCONNECT_LAYOUT_req);


signal s_wishbone_m2s :  t_wishbone_slave_in_array(c_NUM_WB_UPSTREAM-1 downto 0);
signal s_wishbone_s2m :  t_wishbone_slave_out_array(c_NUM_WB_UPSTREAM-1 downto 0);

signal m_wishbone_s2m :  t_wishbone_master_in_array(c_NUM_WB_DEVICES-1 downto 0);
signal m_wishbone_m2s :  t_wishbone_master_out_array(c_NUM_WB_DEVICES-1 downto 0);
  
  
  signal port_fmc_in_i :  t_fmc_signals_bidir;
  signal port_fmc_out_o:  t_fmc_signals_bidir;
  
  signal s_fmc_in1: t_fmc_signals_in;
  signal s_fmc_out1: t_fmc_signals_out;
  signal s_fmc_oe: t_fmc_signals_out;  
  
  signal raw_i: STD_LOGIC_VECTOR (g_num_io-1 downto 0) := (others => '0'); 

  signal s_gpio_in: STD_LOGIC_VECTOR (g_num_io-1 downto 0) := (others => '0');
  signal s_gpio_out: STD_LOGIC_VECTOR (g_num_io-1 downto 0) := (others => '0');
  signal s_gpio_oe: STD_LOGIC_VECTOR (g_num_io-1 downto 0) := (others => '0');
  
  
  --== Wishbone I2C master ==--
    signal sys_scl_in : std_logic;
    signal sys_scl_out: std_logic;
    signal sys_scl_oe_n: std_logic;
    signal sys_sda_in: std_logic;
    signal sys_sda_out: std_logic;
    signal sys_sda_oe_n: std_logic;


  signal s_fmc_enable : std_logic;
begin

 s_fmc_out1.LA_p(33 downto 0) <= s_gpio_out(33 downto 0);
 s_fmc_out1.HA_p(23 downto 0) <= s_gpio_out(57 downto 34);
 s_fmc_out1.HB_p(21 downto 0) <= s_gpio_out(79 downto 58);

 s_fmc_oe.LA_p(33 downto 0) <= not s_gpio_oe(33 downto 0);
 s_fmc_oe.HA_p(23 downto 0) <= not s_gpio_oe(57 downto 34);
 s_fmc_oe.HB_p(21 downto 0) <= not s_gpio_oe(79 downto 58);

 s_gpio_in(33 downto 0 ) <= s_fmc_in1.LA_p(33 downto 0);
 s_gpio_in(57 downto 34) <= s_fmc_in1.HA_p(23 downto 0);
 s_gpio_in(79 downto 58) <= s_fmc_in1.HB_p(21 downto 0);

 s_fmc_out1.LA_n(33 downto 0) <= s_gpio_out(80+33 downto 80+0);
 s_fmc_out1.HA_n(23 downto 0) <= s_gpio_out(80+57 downto 80+34);
 s_fmc_out1.HB_n(21 downto 0) <= s_gpio_out(80+79 downto 80+58);

 s_fmc_oe.LA_n(33 downto 0) <= not s_gpio_oe(80+33 downto 80+0);
 s_fmc_oe.HA_n(23 downto 0) <= not s_gpio_oe(80+57 downto 80+34);
 s_fmc_oe.HB_n(21 downto 0) <= not s_gpio_oe(80+79 downto 80+58);

 s_gpio_in(80+33 downto 80+0 ) <= s_fmc_in1.LA_n(33 downto 0);
 s_gpio_in(80+57 downto 80+34) <= s_fmc_in1.HA_n(23 downto 0);
 s_gpio_in(80+79 downto 80+58) <= s_fmc_in1.HB_n(21 downto 0);
 
 cmp_fmc_adapter_iob: fmc_adapter_iob
 	generic map(
 		g_connector      => FMC_HPC,
 		g_use_jtag       => false,
 		g_use_inout      => true,
 		g_fmc_id         => g_fmc_id,
 		g_fmc_map        => g_fmc_map,
 		g_fmc_idelay_map => c_iodelaymap
 	)
 	port map(
 		port_fmc_io    => port_fmc_io,
 		port_fmc_in_i  => port_fmc_in_i,
 		port_fmc_out_o => port_fmc_out_o,
 		fmc_in_o       => s_fmc_in1,
 		fmc_out_i      => s_fmc_out1,
 		fmc_out_dir_i  => s_fmc_oe
 	);



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
      g_sdb_name    => "fmc-105-single     " )
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


        ------------------------------------------------------------------------------
        -- Mezzanine system managment I2C master
        --    Access to mezzanine EEPROM
        ------------------------------------------------------------------------------
        U_fmc_sys_i2c : xwb_i2c_master
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
      g_num_pins                              => g_num_io,
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
      gpio_out_o                              => s_gpio_out,
      gpio_in_i                               => s_gpio_in,
      gpio_oe_o                               => s_gpio_oe,
      gpio_term_o                             => open,

      -- AltF raw interface    
      raw_o => open,
      raw_i => raw_i
      );
      
end block;   
 
end Behavioral;
