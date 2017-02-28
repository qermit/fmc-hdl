-------------------------------------------------------------------------------
-- Title      : FMC DIO 5ch TTL a HDL module
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : fmc_dio5chttl.vhd
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2015-09-11
-- Last update: 2016-02-10
-- Platform   : FPGA-generics
-- Standard   : VHDL
-------------------------------------------------------------------------------
-- Description:
-- fmc_dio5chttl integrates I2C Master, 1-Wire Master and GPIO-RAW
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2016 Piotr Miedzik
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.fmc_general_pkg.all;

use work.fmc_testboard_pkg.all;
use work.fmc_helper_pkg.all;


entity fmc_testboard is

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

end fmc_testboard;

architecture Behavioral of fmc_testboard is

	constant c_iodelaymap : t_iodelay_map_vector(fmc_testboard_pin_map'range) := fmc_testboard_pin_map;

  constant c_test_bool :boolean := write_xdc("fmc"& integer'image(g_fmc_id) &".xdc", g_fmc_id , g_fmc_map, c_iodelaymap);


  signal s_fmc_in1: t_fmc_signals_in;
  signal s_fmc_out1: t_fmc_signals_out;
  signal s_fmc_dir1: t_fmc_signals_out;  
  
begin


 cmp_fmc_adapter_iob: fmc_adapter_iob
 	generic map(
 		g_connector      => FMC_HPC,
 		g_use_jtag       => false,
 		g_use_inout      => true,
 		g_fmc_id         => g_fmc_id,
 		g_fmc_map        => g_fmc_map,
 		g_fmc_idelay_map => c_iodelaymap
 	)
 	port map(
 		port_fmc_io    => port_fmc_io,
 		port_fmc_in_i  => port_fmc_in_i,
 		port_fmc_out_o => port_fmc_out_o,
 		fmc_in_o       => s_fmc_in1,
 		fmc_out_i      => s_fmc_out1,
 		fmc_out_dir_i  => s_fmc_dir1
 	);

   port_fmc_out_o <= s_fmc_in1;
   
 
end Behavioral;
