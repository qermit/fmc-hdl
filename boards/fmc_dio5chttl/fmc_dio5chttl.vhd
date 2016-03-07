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

entity fmc_dio5chttl is

  generic (
    g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
    g_address_granularity    : t_wishbone_address_granularity := WORD;
    g_use_tristate           : boolean := true;

    g_num_io                : natural                        := 5;

    g_fmc_LA_inv   : bit_vector(33 downto 0) := (others => '0');
   
    g_fmc_DP_C2M_inv   : std_logic_vector(9 downto 0) := (others => '0');
    g_fmc_DP_M2C_inv   : std_logic_vector(9 downto 0) := (others => '0')
    );

  Port (
    clk_i : in STD_LOGIC;
    rst_n_i : in STD_LOGIC;
           
    fmc_in: in t_fmc_signals_in;
    fmc_out: out t_fmc_signals_out;
	 
    fmc_inout: inout t_fmc_signals_in;

    slave_i       : in  t_wishbone_slave_in;
    slave_o       : out t_wishbone_slave_out;
           
    raw_o: out STD_LOGIC_VECTOR (g_num_io-1 downto 0);
    raw_i: in  STD_LOGIC_VECTOR (g_num_io-1 downto 0)
    );

end fmc_dio5chttl;

architecture Behavioral of fmc_dio5chttl is

  -- FMC input direction map and signals tristate
  constant c_LA_diff_io: t_character_array(c_fmc_LA_pin_count-1 downto 0) := (
    33 => '1', 20 => '1', 16 => '1', 3 => '1', 0 => '1', 
	 29 => '1', 28 => '1', 8 => '1', 7 => '1', 4 => '1', 
	 30 => '0', 15 => '0', 24 => '0', 9 => '0', 11 => '0', 5 => '0', 6 => '0',
	 others => 'X');
	 
  constant c_LA_dir_io: bit_vector(c_fmc_LA_pin_count-1 downto 0) := (
    33 => '0', 20 => '0', 16 => '0', 3 => '0', 0 => '0', 
	 29 => '1', 28 => '1', 8 => '1', 7 => '1', 4 => '1', 
	 30 => '1', -- OE0_N
	 9  => '1', -- TERM_EN3
	 11 => '1', -- OE3_N
	 5  => '1', -- OE4_N
	 others => '0');
	 
  constant c_LA_dir_io_n: bit_vector(c_fmc_LA_pin_count-1 downto 0) := (
	 30 => '1', -- TERM_EN0
	 15 => '1', -- OE2_N
	 24 => '1', -- OE1_N
	 9  => '1', -- TERM_EN4
	 11 => '1', -- OE3_N
	 5  => '1', -- TERM_EN2
	 6  => '1', -- TERM_EN1
	 others => '0');
	
	 
  -- FMC input direction map and signals  
  constant c_LA_diff_i: std_logic_vector(c_fmc_LA_pin_count-1 downto 0) := ( 
	33 => '1', 20 => '1', 16 => '1', 3 => '1', 0 => '1', 
	others => 'X' );

  signal fmc_LA_input_o: std_logic_vector(c_fmc_LA_pin_count-1 downto 0);

  -- FMC output direction map and signals
  constant c_LA_diff_o: std_logic_vector(c_fmc_LA_pin_count-1 downto 0) := ( 
	29 => '1', 28 => '1', 8 => '1', 7 => '1', 4 => '1', 
	30 => '0', 15 => '0', 24 => '0', 9 => '0', 11 => '0', 5 => '0', 6 => '0',
	others => 'X' );

  signal fmc_LA_output_p: std_logic_vector(c_fmc_LA_pin_count-1 downto 0);
  signal fmc_LA_output_n: std_logic_vector(c_fmc_LA_pin_count-1 downto 0);


  --== Internal Wishbone Crossbar configuration ==--
  -- Number of master port(s) on the wishbone crossbar
  constant c_NUM_WB_MASTERS : integer := 3;
  constant c_WB_MASTER_SYSTEM : natural := 0;  -- Mezzanine system I2C interface (EEPROM)

  -- Number of slave port(s) on the wishbone crossbar
  constant c_NUM_WB_SLAVES : integer := 1;

  constant c_WB_SLAVE_FMC_SYS_I2C : natural := 0;  -- Mezzanine system I2C interface (EEPROM)
  constant c_WB_SLAVE_FMC_ONEWIRE : natural := 1;  -- Mezzanine onewire interface
  constant c_WB_SLAVE_FMC_GPIO    : natural := 2;  -- Mezzanine onewire interface

  -- sdb header address
  constant c_SDB_ADDRESS : t_wishbone_address := x"00000000";

  -- Wishbone crossbar layout
  constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(c_NUM_WB_MASTERS-1 downto 0) :=
    (
      c_WB_SLAVE_FMC_SYS_I2C => f_sdb_embed_device(c_xwb_i2c_master_sdb, x"00001000"),
      c_WB_SLAVE_FMC_ONEWIRE => f_sdb_embed_device(c_xwb_onewire_master_sdb, x"00001100"),
      c_WB_SLAVE_FMC_GPIO    => f_sdb_embed_device(c_xwb_gpio_raw_sdb, x"00001200")
      );

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

