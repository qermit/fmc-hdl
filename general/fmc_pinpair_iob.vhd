-------------------------------------------------------------------------------
-- Title      : InOut pin pair adapter (Xilinx version)
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : fmc_pinpair_io.vhd
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2015-09-11
-- Last update: 2016-02-10
-- Platform   : FPGA-generics
-- Standard   : VHDL
-------------------------------------------------------------------------------
-- Description:
-- 
--  todo: altera version (alt_outbuf_tri_diff, ...)
-------------------------------------------------------------------------------
-- Copyright (c) 2016 Piotr Miedzik
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

use work.fmc_general_pkg.all;

entity fmc_pinpair_iob is
  generic (
    g_swap : bit := '0';
    g_diff    : character := 'X';
  
    g_in_p  : bit := '0' ;
    g_out_p : bit := '0';
    g_in_n  : bit := '0' ;
    g_out_n : bit := '0' ;
        test_1   : boolean := false
    );
  Port ( 
    fmc_p_io: inout std_logic;
    fmc_n_io: inout std_logic;
        
    fmc_p_i: in std_logic;
    fmc_n_i: in std_logic;
		
    fmc_p_dir: in std_logic := '0';
    fmc_n_dir: in std_logic := '0';
                
    fmc_p_o :out std_logic;		  
    fmc_n_o :out std_logic
    );
end fmc_pinpair_iob;

architecture rtl  of fmc_pinpair_iob is

constant c_swap : bit := '0'; -- swap is done in pin generation
begin


GEN_EMPTY: if g_diff='X' or g_diff = 'x' generate
  fmc_p_io <= 'Z';
  fmc_n_io <= 'Z';
  fmc_p_o <= '0';
  fmc_n_o <= '0';
end generate GEN_EMPTY;



GEN_SINGLE: if g_diff = '0' generate
  signal T_p: std_logic;
  signal T_n: std_logic;
begin

   T_p <= '0' when ((g_out_p = '1' and g_in_p = '1' and fmc_p_dir = '0') or (g_out_p = '1' and g_in_p = '0')) else '1';
   T_n <= '0' when ((g_out_n = '1' and g_in_n = '1' and fmc_n_dir = '0') or (g_out_n = '1' and g_in_n = '0')) else '1';
   
   IOBUF_p : IOBUF
   port map (
      O  => fmc_p_o,   -- Buffer output
      IO => fmc_p_io,  -- Buffer inout port (connect directly to top-level port)
      I  => fmc_p_i,   -- Buffer input
      T  => T_p        -- 3-state enable input, high=input, low=output 
   );
   
   IOBUF_n : IOBUF
   port map (
      O  => fmc_n_o,   -- Buffer output
      IO => fmc_n_io,  -- Buffer inout port (connect directly to top-level port)
      I  => fmc_n_i,   -- Buffer input
      T  => T_n        -- 3-state enable input, high=input, low=output 
   );

end generate GEN_SINGLE;


GEN_DIFF: if g_diff = '1' generate
  signal tmp_sig: std_logic;
  signal tmp_sig_negated: std_logic;
  signal tmp_t: std_logic;
begin

  fmc_p_o <=  tmp_sig when g_in_p = '1' and g_swap = '0' else
              tmp_sig_negated when g_in_p = '1' and g_swap = '1' else
              '0';
              
  fmc_n_o <=  '0';
  
  tmp_t <= fmc_p_dir when g_out_p = '1'  else '1';  

GEN_DIFF_I: if g_in_p = '1' and g_out_p = '0' GENERATE

  cmp_iobufds : IBUFDS_DIFF_OUT
    generic map(
      IOSTANDARD => "DEFAULT",
      DIFF_TERM => TRUE,
      IBUF_LOW_PWR => FALSE
      )
    port map(
      I  => fmc_p_io,
      IB => fmc_n_io,
      O   => tmp_sig,
      OB  => tmp_sig_negated
      );


end generate;

GEN_DIFF_O: if g_in_p = '0' and g_out_p = '1' GENERATE

  cmp_obufds : OBUFTDS
    generic map(
      IOSTANDARD => "DEFAULT"
      )
    port map(
      I  => fmc_p_i,
      O   => fmc_p_io,
      OB  => fmc_n_io,
      T => tmp_t
      );


end generate;


GEN_DIFF_IO: if g_in_p = '1' and g_out_p = '1' GENERATE

  cmp_iobufds : IOBUFDS_DIFF_OUT
    generic map(
      IOSTANDARD => "DEFAULT",
      DIFF_TERM => TRUE,
      IBUF_LOW_PWR => FALSE
      )
    port map(
      IO  => fmc_p_io,
      IOB => fmc_n_io,
      I  => fmc_p_i,
      O   => tmp_sig,
      OB  => tmp_sig_negated,
      TM => tmp_t,
      TS => tmp_t
      );
end generate;

	       
end generate GEN_DIFF;

end architecture;
