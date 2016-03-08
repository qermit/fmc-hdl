----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2016 10:02:02 AM
-- Design Name: 
-- Module Name: fmc_pinpair_idelay - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.fmc_general_pkg.all;

use work.fmc_adc_250m_16b_4cha_pkg.all;

entity fmc_adapter_idelay is
	generic(
		g_fmc_connector : t_fmc_connector_type := FMC_HPC;
		g_idelay_map    : t_iodelay_map_vector := adc_250m_pin_map
	);
	Port(
		fmc_in            : in  t_fmc_signals_in;
		fmc_out           : out t_fmc_signals_in;

		idelay_ctrl_in_i  : in  t_fmc_idelay_in_array(fmc_iodelay_group_count(g_idelay_map) - 1 downto 0);
		idelay_ctrl_out_o : out t_fmc_idelay_out_array(fmc_iodelay_group_count(g_idelay_map) - 1 downto 0)
	);
end fmc_adapter_idelay;

architecture Behavioral of fmc_adapter_idelay is
	constant c_iodelay_groups : natural := fmc_iodelay_group_count(g_idelay_map);

	signal s_idelay_ctrl_array : t_fmc_idelay_out_array(20 * c_iodelay_groups - 1 downto 0);

begin
	G_LA : for i in fmc_in.LA_p'range generate
		constant pin_type       : t_fmc_pin_type := LA;
		constant c_tmp_map_p    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => POS, pin_type => pin_type, pin_index => i, iodelay_map => g_idelay_map);
		constant c_tmp_map_n    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => NEG, pin_type => pin_type, pin_index => i, iodelay_map => g_idelay_map);
		constant c_tmp_map_diff : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => DIFF, pin_type => pin_type, pin_index => i, iodelay_map => g_idelay_map);
	begin
		G_IDELAY_LA_P_X : if c_tmp_map_p.dir_type /= DIRNONE generate
			G_IDELAY_LA_P_X1 : if c_tmp_map_p.group_id /= -1 and c_tmp_map_p.iob_delay = '1' generate
				constant c_out_index : natural := c_tmp_map_p.group_id * 17 + c_tmp_map_p.index;
			begin
				cmp_idelay_la_p_x : idelay_general
					generic map(
						g_use_iob => true,
						g_is_clk  => c_tmp_map_p.index = 16,
						g_index   => c_tmp_map_p.index
					)
					port map(
						idata_in      => fmc_in.LA_p(c_tmp_map_p.iob_index),
						idata_out     => fmc_out.LA_p(c_tmp_map_p.iob_index),
						idelay_ctrl_i => idelay_ctrl_in_i(c_tmp_map_p.group_id),
						idelay_ctrl_o => s_idelay_ctrl_array(c_out_index)
					);
			end generate;
			G_IDELAY_LA_P_X2 : if c_tmp_map_p.group_id = -1 or c_tmp_map_p.iob_delay /= '1' generate
				fmc_out.LA_p(c_tmp_map_p.iob_index) <= fmc_in.LA_p(c_tmp_map_p.iob_index);
			end generate;
		end generate;

		G_IDELAY_LA_N_X : if c_tmp_map_n.dir_type /= DIRNONE generate
			G_IDELAY_LA_N_X1 : if c_tmp_map_n.group_id /= -1 and c_tmp_map_n.iob_delay = '1' generate
				constant c_out_index : natural := c_tmp_map_n.group_id * 17 + c_tmp_map_n.index;
			begin
				cmp_idelay_la_n_x : idelay_general
					generic map(
						g_use_iob => true,
						g_is_clk  => c_tmp_map_n.index = 16,
						g_index   => c_tmp_map_n.index
					)
					port map(
						idata_in      => fmc_in.LA_n(c_tmp_map_n.iob_index),
						idata_out     => fmc_out.LA_n(c_tmp_map_n.iob_index),
						idelay_ctrl_i => idelay_ctrl_in_i(c_tmp_map_n.group_id),
						idelay_ctrl_o => s_idelay_ctrl_array(c_out_index)
					);
			end generate;
			G_IDELAY_LA_N_X2 : if c_tmp_map_n.group_id = -1 or c_tmp_map_n.iob_delay /= '1' generate
				fmc_out.LA_n(c_tmp_map_n.iob_index) <= fmc_in.LA_n(c_tmp_map_n.iob_index);
			end generate;
		end generate;

		G_IDELAY_LA_D_X : if c_tmp_map_diff.dir_type /= DIRNONE generate
			G_IDELAY_LA_D_X1 : if c_tmp_map_diff.group_id /= -1 and c_tmp_map_diff.iob_delay = '1' generate
				constant c_out_index : natural := c_tmp_map_diff.group_id * 17 + c_tmp_map_diff.index;
			begin
				cmp_idelay_la_d_x : idelay_general
					generic map(
						g_use_iob => true,
						g_is_clk  => c_tmp_map_diff.index = 16,
						g_index   => c_tmp_map_diff.index
					)
					port map(
						idata_in      => fmc_in.LA_p(c_tmp_map_diff.iob_index),
						idata_out     => fmc_out.LA_p(c_tmp_map_diff.iob_index),
						idelay_ctrl_i => idelay_ctrl_in_i(c_tmp_map_diff.group_id),
						idelay_ctrl_o => s_idelay_ctrl_array(c_out_index)
					);
			end generate;
			G_IDELAY_LA_D_X2 : if c_tmp_map_diff.group_id = -1 or c_tmp_map_diff.iob_delay /= '1' generate
				fmc_out.LA_p(c_tmp_map_diff.iob_index) <= fmc_in.LA_p(c_tmp_map_diff.iob_index);
			end generate;
		end generate;

	end generate G_LA;

	GEN_HPC : if g_fmc_connector = FMC_HPC or g_fmc_connector = FMC_PLUS generate
		G_HA : for i in fmc_in.HA_p'range generate
			constant pin_type       : t_fmc_pin_type := HA;
			constant c_tmp_map_p    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => POS, pin_type => pin_type, pin_index => i, iodelay_map => g_idelay_map);
			constant c_tmp_map_n    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => NEG, pin_type => pin_type, pin_index => i, iodelay_map => g_idelay_map);
			constant c_tmp_map_diff : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => DIFF, pin_type => pin_type, pin_index => i, iodelay_map => g_idelay_map);
		begin
			G_IDELAY_HA_P_X : if c_tmp_map_p.dir_type /= DIRNONE generate
				G_IDELAY_HA_P_X1 : if c_tmp_map_p.group_id /= -1 and c_tmp_map_p.iob_delay = '1' generate
					constant c_out_index : natural := c_tmp_map_p.group_id * 17 + c_tmp_map_p.index;
				begin
					cmp_idelay_ha_p_x : idelay_general
						generic map(
							g_use_iob => true,
							g_is_clk  => c_tmp_map_p.index = 16,
							g_index   => c_tmp_map_p.index
						)
						port map(
							idata_in      => fmc_in.HA_p(c_tmp_map_p.iob_index),
							idata_out     => fmc_out.HA_p(c_tmp_map_p.iob_index),
							idelay_ctrl_i => idelay_ctrl_in_i(c_tmp_map_p.group_id),
							idelay_ctrl_o => s_idelay_ctrl_array(c_out_index)
						);
				end generate;
				G_IDELAY_HA_P_X2 : if c_tmp_map_p.group_id = -1 or c_tmp_map_p.iob_delay /= '1' generate
					fmc_out.HA_p(c_tmp_map_p.iob_index) <= fmc_in.HA_p(c_tmp_map_p.iob_index);
				end generate;
			end generate;

			G_IDELAY_HA_N_X : if c_tmp_map_n.dir_type /= DIRNONE generate
				G_IDELAY_HA_N_X1 : if c_tmp_map_n.group_id /= -1 and c_tmp_map_n.iob_delay = '1' generate
					constant c_out_index : natural := c_tmp_map_n.group_id * 17 + c_tmp_map_n.index;
				begin
					cmp_idelay_ha_n_x : idelay_general
						generic map(
							g_use_iob => true,
							g_is_clk  => c_tmp_map_n.index = 16,
							g_index   => c_tmp_map_n.index
						)
						port map(
							idata_in      => fmc_in.HA_n(c_tmp_map_n.iob_index),
							idata_out     => fmc_out.HA_n(c_tmp_map_n.iob_index),
							idelay_ctrl_i => idelay_ctrl_in_i(c_tmp_map_n.group_id),
							idelay_ctrl_o => s_idelay_ctrl_array(c_out_index)
						);
				end generate;
				G_IDELAY_HA_N_X2 : if c_tmp_map_n.group_id = -1 or c_tmp_map_n.iob_delay /= '1' generate
					fmc_out.HA_n(c_tmp_map_n.iob_index) <= fmc_in.HA_n(c_tmp_map_n.iob_index);
				end generate;
			end generate;

			G_IDELAY_HA_D_X : if c_tmp_map_diff.dir_type /= DIRNONE generate
				G_IDELAY_HA_D_X1 : if c_tmp_map_diff.group_id /= -1 and c_tmp_map_diff.iob_delay = '1' generate
					constant c_out_index : natural := c_tmp_map_diff.group_id * 17 + c_tmp_map_diff.index;
				begin
					cmp_idelay_ha_d_x : idelay_general
						generic map(
							g_use_iob => true,
							g_is_clk  => c_tmp_map_diff.index = 16,
							g_index   => c_tmp_map_diff.index
						)
						port map(
							idata_in      => fmc_in.HA_p(c_tmp_map_diff.iob_index),
							idata_out     => fmc_out.HA_p(c_tmp_map_diff.iob_index),
							idelay_ctrl_i => idelay_ctrl_in_i(c_tmp_map_diff.group_id),
							idelay_ctrl_o => s_idelay_ctrl_array(c_out_index)
						);
				end generate;
				G_IDELAY_HA_D_X2 : if c_tmp_map_diff.group_id = -1 or c_tmp_map_diff.iob_delay /= '1' generate
					fmc_out.HA_p(c_tmp_map_diff.iob_index) <= fmc_in.HA_p(c_tmp_map_diff.iob_index);
				end generate;
			end generate;

		end generate G_HA;
		
		
				G_HB : for i in fmc_in.HB_p'range generate
			constant pin_type       : t_fmc_pin_type := HB;
			constant c_tmp_map_p    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => POS, pin_type => pin_type, pin_index => i, iodelay_map => g_idelay_map);
			constant c_tmp_map_n    : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => NEG, pin_type => pin_type, pin_index => i, iodelay_map => g_idelay_map);
			constant c_tmp_map_diff : t_iodelay_map  := fmc_iodelay_extract_fmc_pin(pin_diff => DIFF, pin_type => pin_type, pin_index => i, iodelay_map => g_idelay_map);
		begin
			G_IDELAY_HB_P_X : if c_tmp_map_p.dir_type /= DIRNONE generate
				G_IDELAY_HB_P_X1 : if c_tmp_map_p.group_id /= -1 and c_tmp_map_p.iob_delay = '1' generate
					constant c_out_index : natural := c_tmp_map_p.group_id * 17 + c_tmp_map_p.index;
				begin
					cmp_idelay_hb_n_x : idelay_general
						generic map(
							g_use_iob => true,
							g_is_clk  => c_tmp_map_p.index = 16,
							g_index   => c_tmp_map_p.index
						)
						port map(
							idata_in      => fmc_in.HB_p(c_tmp_map_p.iob_index),
							idata_out     => fmc_out.HB_p(c_tmp_map_p.iob_index),
							idelay_ctrl_i => idelay_ctrl_in_i(c_tmp_map_p.group_id),
							idelay_ctrl_o => s_idelay_ctrl_array(c_out_index)
						);
				end generate;
				G_IDELAY_HB_P_X2 : if c_tmp_map_p.group_id = -1 or c_tmp_map_p.iob_delay /= '1' generate
					fmc_out.HB_p(c_tmp_map_p.iob_index) <= fmc_in.HB_p(c_tmp_map_p.iob_index);
				end generate;
			end generate;

			G_IDELAY_HB_N_X : if c_tmp_map_n.dir_type /= DIRNONE generate
				G_IDELAY_HB_N_X1 : if c_tmp_map_n.group_id /= -1 and c_tmp_map_n.iob_delay = '1' generate
					constant c_out_index : natural := c_tmp_map_n.group_id * 17 + c_tmp_map_n.index;
				begin
					cmp_idelay_hb_p_x : idelay_general
						generic map(
							g_use_iob => true,
							g_is_clk  => c_tmp_map_n.index = 16,
							g_index   => c_tmp_map_n.index
						)
						port map(
							idata_in      => fmc_in.HB_n(c_tmp_map_n.iob_index),
							idata_out     => fmc_out.HB_n(c_tmp_map_n.iob_index),
							idelay_ctrl_i => idelay_ctrl_in_i(c_tmp_map_n.group_id),
							idelay_ctrl_o => s_idelay_ctrl_array(c_out_index)
						);
				end generate;
				G_IDELAY_HB_N_X2 : if c_tmp_map_n.group_id = -1 or c_tmp_map_n.iob_delay /= '1' generate
					fmc_out.HB_n(c_tmp_map_n.iob_index) <= fmc_in.HB_n(c_tmp_map_n.iob_index);
				end generate;
			end generate;

			G_IDELAY_HB_D_X : if c_tmp_map_diff.dir_type /= DIRNONE generate
				G_IDELAY_HB_D_X1 : if c_tmp_map_diff.group_id /= -1 and c_tmp_map_diff.iob_delay = '1' generate
					constant c_out_index : natural := c_tmp_map_diff.group_id * 17 + c_tmp_map_diff.index;
				begin
					cmp_idelay_hb_d_x : idelay_general
						generic map(
							g_use_iob => true,
							g_is_clk  => c_tmp_map_diff.index = 16,
							g_index   => c_tmp_map_diff.index
						)
						port map(
							idata_in      => fmc_in.HB_p(c_tmp_map_diff.iob_index),
							idata_out     => fmc_out.HB_p(c_tmp_map_diff.iob_index),
							idelay_ctrl_i => idelay_ctrl_in_i(c_tmp_map_diff.group_id),
							idelay_ctrl_o => s_idelay_ctrl_array(c_out_index)
						);
				end generate;
				G_IDELAY_HB_D_X2 : if c_tmp_map_diff.group_id = -1 or c_tmp_map_diff.iob_delay /= '1' generate
					fmc_out.HB_p(c_tmp_map_diff.iob_index) <= fmc_in.HB_p(c_tmp_map_diff.iob_index);
				end generate;
			end generate;

		end generate G_HB;
	end generate GEN_HPC;

	G_IODELAY_GROUPS : for i in 0 to c_iodelay_groups - 1 generate
		constant c_tmp_group : t_iodelay_map_vector(fmc_iodelay_len_by_group(group_id => i, iodelay_map => g_idelay_map) - 1 downto 0) := fmc_iodelay_extract_group(group_id => i, iodelay_map => g_idelay_map);
		signal tmp_array     : t_fmc_idelay_out_array(fmc_iodelay_len_by_group(group_id => i, iodelay_map => g_idelay_map) downto 0);
		signal zero_vector_5 : std_logic_vector(4 downto 0);
	begin
		zero_vector_5                         <= "00000";
		-- todo: dodac 
		tmp_array(tmp_array'high).cntvalueout <= zero_vector_5;
		G_TMP_MERGE : for j in tmp_array'high - 1 downto 0 generate
			tmp_array(j).cntvalueout <= tmp_array(j + 1).cntvalueout or s_idelay_ctrl_array(i * 17 + c_tmp_group(j).index).cntvalueout;
		end generate;

		idelay_ctrl_out_o(i).cntvalueout <= tmp_array(0).cntvalueout;
	end generate;

end Behavioral;
