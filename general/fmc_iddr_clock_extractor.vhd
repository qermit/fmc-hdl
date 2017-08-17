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
library UNISIM;
use UNISIM.VComponents.all;
use work.fmc_general_pkg.all;

entity fmc_iddr_clock_extractor is
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
end fmc_iddr_clock_extractor;

architecture RTL of fmc_iddr_clock_extractor is

    
	signal s_clk : std_logic;
	attribute keep:string;
    attribute keep of s_clk :signal is "true";
    
	signal s_fmc_in: t_fmc_signals_in;
    constant c_iddr_clk: t_iddr_map:= fmc_iddr_get_index(16, g_fmc_iddr_map);
begin

    s_fmc_in <= fmc_in;
    
    G1 : for j in g_fmc_iddr_map'range generate
            constant iddr_map: t_iddr_map := g_fmc_iddr_map(j);
            constant iob_index : t_pin_index := g_fmc_iddr_map(j).iob_index;
            signal s_data : std_logic;
     begin
        -- todo fix negation
        s_data <= s_fmc_in.LA_p(iob_index) when iddr_map.iob_type = LA else
              s_fmc_in.HA_p(iob_index) when iddr_map.iob_type = HA else
              s_fmc_in.HB_p(iob_index) when iddr_map.iob_type = HB else '0';
              
    GEN_CLK : if iddr_map.index = 16 generate
--       signal tmp_clk: std_logic;
--       signal tmp_data: std_logic;
    begin
      s_clk <= s_data;
--       tmp_data <= s_data;       
--        BUFG_clk : BUFR
--        port map (
--	      O => tmp_clk,
--	      I => tmp_data,
--	      ce => '1'
--	    );	    
--	    s_clk <= tmp_clk  xor to_stdulogic(iddr_map.negation) ;
	end generate;
	
	GEN_DATA : if iddr_map.index /= 16 generate
	  signal tmp_q1 : std_logic;
      signal tmp_q2 : std_logic; 
	begin
      cmp_la_p_iddr_x : IDDR
         generic map(
            DDR_CLK_EDGE => "SAME_EDGE_PIPELINED"
         )
         port map(
            Q1 => tmp_q1,
            Q2 => tmp_q2,
            C  => s_clk,
            CE => '1',
            D  => s_data,
            R  => '0',
            S  => '0'
        );
        q1(iddr_map.index) <= tmp_q1 xor to_stdulogic(iddr_map.negation);
        q2(iddr_map.index) <= tmp_q2 xor to_stdulogic(iddr_map.negation);
	end generate;
    end generate;

	clk_o <= s_clk;

end architecture RTL;
