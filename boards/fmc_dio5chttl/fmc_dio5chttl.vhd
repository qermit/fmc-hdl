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


use work.fmc_dio5chttl_pkg.all;
use work.afc_pkg.all;

entity fmc_dio5chttl is

  generic (
    g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
    g_address_granularity    : t_wishbone_address_granularity := WORD;
    g_use_tristate           : boolean := true;

    g_num_io                : natural                        := 5;
	g_fmc_id              : natural                        := 1;
	g_fmc_map             : t_fmc_pin_map_vector           := afc_v2_FMC_pinmap
    );

  Port (
    clk_i : in STD_LOGIC;
    rst_n_i : in STD_LOGIC;
           
    port_fmc_in_i: in t_fmc_signals_in;
    port_fmc_out_o: out t_fmc_signals_out;
    port_fmc_io: inout t_fmc_signals_bidir;

    slave_i       : in  t_wishbone_slave_in;
    slave_o       : out t_wishbone_slave_out;
           
    raw_o: out STD_LOGIC_VECTOR (g_num_io-1 downto 0);
    raw_i: in  STD_LOGIC_VECTOR (g_num_io-1 downto 0)
    );

end fmc_dio5chttl;

architecture Behavioral of fmc_dio5chttl is
	constant fmc_dio5chttl_iodelay_in: t_iodelay_map_vector:= fmc_extract_by_direction(dir_type => DIRIN, idelay_map => fmc_dio5chttl_pin_map);
	constant fmc_dio5chttl_iodelay_out: t_iodelay_map_vector:= fmc_extract_by_direction(dir_type => DIROUT, idelay_map => fmc_dio5chttl_pin_map);

  --== Internal Wishbone Crossbar configuration ==--
  -- Number of master port(s) on the wishbone crossbar
  constant c_NUM_WB_MASTERS : integer := 3;
  constant c_WB_MASTER_SYSTEM : natural := 0;  -- Mezzanine system I2C interface (EEPROM)

  -- Number of slave port(s) on the wishbone crossbar
  constant c_NUM_WB_SLAVES : integer := 1;

  constant c_WB_SLAVE_FMC_SYS_I2C : natural := 0;  -- Mezzanine system I2C interface (EEPROM)
  constant c_WB_SLAVE_FMC_ONEWIRE : natural := 1;  -- Mezzanine onewire interface
  constant c_WB_SLAVE_FMC_GPIO    : natural := 2;  -- Mezzanine onewire interface

    -- @todo: export sdb layouts to pkg files  
  -- Wishbone crossbar layout
  constant c_INTERCONNECT_LAYOUT_req : t_sdb_record_array(c_NUM_WB_MASTERS-1 downto 0) :=
    (
      c_WB_SLAVE_FMC_SYS_I2C => f_sdb_auto_device(c_xwb_i2c_master_sdb, true),
      c_WB_SLAVE_FMC_ONEWIRE => f_sdb_auto_device(c_xwb_onewire_master_sdb, true),
      c_WB_SLAVE_FMC_GPIO    => f_sdb_auto_device(c_xwb_gpio_raw_sdb, true)
      );
