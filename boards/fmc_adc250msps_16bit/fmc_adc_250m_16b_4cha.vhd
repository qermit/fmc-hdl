-------------------------------------------------------------------------------
-- Title      : FMC ADC 250m 16b 4cha HDL module
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : fmc_adc_250m_16b_4cha.vhd
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2016-03-08
-- Last update: 2016-03-08
-- Platform   : FPGA-generics
-- Standard   : VHDL
-------------------------------------------------------------------------------
-- Description:
-- fmc_adc_250m_16b_4cha integrates  ... tbd 
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2016 Piotr Miedzik
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.fmc_general_pkg.all;
use work.wishbone_pkg.all;
use work.wishbone_gsi_lobi_pkg.all;

use work.afc_pkg.all;
use work.fmc_adc_250m_16b_4cha_pkg.all;

entity fmc_adc_250m_16b_4cha is
	generic(
		g_fmc_id              : natural                        := 0;
		g_interface_mode      : t_wishbone_interface_mode      := CLASSIC;
		g_address_granularity : t_wishbone_address_granularity := WORD;
		g_use_tristate        : boolean                        := true;

		g_fmc_map             : t_fmc_pin_map_vector           := afc_v2_FMC_pinmap
	);

	Port(
		clk_i          : in    STD_LOGIC;
		rst_n_i        : in    STD_LOGIC;

		port_fmc_inout : inout t_fmc_signals_bidir;
		port_fmc_in    : in    t_fmc_signals_in;
		port_fmc_out   : out   t_fmc_signals_out;

		slave_i        : in    t_wishbone_slave_in;
		slave_o        : out   t_wishbone_slave_out
	);

end fmc_adc_250m_16b_4cha;

architecture Behavioral of fmc_adc_250m_16b_4cha is
	constant c_adc_iodelaymap : t_iodelay_map_vector(adc_250m_pin_map'range) := adc_250m_pin_map;

	signal s_fmc_in1  : t_fmc_signals_in;
	signal s_fmc_out1 : t_fmc_signals_out;
	signal s_fmc_dir1 : t_fmc_signals_out;

	signal s_fmc_in2 : t_fmc_signals_in;

	signal s_fmc_in_q1 : t_fmc_signals_in;
	signal s_fmc_in_q2 : t_fmc_signals_in;

	signal s_idelay_ctrl_in  : t_fmc_idelay_in_array(fmc_iodelay_group_count(c_adc_iodelaymap) - 1 downto 0);
	signal s_idelay_ctrl_out : t_fmc_idelay_out_array(fmc_iodelay_group_count(c_adc_iodelaymap) - 1 downto 0);

begin
	cmp_fmc_adapter_iob : fmc_adapter_iob
		generic map(
			g_connector      => FMC_HPC,
			g_use_jtag       => false,
			g_use_inout      => true,
			g_fmc_id         => g_fmc_id,
			g_fmc_map        => g_fmc_map,
			g_fmc_idelay_map => c_adc_iodelaymap
		)
		port map(
			port_fmc_io    => port_fmc_inout,
			port_fmc_in_i  => port_fmc_in,
			port_fmc_out_o => port_fmc_out,
			fmc_in_o       => s_fmc_in1,
			fmc_out_i      => s_fmc_out1,
			fmc_out_dir_i  => s_fmc_dir1
		);

	cmp_fmc_idelay : fmc_adapter_idelay
		generic map(
			g_idelay_map => c_adc_iodelaymap
		)
		port map(
			fmc_in            => s_fmc_in1,
			fmc_out           => s_fmc_in2,
			idelay_ctrl_in_i  => s_idelay_ctrl_in,
			idelay_ctrl_out_o => s_idelay_ctrl_out
		);

	cmp_fmc_iddr : fmc_adapter_iddr
		generic map(
			g_fmc_id         => g_fmc_id,
			g_fmc_map        => g_fmc_map,
			g_fmc_idelay_map => c_adc_iodelaymap
		)
		port map(
			fmc_in     => s_fmc_in2,
			fmc_out_q1 => s_fmc_in_q1,
			fmc_out_q2 => s_fmc_in_q2
		);

end Behavioral;