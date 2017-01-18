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

entity fmc_adapter_iddr is
	generic(
		g_fmc_id         : natural              := 1;
		g_fmc_connector  : t_fmc_connector_type := FMC_HPC;
		g_fmc_map        : t_fmc_pin_map_vector := c_fmc_pin_nullvector;
		g_fmc_idelay_map : t_iodelay_map_vector := c_iodelay_map_nullvector
	);
	Port(
		fmc_in     : in  t_fmc_signals_in;
		fmc_out_q1 : out t_fmc_signals_in;

		ddr_clk    : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0);
		q1         : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) * 8 - 1 downto 0);
		q2         : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) * 8 - 1 downto 0)
	);
end fmc_adapter_iddr;

architecture Behavioral of fmc_adapter_iddr is
	component fmc_iddr_clock_extractor
		generic(g_fmc_idelay_map : t_iodelay_map_vector);
		port(fmc_in : in  t_fmc_signals_in;
			 clk_o  : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0));
	end component fmc_iddr_clock_extractor;

	constant c_ddr_groups : natural := fmc_iodelay_group_count(g_fmc_idelay_map);

	signal s_iddr_clk : std_logic_vector(c_ddr_groups - 1 downto 0);
    signal s_iddr_q1: std_logic_vector(c_ddr_groups * 8 - 1 downto 0);
    signal s_iddr_q2: std_logic_vector(c_ddr_groups * 8 - 1 downto 0);

    signal s_fmc_in: t_fmc_signals_in;
