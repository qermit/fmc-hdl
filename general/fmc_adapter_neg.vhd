-------------------------------------------------------------------------------
-- Title      : InOut port adapter
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : fmc_adapter_io.vhd
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

use work.fmc_general_pkg.all;

entity fmc_adapter_neg is
  generic (
    g_pin_count : natural := 2;
    g_swap  : bit_vector        := "00";
    g_diff  : t_character_array := "XX";
    g_out_p : bit_vector        := "00";
    g_in_p  : bit_vector        := "00"
    );
  Port ( 
        pin_in_i_p: in std_logic;
        pin_in_o_p: out std_logic;
        
        pin_out_i_p: in std_logic;
        pin_out_o_p: out std_logic;
		
        pin_in_i_n: in std_logic;
        pin_in_o_n: out std_logic;
        
        pin_out_i_n: in std_logic;
        pin_out_o_n: out std_logic
		
    );
end fmc_adapter_neg;

architecture Behavioral of fmc_adapter_neg is


	
	
	component fmc_pinpair_neg
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
    end component;
    
    
begin

GEN_DIFF: for I in 0 to g_pin_count-1 generate
GEN_PINPAIR_X : if g_diff(I)='1' or g_diff(I)='0' generate

  -- negation only diferential pairs (and positive singleended)
  u_pinpair_neg_X: fmc_pinpair_neg 
        generic map (
          g_swap  => g_swap(I),
          g_diff => g_diff(I),
          g_in_p => g_in_p(I),
          g_out_p => g_out_p(I)
        )
        Port map ( 
          pin_in_i => pin_in_i_p(I),
          pin_in_o => pin_in_o_p(I),
        
          pin_out_i => pin_out_i_p(I),
          pin_out_o => pin_out_o_p(I)
        );      
        
   -- negative singleended, never negated
   pin_in_o_p(I) <= pin_in_i_p(I);
   pin_out_o_p(I) <= pin_out_i_p(I);
   
   
end generate GEN_PINPAIR_X;
end generate GEN_DIFF;

end Behavioral;
