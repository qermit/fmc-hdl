------------------------------------------------------------------------------
-- Title      : fmc_adapter_iddr
------------------------------------------------------------------------------
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2016-03-07
-- Platform   : FPGA-generic
-------------------------------------------------------------------------------
-- Description: FMC adapter with input DDR 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 GSI
-- Licensed under GNU Lesser General Public License (LGPL) v3.0
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

use work.fmc_general_pkg.all;

use work.fmc_adc_250m_16b_4cha_pkg.all;
use work.afc_pkg.all;
use work.fmc_general_pkg.all;

entity fmc_adapter_iddr is
	generic(
		g_fmc_id    : natural := 1;
		g_fmc_map   : t_fmc_pin_map_vector := afc_v2_FMC_pinmap;
		g_fmc_idelay_map: t_iodelay_map_vector := adc_250m_pin_map
	);
	Port(
		fmc_in     : in  t_fmc_signals_in;
		fmc_out_q1    : out t_fmc_signals_in;
		fmc_out_q2    : out t_fmc_signals_in
	);
end fmc_adapter_iddr;

architecture Behavioral of fmc_adapter_iddr is
	
	component fmc_iddr_clock_extractor
		generic(   g_fmc_idelay_map : t_iodelay_map_vector);
		port(fmc_in : in  t_fmc_signals_in;
			 clk_o  : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0));
	end component fmc_iddr_clock_extractor;
	
	constant c_ddr_groups : natural := fmc_iodelay_group_count(g_fmc_idelay_map);
	
	signal s_iddr_clk: std_logic_vector(c_ddr_groups-1 downto 0);
	
