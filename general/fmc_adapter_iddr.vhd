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
		fmc_in  : in  t_fmc_signals_in;
		sdr_q   : out t_fmc_signals_in; -- provide all to output as they are

		ddr_clk : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0);
		ddr_q1  : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) * 8 - 1 downto 0);
		ddr_q2  : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) * 8 - 1 downto 0)
	);
end fmc_adapter_iddr;

architecture Behavioral of fmc_adapter_iddr is
	component fmc_iddr_clock_extractor
	generic(
		g_fmc_iddr_map : t_iddr_map_vector;
        g_fmc_id       : natural := 1;
        g_group_id     : natural := 0
    );
    port(
        fmc_in : in  t_fmc_signals_in;
        clk_o  : out std_logic;
        q1     : out std_logic_vector(7 downto 0);
        q2     : out std_logic_vector(7 downto 0)
    );
	end component fmc_iddr_clock_extractor;

	constant c_ddr_groups : natural := fmc_iodelay_group_count(g_fmc_idelay_map);

	signal s_iddr_clk : std_logic_vector(c_ddr_groups - 1 downto 0);
	
    signal s_iddr_q1: std_logic_vector(c_ddr_groups * 8 - 1 downto 0);
    signal s_iddr_q2: std_logic_vector(c_ddr_groups * 8 - 1 downto 0);

    signal s_fmc_in: t_fmc_signals_in;
    
    
begin

    s_fmc_in <= fmc_in;
    
    GEN_GROUPS: for i in ddr_clk'range generate
	  cmp_clk_ext : fmc_iddr_clock_extractor
		generic map(
			g_fmc_iddr_map => fmc_iddr_extract_group(group_id => i, iodelay_map =>g_fmc_idelay_map, fmc_id=> g_fmc_id, fmc_map=> g_fmc_map),
			g_fmc_id => g_fmc_id,
			g_group_id => i
		)
		port map(
			fmc_in => s_fmc_in,
			clk_o  => s_iddr_clk(i),
			q1 => s_iddr_q1((8*(i+1))-1 downto (8*i)),
			q2 => s_iddr_q2((8*(i+1))-1 downto (8*i))
		);
    end generate;
    
    ddr_clk <= s_iddr_clk;
    ddr_q1 <= s_iddr_q1;
    ddr_q2 <= s_iddr_q2;

  -- route all inputs to SDRoutputs
	GEN_LA : for i in fmc_in.LA_p'range generate
    begin
      sdr_q.LA_p(i) <= fmc_in.LA_p(i);
	  sdr_q.LA_n(i) <= fmc_in.LA_n(i);
	end generate GEN_LA;

	GEN_HPC : if g_fmc_connector = FMC_HPC or g_fmc_connector = FMC_PLUS generate
	  GEN_HA : for i in fmc_in.HA_p'range generate
        sdr_q.HA_p(i) <= fmc_in.HA_p(i);
        sdr_q.HA_n(i) <= fmc_in.HA_n(i);
      end generate GEN_HA;
      GEN_HB : for i in fmc_in.HB_p'range generate
        sdr_q.HB_p(i) <= fmc_in.HB_p(i);
        sdr_q.HB_n(i) <= fmc_in.HB_n(i);
      end generate GEN_HB;
    end generate GEN_HPC;

end Behavioral;