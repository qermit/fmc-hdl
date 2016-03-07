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

entity fmc_adapter_simple is
  generic (
    g_pin_count : natural := 2;
    g_swap  : bit_vector        := "00";
    g_diff  : t_character_array := "XX";
    g_out_p : bit_vector        := "00";
    g_in_p  : bit_vector        := "00";
    g_out_n : bit_vector        := "00";
    g_in_n  : bit_vector        := "00"        
    );
  Port ( 
    port_io_p : inout STD_LOGIC_VECTOR (g_pin_count-1 downto 0);
    port_io_n : inout STD_LOGIC_VECTOR (g_pin_count-1 downto 0);
    
    output_i_p : in STD_LOGIC_VECTOR (g_pin_count-1 downto 0);
    output_i_n : in STD_LOGIC_VECTOR (g_pin_count-1 downto 0);
    dir_i_p : in STD_LOGIC_VECTOR (g_pin_count-1 downto 0);
    dir_i_n : in STD_LOGIC_VECTOR (g_pin_count-1 downto 0);
    input_o_p : out STD_LOGIC_VECTOR (g_pin_count-1 downto 0);
    input_o_n : out STD_LOGIC_VECTOR (g_pin_count-1 downto 0)
    );
end fmc_adapter_simple;

architecture Behavioral of fmc_adapter_simple is

component fmc_pinpair_iob
  generic (
    g_swap : bit := '0';
    g_diff    : character := 'X';
  
    g_in_p : bit := '0' ;
    g_out_p   : bit := '0';
    g_in_n : bit := '0' ;
    g_out_n   : bit := '0'
  );
  Port ( 
    fmc_p_io: inout std_logic;
    fmc_n_io: inout std_logic;
        
    fmc_p_i: in std_logic := '0';
    fmc_n_i: in std_logic := '0';
		
    fmc_p_dir: in std_logic := '0';
    fmc_n_dir: in std_logic := '0';
                
    fmc_p_o :out std_logic;		  
    fmc_n_o :out std_logic
	);
	end component;
	
	
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
    
    
    signal s_input_p  : std_logic_vector(g_pin_count-1 downto 0);
    signal s_input_n  : std_logic_vector(g_pin_count-1 downto 0);
    signal s_output_p : std_logic_vector(g_pin_count-1 downto 0);
    signal s_output_n : std_logic_vector(g_pin_count-1 downto 0);
    
begin

GEN_DIFF: for I in 0 to g_pin_count-1 generate
GEN_PINPAIR_X : if g_diff(I)='1' or g_diff(I)='0' generate

  u_pinpair_iob_X: fmc_pinpair_iob 
    generic map (
      g_swap  => g_swap(I),
      g_diff => g_diff(I),
      g_in_p => g_in_p(I),
      g_in_n => g_in_n(I),
      g_out_p => g_out_p(I),
      g_out_n => g_out_n(I)
      )
    Port map ( 
      fmc_p_io => port_io_p(I),
      fmc_n_io => port_io_n(I),

      fmc_p_i => s_output_p(I),
      fmc_n_i => s_output_n(I),            
      fmc_p_o => s_input_p(I),
      fmc_n_o => s_input_n(I),
      fmc_p_dir => dir_i_p(I),
      fmc_n_dir => dir_i_n(I)
      );
      
      -- negation only diferential pairs (and positive singleended)
  u_pinpair_neg_X: fmc_pinpair_neg 
        generic map (
          g_swap  => g_swap(I),
          g_diff => g_diff(I),
          g_in_p => g_in_p(I),
          g_out_p => g_out_p(I)
        )
        Port map ( 
          pin_in_i => s_input_p(I),
          pin_in_o => input_o_p(I),
        
          pin_out_i => output_i_p(I),
          pin_out_o => s_output_p(I)
        );      
        
   -- negative singleended, never negated
   input_o_n(I) <= s_input_n(I);
   s_output_n(I) <= output_i_n(I);
   
   
end generate GEN_PINPAIR_X;
end generate GEN_DIFF;

end Behavioral;
