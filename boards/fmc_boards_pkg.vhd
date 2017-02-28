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


component fmc_dio_32chlvdsa is

  generic (
    g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
    g_address_granularity    : t_wishbone_address_granularity := WORD;
    
    g_enable_system_i2c      : boolean := true;

	g_fmc_id              : natural                        := 1;
	g_fmc_map             : t_fmc_pin_map_vector           := c_fmc_pin_nullvector
    );

  Port (
    clk_i : in STD_LOGIC;
    rst_n_i : in STD_LOGIC;
    
    port_fmc_io: inout t_fmc_signals_bidir;

    slave_i       : in  t_wishbone_slave_in;
    slave_o       : out t_wishbone_slave_out;
           
    raw_o: out STD_LOGIC_VECTOR (31 downto 0);
    raw_i: in  STD_LOGIC_VECTOR (31 downto 0)
    );

end component fmc_dio_32chlvdsa;

component  fmc_adc_250m_16b_4cha is
	generic(
		
		g_interface_mode      : t_wishbone_interface_mode      := CLASSIC;
		g_address_granularity : t_wishbone_address_granularity := WORD;
		g_use_tristate        : boolean                        := true;
		g_enable_fmc_eeprom   : boolean                        := true;
        
		g_fmc_id              : natural                        := 0;
		g_fmc_map             : t_fmc_pin_map_vector           := c_fmc_pin_nullvector;
		g_master              : boolean                        := true;
                
        g_buggy_transistors   : boolean                        := false
	);

	Port(
		clk_i          : in    STD_LOGIC;
		rst_n_i        : in    STD_LOGIC;

		refclk_i       : in std_logic;

		port_fmc_inout : inout t_fmc_signals_bidir;
		port_fmc_in    : in    t_fmc_signals_in;
		port_fmc_out   : out   t_fmc_signals_out;
		
		debug_raw_o    : out   std_logic_vector(4 downto 0);

        adc_clk_i      : in std_logic := '0'; -- slave clock 
		adc_clk_o      : out std_logic; -- master clock
		
		adc0_data      : out std_logic_vector(15 downto 0);
		adc0_tvalid    : OUT STD_LOGIC;
		adc0_tready    : in std_logic;
		adc1_data      : out std_logic_vector(15 downto 0);
		adc1_tvalid    : OUT STD_LOGIC;
        adc1_tready    : in std_logic;
        adc2_data      : out std_logic_vector(15 downto 0);
		adc2_tvalid    : OUT STD_LOGIC;
        adc2_tready    : in std_logic;
        adc3_data      : out std_logic_vector(15 downto 0);      
        adc3_tvalid    : OUT STD_LOGIC;
        adc3_tready    : in std_logic;
                
		slave_i        : in    t_wishbone_slave_in;
		slave_o        : out   t_wishbone_slave_out
	);

end component;


component fmc_testboard is

  generic (
    g_use_tristate           : boolean := true;
    g_enable_fmc_eeprom      : boolean := true;
    g_fmc_id              : natural                        := 1;
	g_fmc_map             : t_fmc_pin_map_vector           := c_fmc_pin_nullvector
    );

  Port (
           clk_i        : in std_logic;
    port_fmc_in_i: in t_fmc_signals_in;
    port_fmc_out_o: out t_fmc_signals_out;
    port_fmc_io: inout t_fmc_signals_bidir

    );

end component;


component fmc_emptyboard is

  generic (
  	g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
    g_address_granularity    : t_wishbone_address_granularity := WORD;
  
    g_use_tristate           : boolean := true;
    g_enable_fmc_eeprom      : boolean := true;
    g_fmc_id              : natural                        := 1;
	g_fmc_map             : t_fmc_pin_map_vector           := c_fmc_pin_nullvector
    );

  Port (
    --== Standard clk and reset ==--
    clk_i        : in std_logic;
	rst_n_i      : in std_logic;
	
	--== Wishbone ==--	
	slave_i       : in  t_wishbone_slave_in;
    slave_o       : out t_wishbone_slave_out;

	--== FMC abstraction layer ==--
	port_fmc_in_i: in t_fmc_signals_in;
    port_fmc_out_o: out t_fmc_signals_out;
    port_fmc_io: inout t_fmc_signals_bidir
    );

end component;

end fmc_boards_pkg;

package body fmc_boards_pkg is
 
end fmc_boards_pkg;