-- sdb header address
  constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(c_INTERCONNECT_LAYOUT_req'range) := f_sdb_auto_layout(c_INTERCONNECT_LAYOUT_req);
   -- Self Describing Bus ROM Address. It will be an addressed slave as well.
  constant c_SDB_ADDRESS                    : t_wishbone_address := f_sdb_auto_sdb(c_INTERCONNECT_LAYOUT_req);
   
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

  --== Wishbone 1-Wire master ==--
  signal mezz_owr_en: std_logic_vector(0 downto 0);
  signal mezz_owr_i: std_logic_vector(0 downto 0);

  --== Wishbone GPIO RAW signals ==--
  signal r_input: std_logic_vector(g_num_io-1 downto 0);
  signal r_output: std_logic_vector(g_num_io-1 downto 0);

  signal s_dir: std_logic_vector(g_num_io-1 downto 0);
  signal s_term: std_logic_vector(g_num_io-1 downto 0);
  signal s_dir_tmp: std_logic_vector(g_num_io-1 downto 0);


  signal s_fmc_in1: t_fmc_signals_in;
  signal s_fmc_in2: t_fmc_signals_in;
  signal s_fmc_out1: t_fmc_signals_out;
  signal s_fmc_out2: t_fmc_signals_out;
  signal s_fmc_dir1: t_fmc_signals_out;  
  signal s_fmc_dir2: t_fmc_signals_out;
  

  
  
  signal s_groups_in:std_logic_vector(4 * 8 - 1 downto 0);
  signal s_groups_out:std_logic_vector(4 * 8 - 1 downto 0);
  signal s_groups_dir:std_logic_vector(4 * 8 - 1 downto 0);
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
  s_groups_out(16 + 1)  <= s_term(1);
  s_groups_out(16 + 2)  <= s_term(2);
  s_groups_out(16 + 3)  <= s_term(3);
  s_groups_out(16 + 4)  <= s_term(4);

  s_dir_tmp <= not s_dir;
  s_groups_out(8 + 0) <= s_dir_tmp(0);
  s_groups_out(8+ 1) <= s_dir_tmp(1);
  s_groups_out(8+ 2) <= s_dir_tmp(2);
  s_groups_out(8+ 3) <= s_dir_tmp(3);
  s_groups_out(8+ 4)  <= s_dir_tmp(4);

  s_groups_out(0) <= r_output(0);
  s_groups_out(1) <= r_output(1);
  s_groups_out(2)  <= r_output(2);
  s_groups_out(3)  <= r_output(3);
  s_groups_out(4)  <= r_output(4);

  cnx_slave_in(c_WB_MASTER_SYSTEM) <= slave_i;
  slave_o <= cnx_slave_out(c_WB_MASTER_SYSTEM);

  cmp_sdb_crossbar : xwb_sdb_crossbar
    generic map (
      g_num_masters => c_NUM_WB_SLAVES,
      g_num_slaves  => c_NUM_WB_MASTERS,
      g_registered  => true,
      g_wraparound  => true,
      g_layout      => c_INTERCONNECT_LAYOUT,
      g_sdb_addr    => c_SDB_ADDRESS)
    port map (
      clk_sys_i => clk_i,
      rst_n_i   => rst_n_i,
      slave_i   => cnx_slave_in,
      slave_o   => cnx_slave_out,
      master_i  => cnx_master_in,
      master_o  => cnx_master_out
      );

  ------------------------------------------------------------------------------
  -- Mezzanine system managment I2C master
  --    Access to mezzanine EEPROM
  ------------------------------------------------------------------------------
--  cmp_fmc_sys_i2c : xwb_i2c_master
--    generic map(
--      g_interface_mode      => g_interface_mode,
--      g_address_granularity => g_address_granularity
--      )
--    port map (
--      clk_sys_i => clk_i,
--      rst_n_i   => rst_n_i,

--      slave_i => cnx_master_out(c_WB_SLAVE_FMC_SYS_I2C),
--      slave_o => cnx_master_in(c_WB_SLAVE_FMC_SYS_I2C),
--      desc_o  => open,

--      scl_pad_i(0)    => sys_scl_in,
--      scl_pad_o(0)    => sys_scl_out,
--      scl_padoen_o(0) => sys_scl_oe_n,
--      sda_pad_i(0)    => sys_sda_in,
--      sda_pad_o(0)    => sys_sda_out,
--      sda_padoen_o(0) => sys_sda_oe_n
--      );

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

      slave_i => cnx_master_out(c_WB_SLAVE_FMC_ONEWIRE),
      slave_o => cnx_master_in(c_WB_SLAVE_FMC_ONEWIRE),
      desc_o  => open,

      owr_pwren_o => open,
      owr_en_o    => mezz_owr_en,
      owr_i       => mezz_owr_i
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
      slave_i                                 => cnx_master_out(c_WB_SLAVE_FMC_GPIO),
      slave_o                                 => cnx_master_in(c_WB_SLAVE_FMC_GPIO),
	 
      desc_o                                  => open,    -- Not implemented

      --gpio_b : inout std_logic_vector(g_num_pins-1 downto 0);
      gpio_out_o                              => r_output,
      gpio_in_i                               => r_input,
      gpio_oen_o                              => s_dir,
      gpio_term_o                             => s_term,

      -- AltF raw interface    
      raw_o => raw_o,
      raw_i => raw_i
      );
 
end Behavioral;
