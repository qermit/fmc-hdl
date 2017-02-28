------------------------------------------------------------------------------
-- Title      : fmc_adapter_extractor
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

entity fmc_adapter_extractor is
	generic(
        g_count_per_group: natural              := 8;
		g_fmc_id         : natural              := 1;
		g_fmc_connector  : t_fmc_connector_type := FMC_HPC;
		g_fmc_map        : t_fmc_pin_map_vector := c_fmc_pin_nullvector;
		g_fmc_idelay_map : t_iodelay_map_vector := c_iodelay_map_nullvector
	);
	Port(
		fmc_in_i     : in  t_fmc_signals_in;
		fmc_in_o     : out t_fmc_signals_in;

		fmc_groups_o : out std_logic_vector(g_count_per_group * fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0)
	);
end fmc_adapter_extractor;

architecture RTL of fmc_adapter_extractor is
    constant c_groups_count : natural := fmc_iodelay_group_count(g_fmc_idelay_map);    
	constant c_count_per_group : natural := g_count_per_group;
	signal s_fmc_groups        : std_logic_vector(c_count_per_group * c_groups_count - 1 downto 0) := ( others => '0' );
begin
	fmc_groups_o <= s_fmc_groups;
	
	
	GEN_LA : for i in fmc_in_i.LA_p'range generate
		constant tmp_map         : t_fmc_pin_map := fmc_pin_map_extract_fmc_pin(fmc_id => g_fmc_id, pin_type => LA, pin_index => i, fmc_pin_map => g_fmc_map);
		constant tmp_idelay_p    : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => LA, pin_index => i, pin_diff => POS, iodelay_map => g_fmc_idelay_map);
		constant tmp_idelay_n    : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => LA, pin_index => i, pin_diff => NEG, iodelay_map => g_fmc_idelay_map);
		constant tmp_idelay_diff : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => LA, pin_index => i, pin_diff => DIFF, iodelay_map => g_fmc_idelay_map);
	begin
		-- diff

		GEN_LA_DIFF_X : if tmp_idelay_diff.dir_type /= DIRNONE and tmp_idelay_diff.iob_ddr = '0' generate
			GEN_LA_DIFF_X1 : if tmp_idelay_diff.group_id = -1 generate
				fmc_in_o.LA_p(i) <= fmc_in_i.LA_p(i) xor to_stdulogic(tmp_map.iob_swap);
			end generate GEN_LA_DIFF_X1;
			GEN_LA_DIFF_X2 : if tmp_idelay_diff.group_id /= -1 generate
				s_fmc_groups(c_count_per_group * tmp_idelay_diff.group_id + tmp_idelay_diff.index) <= fmc_in_i.LA_p(i) xor to_stdulogic(tmp_map.iob_swap);
			end generate GEN_LA_DIFF_X2;
		end generate GEN_LA_DIFF_X;
		
		GEN_LA_POS_X : if tmp_idelay_p.dir_type /= DIRNONE and tmp_idelay_p.iob_ddr = '0' generate
			GEN_LA_POS_X1 : if tmp_idelay_p.group_id = -1 generate
				fmc_in_o.LA_p(i) <= fmc_in_i.LA_p(i);
			end generate GEN_LA_POS_X1;
			GEN_LA_POS_X2 : if tmp_idelay_p.group_id /= -1 generate
				s_fmc_groups(c_count_per_group * tmp_idelay_p.group_id + tmp_idelay_p.index) <= fmc_in_i.LA_p(i);
			end generate GEN_LA_POS_X2;
		end generate GEN_LA_POS_X;

		GEN_LA_NEG_X : if tmp_idelay_n.dir_type /= DIRNONE and tmp_idelay_n.iob_ddr = '0' generate
			GEN_LA_NEG_X1 : if tmp_idelay_n.group_id = -1 generate
				fmc_in_o.LA_n(i) <= fmc_in_i.LA_n(i);
			end generate GEN_LA_NEG_X1;
			GEN_LA_NEG_X2 : if tmp_idelay_n.group_id /= -1 generate
				s_fmc_groups(c_count_per_group * tmp_idelay_n.group_id + tmp_idelay_n.index) <= fmc_in_i.LA_n(i);
			end generate GEN_LA_NEG_X2;
		end generate GEN_LA_NEG_X;
		
	end generate GEN_LA;
	
end architecture RTL;
