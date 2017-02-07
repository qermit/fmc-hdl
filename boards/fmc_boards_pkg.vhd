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
	generic(g_interface_mode      : t_wishbone_interface_mode      := CLASSIC;
		    g_address_granularity : t_wishbone_address_granularity := WORD;
		    g_use_tristate        : boolean                        := true;
			g_enable_i2c          : boolean                        := true;
		    g_num_io              : natural                        := 5;
		    g_fmc_id              : natural                        := 1;
		    g_fmc_map             : t_fmc_pin_map_vector           := c_fmc_pin_nullvector);
	port(clk_i          : in    STD_LOGIC;
		 rst_n_i        : in    STD_LOGIC;
		 port_fmc_in_i  : in    t_fmc_signals_in;
		 port_fmc_out_o : out   t_fmc_signals_out;
		 port_fmc_io    : inout t_fmc_signals_bidir;
		 slave_i        : in    t_wishbone_slave_in;
		 slave_o        : out   t_wishbone_slave_out;
		 raw_o          : out   STD_LOGIC_VECTOR(g_num_io - 1 downto 0);
		 raw_i          : in    STD_LOGIC_VECTOR(g_num_io - 1 downto 0));
end component fmc_dio5chttl;


end fmc_boards_pkg;

package body fmc_boards_pkg is
 
end fmc_boards_pkg;