begin
	
	cmp_clk_ext: fmc_iddr_clock_extractor
		generic map(
			g_fmc_idelay_map => g_fmc_idelay_map
		)
		port map(
			fmc_in => fmc_in,
			clk_o  => s_iddr_clk
		);
	
	GEN_LA : for i in fmc_in.LA_p'range generate
		constant pin_type        : t_fmc_pin_type := LA;
		constant current_fmc_pin : t_fmc_pin_map  := fmc_pin_map_extract_fmc_pin(fmc_id => g_fmc_id, pin_type => pin_type, pin_index => i, fmc_pin_map => g_fmc_map);
		constant current_idelay  : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
	begin
		
		GEN_BYPASS_SINGLE : if (current_idelay.iob_diff /= DIFF and current_idelay.iob_iddr = '0') or current_idelay.group_id = -1 generate
						fmc_out_q1.LA_p(i) <= fmc_in.LA_p(i);
			fmc_out_q1.LA_n(i) <= fmc_in.LA_n(i);
		end generate;
		GEN_IDDR_SINGLE : if current_idelay.iob_diff /= DIFF and current_idelay.iob_iddr = '1' generate
			
		end generate;

		GEN_BYPASS_DIFF : if current_idelay.iob_diff = DIFF and current_idelay.iob_iddr = '0' generate
			fmc_out_q1.LA_p(i) <= fmc_in.LA_p(i) xor TO_STDULOGIC(current_fmc_pin.iob_swap);
			
		end generate;
		GEN_IDDR_DIFF : if current_idelay.iob_diff = DIFF and current_idelay.iob_iddr = '1' generate
			signal tmp_q1: std_logic;
			signal tmp_q2: std_logic;
		begin
			cmp_iddr_x: IDDR
				port map(
					Q1 => tmp_q1,
					Q2 => tmp_q2,
					C  => s_iddr_clk(current_idelay.group_id),
					CE => '1',
					D  => fmc_in.LA_p(i),
					R  => '1',
					S  => '0'
				);
			fmc_out_q1.LA_p(i) <= tmp_q1 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
			fmc_out_q2.LA_p(i) <= tmp_q2 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
		end generate;
	end generate GEN_LA;
	
	
	
	GEN_HA : for i in fmc_in.HA_p'range generate
		constant pin_type        : t_fmc_pin_type := HA;
		constant current_fmc_pin : t_fmc_pin_map  := fmc_pin_map_extract_fmc_pin(fmc_id => g_fmc_id, pin_type => pin_type, pin_index => i, fmc_pin_map => g_fmc_map);
		constant current_idelay  : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
	begin
		GEN_BYPASS_SINGLE : if (current_idelay.iob_diff /= DIFF and current_idelay.iob_iddr = '0') or current_idelay.group_id = -1 generate
			fmc_out_q1.HA_p(i) <= fmc_in.HA_p(i);
			fmc_out_q1.HA_n(i) <= fmc_in.HA_n(i);
		end generate;
		GEN_IDDR_SINGLE : if current_idelay.iob_diff /= DIFF and current_idelay.iob_iddr = '1' generate
			
		end generate;

		GEN_BYPASS_DIFF : if current_idelay.iob_diff = DIFF and current_idelay.iob_iddr = '0' generate
			fmc_out_q1.HA_p(i) <= fmc_in.HA_p(i) xor TO_STDULOGIC(current_fmc_pin.iob_swap);			
		end generate;
		
		GEN_IDDR_DIFF : if current_idelay.iob_diff = DIFF and current_idelay.iob_iddr = '1' generate
			signal tmp_q1: std_logic;
			signal tmp_q2: std_logic;
		begin
			cmp_iddr_x: IDDR
				port map(
					Q1 => tmp_q1,
					Q2 => tmp_q2,
					C  => s_iddr_clk(current_idelay.group_id),
					CE => '1',
					D  => fmc_in.HA_p(i),
					R  => '1',
					S  => '0'
				);
			fmc_out_q1.HA_p(i) <= tmp_q1 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
			fmc_out_q2.HA_p(i) <= tmp_q2 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
		end generate;
	end generate GEN_HA;	 
	
	
		GEN_HB : for i in fmc_in.HB_p'range generate
		constant pin_type        : t_fmc_pin_type := HB;
		constant current_fmc_pin : t_fmc_pin_map  := fmc_pin_map_extract_fmc_pin(fmc_id => g_fmc_id, pin_type => pin_type, pin_index => i, fmc_pin_map => g_fmc_map);
		constant current_idelay  : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
	begin
		GEN_BYPASS_single: if (current_idelay.iob_diff /= DIFF and current_idelay.iob_iddr = '0') or current_idelay.group_id = -1 generate
			fmc_out_q1.HB_p(i) <= fmc_in.HB_p(i);
			fmc_out_q1.HB_n(i) <= fmc_in.HB_n(i);
		end generate;
			
			
		GEN_IDDR_SINGLE : if current_idelay.iob_diff /= DIFF and current_idelay.iob_iddr = '1' generate
			
		end generate;

		GEN_BYPASS_DIFF: if current_idelay.iob_diff /= DIFF and  current_idelay.iob_iddr = '0' generate
			fmc_out_q1.HB_p(i) <= fmc_in.HB_p(i) xor TO_STDULOGIC(current_fmc_pin.iob_swap);
		end generate;
		
		GEN_IDDR_DIFF : if current_idelay.iob_diff = DIFF and current_idelay.iob_iddr = '1' generate
			signal tmp_q1: std_logic;
			signal tmp_q2: std_logic;
		begin
			cmp_iddr_x: IDDR
				port map(
					Q1 => tmp_q1,
					Q2 => tmp_q2,
					C  => s_iddr_clk(current_idelay.group_id),
					CE => '1',
					D  => fmc_in.HB_p(i),
					R  => '1',
					S  => '0'
				);
				-- @todo add clock negation?
			fmc_out_q1.HB_p(i) <= tmp_q1 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
			fmc_out_q2.HB_p(i) <= tmp_q2 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
		end generate;
	end generate GEN_HB;	
	
end Behavioral;