begin

    s_fmc_in <= fmc_in;
    
	cmp_clk_ext : fmc_iddr_clock_extractor
		generic map(
			g_fmc_idelay_map => g_fmc_idelay_map
		)
		port map(
			fmc_in => s_fmc_in,
			clk_o  => s_iddr_clk
		);

    ddr_clk <= s_iddr_clk;
    q1 <= s_iddr_q1;
    q2 <= s_iddr_q2;


	GEN_LA : for i in fmc_in.LA_p'range generate
		constant pin_type            : t_fmc_pin_type := LA;
		constant current_fmc_pin     : t_fmc_pin_map  := fmc_pin_map_extract_fmc_pin(fmc_id => g_fmc_id, pin_type => pin_type, pin_index => i, fmc_pin_map => g_fmc_map);
		constant current_idelay_p    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => POS, pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
		constant current_idelay_n    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => NEG, pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
		constant current_idelay_diff : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => DIFF, pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);

        

	   begin
            --log_to_file(l_file, pin_type, current_fmc_pin, current_idelay_p, current_idelay_n, current_idelay_diff);
            
	    --assert false report "DUPAREPORT fmc_id: " & integer'image(fmc_id); 
		GEN_LA_POS : if current_idelay_p.dir_type /= DIRNONE generate
			-- ddr if group_id != -1 and iob_ddr = 1
			GEN_LA_POS_X1 : if current_idelay_p.group_id /= -1 and current_idelay_p.iob_ddr = '1' generate
				signal tmp_q1 : std_logic;
				signal tmp_q2 : std_logic;
			begin
				cmp_la_p_iddr_x : IDDR
					port map(
						Q1 => tmp_q1,
						Q2 => tmp_q2,
						C  => s_iddr_clk(current_idelay_p.group_id),
						CE => '1',
						D  => fmc_in.LA_p(i),
						R  => '1',
						S  => '0'
					);
				s_iddr_q1(current_idelay_p.group_id * 8 + current_idelay_p.index) <= tmp_q1;
				s_iddr_q2(current_idelay_p.group_id * 8 + current_idelay_p.index) <= tmp_q2;
			end generate;

			GEN_LA_POS_X2 : if current_idelay_p.group_id = -1 or current_idelay_p.iob_ddr /= '1' generate
				fmc_out_q1.LA_p(i) <= fmc_in.LA_p(i);
			end generate;
		end generate GEN_LA_POS;

		GEN_LA_NEG : if current_idelay_n.dir_type /= DIRNONE generate
			-- ddr if group_id != -1 and iob_ddr = 1
			GEN_LA_NEG_X1 : if current_idelay_n.group_id /= -1 and current_idelay_n.iob_ddr = '1' generate
				signal tmp_q1 : std_logic;
				signal tmp_q2 : std_logic;
			begin
				cmp_la_n_iddr_x : IDDR
					port map(
						Q1 => tmp_q1,
						Q2 => tmp_q2,
						C  => s_iddr_clk(current_idelay_n.group_id),
						CE => '1',
						D  => fmc_in.LA_n(i),
						R  => '1',
						S  => '0'
					);
				s_iddr_q1(current_idelay_n.group_id * 8 + current_idelay_n.index) <= tmp_q1;
				s_iddr_q2(current_idelay_n.group_id * 8 + current_idelay_n.index) <= tmp_q2;
			end generate;

			GEN_LA_NEG_X2 : if current_idelay_n.group_id = -1 or current_idelay_n.iob_ddr /= '1' generate
				fmc_out_q1.LA_n(i) <= fmc_in.LA_n(i);
			end generate;
		end generate GEN_LA_NEG;

		GEN_LA_DIFF : if current_idelay_diff.dir_type /= DIRNONE generate
			-- ddr if group_id != -1 and iob_ddr = 1
			GEN_LA_DIFF_X1 : if current_idelay_diff.group_id /= -1 and current_idelay_diff.iob_ddr = '1' and current_idelay_diff.index < 16 generate
				signal tmp_q1 : std_logic;
				signal tmp_q2 : std_logic;
			begin
				cmp_la_d_iddr_x : IDDR
					port map(
						Q1 => tmp_q1,
						Q2 => tmp_q2,
						C  => s_iddr_clk(current_idelay_diff.group_id),
						CE => '1',
						D  => fmc_in.LA_p(i),
						R  => '1',
						S  => '0'
					);
				s_iddr_q1(current_idelay_diff.group_id * 8 + current_idelay_diff.index) <= tmp_q1 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
				s_iddr_q2(current_idelay_diff.group_id * 8 + current_idelay_diff.index) <= tmp_q2 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
			end generate;

			GEN_LA_DIFF_X2 : if current_idelay_diff.group_id = -1 or current_idelay_diff.iob_ddr /= '1' generate
				fmc_out_q1.LA_p(i) <= fmc_in.LA_p(i);
			end generate;
		end generate GEN_LA_DIFF;

	end generate GEN_LA;

	GEN_HPC : if g_fmc_connector = FMC_HPC or g_fmc_connector = FMC_PLUS generate
		GEN_HA : for i in fmc_in.HA_p'range generate
			constant pin_type            : t_fmc_pin_type := HA;
			constant current_fmc_pin     : t_fmc_pin_map  := fmc_pin_map_extract_fmc_pin(fmc_id => g_fmc_id, pin_type => pin_type, pin_index => i, fmc_pin_map => g_fmc_map);
			constant current_idelay_p    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => POS, pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
			constant current_idelay_n    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => NEG, pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
			constant current_idelay_diff : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => DIFF, pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
		begin
			GEN_HA_POS : if current_idelay_p.dir_type /= DIRNONE generate
				-- ddr if group_id != -1 and iob_ddr = 1
				GEN_HA_POS_X1 : if current_idelay_p.group_id /= -1 and current_idelay_p.iob_ddr = '1' generate
					signal tmp_q1 : std_logic;
					signal tmp_q2 : std_logic;
				begin
					cmp_ha_p_iddr_x : IDDR
						port map(
							Q1 => tmp_q1,
							Q2 => tmp_q2,
							C  => s_iddr_clk(current_idelay_p.group_id),
							CE => '1',
							D  => fmc_in.HA_p(i),
							R  => '1',
							S  => '0'
						);
					s_iddr_q1(current_idelay_p.group_id * 8 + current_idelay_p.index) <= tmp_q1;
					s_iddr_q2(current_idelay_p.group_id * 8 + current_idelay_p.index) <= tmp_q2;
				end generate;

				GEN_LA_POS_X2 : if current_idelay_p.group_id = -1 or current_idelay_p.iob_ddr /= '1' generate
					fmc_out_q1.HA_p(i) <= fmc_in.HA_p(i);
				end generate;
			end generate GEN_HA_POS;

			GEN_HA_NEG : if current_idelay_n.dir_type /= DIRNONE generate
				-- ddr if group_id != -1 and iob_ddr = 1
				GEN_HA_NEG_X1 : if current_idelay_n.group_id /= -1 and current_idelay_n.iob_ddr = '1' generate
					signal tmp_q1 : std_logic;
					signal tmp_q2 : std_logic;
				begin
					cmp_ha_n_iddr_x : IDDR
						port map(
							Q1 => tmp_q1,
							Q2 => tmp_q2,
							C  => s_iddr_clk(current_idelay_n.group_id),
							CE => '1',
							D  => fmc_in.HA_n(i),
							R  => '1',
							S  => '0'
						);
					s_iddr_q1(current_idelay_n.group_id * 8 + current_idelay_n.index) <= tmp_q1;
					s_iddr_q2(current_idelay_n.group_id * 8 + current_idelay_n.index) <= tmp_q2;
				end generate;

				GEN_HA_NEG_X2 : if current_idelay_n.group_id = -1 or current_idelay_n.iob_ddr /= '1' generate
					fmc_out_q1.HA_n(i) <= fmc_in.HA_n(i);
				end generate;
			end generate GEN_HA_NEG;

			GEN_HA_DIFF : if current_idelay_diff.dir_type /= DIRNONE generate
				-- ddr if group_id != -1 and iob_ddr = 1
				GEN_HA_DIFF_X1 : if current_idelay_diff.group_id /= -1 and current_idelay_diff.iob_ddr = '1'  and current_idelay_diff.index < 16  generate
					signal tmp_q1 : std_logic;
					signal tmp_q2 : std_logic;
				begin
					cmp_ha_d_iddr_x : IDDR
						port map(
							Q1 => tmp_q1,
							Q2 => tmp_q2,
							C  => s_iddr_clk(current_idelay_diff.group_id),
							CE => '1',
							D  => fmc_in.HA_p(i),
							R  => '1',
							S  => '0'
						);
					s_iddr_q1(current_idelay_diff.group_id * 8 + current_idelay_diff.index) <= tmp_q1 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
					s_iddr_q2(current_idelay_diff.group_id * 8 + current_idelay_diff.index) <= tmp_q2 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
				end generate;

				GEN_HA_DIFF_X2 : if current_idelay_diff.group_id = -1 or current_idelay_diff.iob_ddr /= '1' generate
					fmc_out_q1.HA_p(i) <= fmc_in.HA_p(i);
				end generate;
			end generate GEN_HA_DIFF;

		end generate GEN_HA;

		GEN_HB : for i in fmc_in.HB_p'range generate
			constant pin_type            : t_fmc_pin_type := HB;
			constant current_fmc_pin     : t_fmc_pin_map  := fmc_pin_map_extract_fmc_pin(fmc_id => g_fmc_id, pin_type => pin_type, pin_index => i, fmc_pin_map => g_fmc_map);
			constant current_idelay_p    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => POS, pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
			constant current_idelay_n    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => NEG, pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
			constant current_idelay_diff : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => DIFF, pin_type => pin_type, pin_index => i, iodelay_map => g_fmc_idelay_map);
		begin
			GEN_HB_POS : if current_idelay_p.dir_type /= DIRNONE generate
				-- ddr if group_id != -1 and iob_ddr = 1
				GEN_HB_POS_X1 : if current_idelay_p.group_id /= -1 and current_idelay_p.iob_ddr = '1' generate
					signal tmp_q1 : std_logic;
					signal tmp_q2 : std_logic;
				begin
					cmp_hb_p_iddr_x : IDDR
						port map(
							Q1 => tmp_q1,
							Q2 => tmp_q2,
							C  => s_iddr_clk(current_idelay_p.group_id),
							CE => '1',
							D  => fmc_in.HB_p(i),
							R  => '1',
							S  => '0'
						);
					s_iddr_q1(current_idelay_p.group_id * 8 + current_idelay_p.index) <= tmp_q1;
					s_iddr_q2(current_idelay_p.group_id * 8 + current_idelay_p.index) <= tmp_q2;
				end generate;

				GEN_LA_POS_X2 : if current_idelay_p.group_id = -1 or current_idelay_p.iob_ddr /= '1' generate
					fmc_out_q1.HB_p(i) <= fmc_in.HB_p(i);
				end generate;
			end generate GEN_HB_POS;

			GEN_HB_NEG : if current_idelay_n.dir_type /= DIRNONE generate
				-- ddr if group_id != -1 and iob_ddr = 1
				GEN_HB_NEG_X1 : if current_idelay_n.group_id /= -1 and current_idelay_n.iob_ddr = '1' generate
					signal tmp_q1 : std_logic;
					signal tmp_q2 : std_logic;
				begin
					cmp_hb_n_iddr_x : IDDR
						port map(
							Q1 => tmp_q1,
							Q2 => tmp_q2,
							C  => s_iddr_clk(current_idelay_n.group_id),
							CE => '1',
							D  => fmc_in.HB_n(i),
							R  => '1',
							S  => '0'
						);
					s_iddr_q1(current_idelay_n.group_id * 8 + current_idelay_n.index) <= tmp_q1;
					s_iddr_q2(current_idelay_n.group_id * 8 + current_idelay_n.index) <= tmp_q2;
				end generate;

				GEN_HB_NEG_X2 : if current_idelay_n.group_id = -1 or current_idelay_n.iob_ddr /= '1' generate
					fmc_out_q1.HB_n(i) <= fmc_in.HB_n(i);
				end generate;
			end generate GEN_HB_NEG;

			GEN_HB_DIFF : if current_idelay_diff.dir_type /= DIRNONE generate
				-- ddr if group_id != -1 and iob_ddr = 1
				GEN_HB_DIFF_X1 : if current_idelay_diff.group_id /= -1 and current_idelay_diff.iob_ddr = '1'  and current_idelay_diff.index < 16 generate
					signal tmp_q1 : std_logic;
					signal tmp_q2 : std_logic;
				begin
					cmp_hb_d_iddr_x : IDDR
						port map(
							Q1 => tmp_q1,
							Q2 => tmp_q2,
							C  => s_iddr_clk(current_idelay_diff.group_id),
							CE => '1',
							D  => fmc_in.HB_p(i),
							R  => '1',
							S  => '0'
						);
					s_iddr_q1(current_idelay_diff.group_id * 8 + current_idelay_diff.index) <= tmp_q1 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
					s_iddr_q2(current_idelay_diff.group_id * 8 + current_idelay_diff.index) <= tmp_q2 xor TO_STDULOGIC(current_fmc_pin.iob_swap);
				end generate;

				GEN_HA_DIFF_X2 : if current_idelay_diff.group_id = -1 or current_idelay_diff.iob_ddr /= '1' generate
					fmc_out_q1.HB_p(i) <= fmc_in.HB_p(i);
				end generate;
			end generate GEN_HB_DIFF;

		end generate GEN_HB;
	end generate;

end Behavioral;