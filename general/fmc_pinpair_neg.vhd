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

entity fmc_pinpair_neg is
  generic (
    g_swap : bit := '0';
    g_diff    : character := 'X';
  
    g_in_p  : bit := '0' ;
    g_out_p : bit := '0'

    );
 
  Port ( 
    pin_in_i: in std_logic;
    pin_in_o: out std_logic;
    
    pin_out_i: in std_logic;
    pin_out_o: out std_logic
  );
end fmc_pinpair_neg;

architecture rtl  of fmc_pinpair_neg is
   
begin

GEN_SINGLE: if g_diff = '0' generate
  pin_in_o <= pin_in_i;
  pin_out_o <= pin_out_i;
end generate GEN_SINGLE;

GEN_DIFF: if g_diff = '1' generate
GEN_DIF_IN: if g_in_p = '1' generate

    pin_in_o <= pin_in_i  xor To_StdULogic(g_swap);
            
end generate GEN_DIF_IN;
        
GEN_DIF_OUT: if g_out_p = '1' generate

  pin_out_o <= pin_out_i  xor To_StdULogic(g_swap);
  
end generate GEN_DIF_OUT;
     
end generate GEN_DIFF;

end architecture;
