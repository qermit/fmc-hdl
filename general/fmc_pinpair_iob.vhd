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
-- 
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
    g_out_n : bit := '0'
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
   
begin


GEN_EMPTY: if g_diff='X' or g_diff = 'x' generate
  fmc_p_io <= 'Z';
  fmc_n_io <= 'Z';
  fmc_p_o <= '0';
  fmc_n_o <= '0';
end generate GEN_EMPTY;

GEN_SINGLE: if g_diff = '0' generate

  fmc_p_io <= fmc_p_i when g_swap = '0' and ((g_out_p = '1' and g_in_p = '1' and fmc_p_dir = '1') or (g_out_p = '1' and g_in_p = '0')) else 
              fmc_n_i when g_swap = '1' and ((g_out_n = '1' and g_in_n = '1' and fmc_n_dir = '1') or (g_out_n = '1' and g_in_n = '0')) else
              'Z';

  fmc_n_io <= fmc_n_i when g_swap = '0' and ((g_out_n = '1' and g_in_n = '1' and fmc_n_dir = '1') or (g_out_n = '1' and g_in_n = '0')) else 
              fmc_p_i when g_swap = '1' and ((g_out_p = '1' and g_in_p = '1' and fmc_p_dir = '1') or (g_out_p = '1' and g_in_p = '0')) else
              'Z';

  fmc_p_o <=  fmc_p_io when g_swap = '0' and (g_in_p = '1') else
              fmc_n_io when g_swap = '1' and (g_in_p = '1') else
              '0';

  fmc_n_o <=  fmc_n_io when g_swap = '0' and (g_in_n = '1') else
              fmc_p_io when g_swap = '1' and (g_in_n = '1') else
              '0';

end generate GEN_SINGLE;


GEN_DIFF: if g_diff = '1' generate
GEN_DIF_IN: if g_in_p = '1' and g_out_p = '0' generate

  cmp_ibuf : IBUFDS
    generic map(
      IOSTANDARD => "DEFAULT"
      )
    port map(
      I  => fmc_p_io,
      IB => fmc_n_io,
      O  => fmc_p_o
      );
		
    --fmc_p_o <= s_raw_out  xor To_StdULogic(g_swap);
    --fmc_n_o <= 'X';
            
end generate GEN_DIF_IN;
        
GEN_DIF_OUT: if g_in_p = '0' and g_out_p = '1' generate

  --s_raw_in <= fmc_p_i xor To_StdULogic(g_swap);

  cmp_obuf : OBUFDS
    generic map(
      IOSTANDARD => "DEFAULT"
      )
    port map(
      O  => fmc_p_io,
      OB => fmc_n_io,
      I  => fmc_p_i
      );

end generate GEN_DIF_OUT;
           
GEN_DIF_INOUT: if g_in_p = '1' and g_out_p = '1'  generate

  cmp_obuf : IOBUFDS
    generic map(
      IOSTANDARD => "DEFAULT"
      )
    port map(
      IO  => fmc_p_io,
      IOB => fmc_n_io,
      I   => fmc_p_i,
      O   => fmc_p_o,
      T   => fmc_p_dir
      );
      
end generate GEN_DIF_INOUT;
	       
end generate GEN_DIFF;

end architecture;
