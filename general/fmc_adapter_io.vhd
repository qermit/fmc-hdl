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

entity fmc_adapter_io is
  generic (
    g_pin_count : natural := 2;
    g_swap: bit_vector(63 downto 0) := (others => '0');
    g_diff: t_character_array(63 downto 0) := (others => 'X');
    g_out_p : bit_vector(63 downto 0) := (others => '0');
    g_inout_p : bit_vector(63 downto 0) := (others => '0');
    g_out_n : bit_vector(63 downto 0) := (others => '0');
    g_inout_n : bit_vector(63 downto 0) := (others => '0')        
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
end fmc_adapter_io;

architecture Behavioral of fmc_adapter_io is

component fmc_pinpair_io 
  generic (
    g_swap : bit := '0';
    g_diff    : character := 'X';
  
    g_inout_p : bit := '0' ;
    g_out_p   : bit := '0';
    g_inout_n : bit := '0' ;
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
begin

GEN_DIFF: for I in 0 to g_pin_count-1 generate
GEN_PINPAIR_X : if g_diff(I)='1' or g_diff(I)='0' generate

  u_pinpair_io_X: fmc_pinpair_io 
    generic map (
      g_swap  => g_swap(I),
      g_diff => g_diff(I),
      g_inout_p => g_inout_p(I),
      g_inout_n => g_inout_n(I),
      g_out_p => g_out_p(I),
      g_out_n => g_out_n(I)
      )
    Port map ( 
      fmc_p_io => port_io_p(I),
      fmc_n_io => port_io_n(I),

      fmc_p_i => output_i_p(I),
      fmc_n_i => output_i_n(I),            
      fmc_p_o => input_o_p(I),
      fmc_n_o => input_o_n(I),
      fmc_p_dir => dir_i_p(I),
      fmc_n_dir => dir_i_n(I)
      );

end generate GEN_PINPAIR_X;
end generate GEN_DIFF;

end Behavioral;

