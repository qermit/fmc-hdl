-------------------------------------------------------------------------------
-- Title      : Wishbone decoupling module
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : xwb_decoupler.vhd
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2017-07-21
-- Last update: 2017-07-21
-- Platform   : FPGA-generics
-- Standard   : VHDL
-------------------------------------------------------------------------------
-- Description:
-- 
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2017 Piotr Miedzik
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.wishbone_pkg.all;


entity xwb_decoupler is
  Port (
    enable_i      : in std_logic;
	
	--== Wishbone ==--	
	s_wb_m2s      : in  t_wishbone_slave_in;
    s_wb_s2m      : out t_wishbone_slave_out;

	m_wb_m2s       : out t_wishbone_slave_in;
    m_wb_s2m       : in  t_wishbone_slave_out
    
    );
end xwb_decoupler;

architecture Behavioral of xwb_decoupler is  
  

begin

-- block valid all transfers
  m_wb_m2s.cyc <= s_wb_m2s.cyc when enable_i = '1' else '0';
  m_wb_m2s.stb <= s_wb_m2s.stb when enable_i = '1' else '0';
  m_wb_m2s.adr <= s_wb_m2s.adr;
  m_wb_m2s.sel <= s_wb_m2s.sel;
  m_wb_m2s.we  <= s_wb_m2s.we;
  m_wb_m2s.dat <= s_wb_m2s.dat;

  -- avoid bus locking
  s_wb_s2m.ack   <= m_wb_s2m.ack when enable_i = '1' else '1';
  s_wb_s2m.err   <= m_wb_s2m.err;
  s_wb_s2m.rty   <= m_wb_s2m.rty;
  s_wb_s2m.stall <= m_wb_s2m.stall when enable_i = '1' else '0';
  s_wb_s2m.int   <= m_wb_s2m.int;
  s_wb_s2m.dat   <= m_wb_s2m.dat;
    
 
end Behavioral;
