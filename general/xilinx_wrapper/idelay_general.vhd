------------------------------------------------------------------------------
-- Title      : idelay_general (xilinx)
------------------------------------------------------------------------------
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2016-03-07
-- Platform   : FPGA-generic
-------------------------------------------------------------------------------
-- Description: xilinx implementation of idelay_general 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 GSI
-- Licensed under GNU Lesser General Public License (LGPL) v3.0
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

use work.fmc_general_pkg.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity idelay_general is
	generic(g_use_iob : boolean := true;
		    g_is_clk  : boolean := false;
		    g_index   : natural := 0;
		    g_group_name: string := "");
	port(idata_in      : in  std_logic;
		 idata_out     : out std_logic;
		 idelay_clk_i  : in std_logic;
		 idelay_ctrl_i : in  t_fmc_idelay_in;
		 idelay_ctrl_o : out t_fmc_idelay_out);
end idelay_general;
  	
architecture RTL of idelay_general is
	signal s_cntvalueout : std_logic_vector(4 downto 0);
	
	signal s_idatain: std_logic;
	signal s_datain: std_logic;
	
	signal s_ld: std_logic;
	signal s_ce: std_logic;
	signal s_regrst : std_logic := '0';
	signal s_ldpipen : std_logic := '0';
	
	function isclk2str (constant is_clk : in boolean)
		return string is
	
	begin
		if is_clk = true then
			return "CLOCK";
		end if;
			
		return "DATA";
	end function isclk2str;
	
	
	function useiob2str (constant g_use_iob : in boolean)
		return string is
	
	begin
		if g_use_iob = true then
			return "IDATAIN";
		end if;
			
		return "DATAIN";
	end function useiob2str;
	
	attribute IODELAY_GROUP : string;
	attribute IODELAY_GROUP of cmp_idelay : label is g_group_name;
	
	 
begin
	s_idatain <= idata_in when g_use_iob = true else '0';
	s_datain <= idata_in when g_use_iob = false else '0';
	s_ld <= idelay_ctrl_i.ld when g_is_clk = true and  idelay_ctrl_i.clk_sel = '1' else
			idelay_ctrl_i.ld when g_is_clk = false and  idelay_ctrl_i.data_sel(g_index) = '1' else
			'0';
	s_ce <= idelay_ctrl_i.ce when g_is_clk = true and  idelay_ctrl_i.clk_sel = '1' else
			idelay_ctrl_i.ce when g_is_clk = false and  idelay_ctrl_i.data_sel(g_index) = '1' else
			'0';
	
	idelay_ctrl_o.cntvalueout <= s_cntvalueout when g_is_clk = true  and idelay_ctrl_i.clk_sel = '1' else
						         s_cntvalueout when g_is_clk = false and idelay_ctrl_i.data_sel(g_index) = '1' else
						      (others => '0');
	
	--s_regrst <= idelay_ctrl_i.
	
	cmp_idelay : IDELAYE2
		generic map(
			CINVCTRL_SEL          => "FALSE",
			DELAY_SRC             => useiob2str(g_use_iob),
			HIGH_PERFORMANCE_MODE => "TRUE",
			IDELAY_TYPE           => "VAR_LOAD",
			IDELAY_VALUE          => 0,
			PIPE_SEL              => "FALSE",
			REFCLK_FREQUENCY      => 200.0,
			SIGNAL_PATTERN        => isclk2str(g_is_clk)
		)
		port map(
			CNTVALUEOUT => s_cntvalueout,
			DATAOUT     => idata_out,
			C           => idelay_clk_i,
			CE          => s_ce,
			CINVCTRL    => '0',
			CNTVALUEIN  => idelay_ctrl_i.cntvaluein,
			DATAIN      => s_datain,
			IDATAIN     => s_idatain,
			INC         => idelay_ctrl_i.inc,
			LD          => s_ld,
			LDPIPEEN    => s_ldpipen,
			REGRST      => s_regrst
		);
	
end architecture RTL;