begin

GEN_ADAPTER_TRISTATE: if g_use_tristate = true generate
  u_LA_adapter: fmc_adapter_io
    generic map(
      g_pin_count => c_fmc_LA_pin_count,

      g_diff(c_fmc_LA_pin_count-1 downto 0) => c_LA_diff_io,
      g_diff(63 downto c_fmc_LA_pin_count) => (others => 'X'),

      g_swap(c_fmc_LA_pin_count-1 downto 0) => g_fmc_LA_inv,
      g_swap(63 downto c_fmc_LA_pin_count) => (others => '0'),

      g_out_p(c_fmc_LA_pin_count-1 downto 0) => c_LA_dir_io,
      g_out_p(63 downto c_fmc_LA_pin_count) => (others => '0'),

      g_out_n(c_fmc_LA_pin_count-1 downto 0) => c_LA_dir_io_n,
      g_out_n(63 downto c_fmc_LA_pin_count) => (others => '0')
	   )

    port map (
      port_io_p => fmc_inout.LA_p,
      port_io_n => fmc_inout.LA_n,

      output_i_p => fmc_LA_output_p,
      output_i_n => fmc_LA_output_n,
      dir_i_p => open,
      dir_i_n => open,

      input_o_p => fmc_LA_input_o,
      input_o_n => open
      );	
end generate GEN_ADAPTER_TRISTATE;

GEN_ADAPTER: if g_use_tristate = false generate

--  u_LA_in_pins: fmc_adapter
--    generic map(
--      g_pin_count => c_fmc_LA_pin_count,
--      g_diff => c_LA_diff_i,
--      g_fmc_inv => g_fmc_LA_inv,
--      g_dir_out => '0'
--      )
--    port map (
--      fmc_p_i => fmc_in.LA_p,
--      fmc_n_i => fmc_in.LA_n,
--      fmc_p_o => fmc_LA_input_o
--      );
 
--  u_LA_out_pins: fmc_adapter
--    generic map(
--      g_pin_count => c_fmc_LA_pin_count,
--      g_diff(c_fmc_LA_pin_count-1 downto 0) => c_LA_diff_o,
--      g_diff(200 downto c_fmc_LA_pin_count) => (others => 'X'),
--      g_fmc_inv(c_fmc_LA_pin_count-1 downto 0) => g_fmc_LA_inv,
--      g_fmc_inv(200 downto c_fmc_LA_pin_count) => (others => '0'),
--      g_dir_out => '1'
--      )
--    port map (
--      fmc_p_o => fmc_out.LA_p,
--      fmc_n_o => fmc_out.LA_n,
--      fmc_p_i => fmc_LA_output_p,
--      fmc_n_i => fmc_LA_output_n
--      );
end generate GEN_ADAPTER;

  r_input(0) <= fmc_LA_input_o(33);
  r_input(1) <= fmc_LA_input_o(20);
  r_input(2) <= fmc_LA_input_o(16);
  r_input(3) <= fmc_LA_input_o(3);
  r_input(4) <= fmc_LA_input_o(0);

  fmc_LA_output_n(30) <= s_term(0);
  fmc_LA_output_n(6)  <= s_term(1);
  fmc_LA_output_n(5)  <= s_term(2);
  fmc_LA_output_p(9)  <= s_term(3);
  fmc_LA_output_n(9)  <= s_term(4);

  s_dir_tmp <= not s_dir;
  fmc_LA_output_p(30) <= s_dir_tmp(0);
  fmc_LA_output_n(24) <= s_dir_tmp(1);
  fmc_LA_output_n(15) <= s_dir_tmp(2);
  fmc_LA_output_p(11) <= s_dir_tmp(3);
  fmc_LA_output_p(5)  <= s_dir_tmp(4);

  fmc_LA_output_p(29) <= r_output(0);
  fmc_LA_output_p(28) <= r_output(1);
  fmc_LA_output_p(8)  <= r_output(2);
  fmc_LA_output_p(7)  <= r_output(3);
  fmc_LA_output_p(4)  <= r_output(4);

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
