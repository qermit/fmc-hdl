--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

use work.wishbone_pkg.all;
use work.fmc_general_pkg.all;


package fmc_boards_pkg is

component fmc_dio5chttl 
  generic (
    g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
    g_address_granularity    : t_wishbone_address_granularity := WORD;

    g_num_io                : natural                        := 5;
  
    g_fmc_LA_inv   : std_logic_vector(33 downto 0) := (others => '0');
    
    g_fmc_DP_C2M_inv   : std_logic_vector(9 downto 0) := (others => '0');
    g_fmc_DP_M2C_inv   : std_logic_vector(9 downto 0) := (others => '0')
    );

  Port (
    clk_i : in STD_LOGIC;
    rst_n_i : in STD_LOGIC;
           
    fmc_in: in t_fmc_signals_in;
    fmc_out: out t_fmc_signals_out;

    slave_i       : in  t_wishbone_slave_in;
    slave_o       : out t_wishbone_slave_out;
           
    raw_o: out STD_LOGIC_VECTOR (g_num_io-1 downto 0);
    raw_i: in  STD_LOGIC_VECTOR (g_num_io-1 downto 0)
    );
end component; 


end fmc_boards_pkg;

package body fmc_boards_pkg is
 
end fmc_boards_pkg;
