------------------------------------------------------------------------------
-- Title      : FMC IDDR clock extraction module
------------------------------------------------------------------------------
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2016-03-07
-- Platform   : FPGA-generic
-------------------------------------------------------------------------------
-- Description: This module extract DDR clocks signals; 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 GSI
-- Licensed under GNU Lesser General Public License (LGPL) v3.0
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.fmc_general_pkg.all;

entity fmc_iddr_clock_extractor is
	generic(
		g_fmc_idelay_map : t_iodelay_map_vector
	);
	port(
		fmc_in : in  t_fmc_signals_in;
		clk_o  : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0)
	);
end fmc_iddr_clock_extractor;

architecture RTL of fmc_iddr_clock_extractor is
	signal s_clk : std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0);
	
	signal s_fmc_in: t_fmc_signals_in;

begin

    s_fmc_in <= fmc_in;

	GEN_CLK_X : for i in s_clk'range generate
		constant current_group : t_iodelay_map_vector := fmc_iodelay_extract_group(group_id => i, iodelay_map => g_fmc_idelay_map);
	begin
		G1 : for j in current_group'range generate
			G_LA : if current_group(j).index = 16 generate
				s_clk(i) <= s_fmc_in.LA_p(current_group(j).iob_index) when current_group(j).iob_type = LA else s_fmc_in.HA_p(current_group(j).iob_index) when current_group(j).iob_type = HA else s_fmc_in.HB_p(current_group(j).iob_index) when current_group(j).iob_type = HB else '0';
			end generate;
		end generate;

	end generate;

	clk_o <= s_clk;

end architecture RTL;
