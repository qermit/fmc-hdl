------------------------------------------------------------------------------
-- Title      : FMC ADC 250M 16b 4cha board support package
------------------------------------------------------------------------------
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2016-03-07
-- Platform   : FPGA-generic
-------------------------------------------------------------------------------
-- Description: General definitions package for the FMC ADC boards.
-------------------------------------------------------------------------------
-- Copyright (c) 2012 GSI
-- Licensed under GNU Lesser General Public License (LGPL) v3.0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.fmc_general_pkg.all;



package fmc_dio5chttl_pkg is


  constant fmc_dio5chttl_pin_map : t_iodelay_map_vector(22 downto 0) := (
    -- inputs
  	 0 => (dir_type => DIROUT, group_id  => 0, index  =>  0, iob_type  => LA, iob_index => 29, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
     1 => (dir_type => DIROUT, group_id  => 0, index  =>  1, iob_type  => LA, iob_index => 28, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	 2 => (dir_type => DIROUT, group_id  => 0, index  =>  2, iob_type  => LA, iob_index =>  8, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	 3 => (dir_type => DIROUT, group_id  => 0, index  =>  3, iob_type  => LA, iob_index =>  7, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	 4 => (dir_type => DIROUT, group_id  => 0, index  =>  4, iob_type  => LA, iob_index =>  4, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	-- outputs
  	 5 => (dir_type => DIRIN, group_id  => 0, index  =>  0, iob_type => LA, iob_index => 33, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
     6 => (dir_type => DIRIN, group_id  => 0, index  =>  1, iob_type => LA, iob_index => 20, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	 7 => (dir_type => DIRIN, group_id  => 0, index  =>  2, iob_type => LA, iob_index => 16, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	 8 => (dir_type => DIRIN, group_id  => 0, index  =>  3, iob_type => LA, iob_index =>  3, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	 9 => (dir_type => DIRIN, group_id  => 0, index  =>  4, iob_type => LA, iob_index =>  0, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	-- OE_N
  	10 => (dir_type => DIROUT, group_id  => 1, index  =>  0, iob_type => LA, iob_index => 30, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'),
    11 => (dir_type => DIROUT, group_id  => 1, index  =>  1, iob_type => LA, iob_index => 24, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'),
  	12 => (dir_type => DIROUT, group_id  => 1, index  =>  2, iob_type => LA, iob_index => 15, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'),
  	13 => (dir_type => DIROUT, group_id  => 1, index  =>  3, iob_type => LA, iob_index => 11, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'),
  	14 => (dir_type => DIROUT, group_id  => 1, index  =>  4, iob_type => LA, iob_index =>  5, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'),
	-- TERM_EN
  	15 => (dir_type => DIROUT, group_id  => 2, index  =>  0, iob_type => LA, iob_index => 30, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'),
    16 => (dir_type => DIROUT, group_id  => 2, index  =>  1, iob_type => LA, iob_index =>  6, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'),
  	17 => (dir_type => DIROUT, group_id  => 2, index  =>  2, iob_type => LA, iob_index =>  5, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'),
  	18 => (dir_type => DIROUT, group_id  => 2, index  =>  3, iob_type => LA, iob_index =>  9, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'),
  	19 => (dir_type => DIROUT, group_id  => 2, index  =>  4, iob_type => LA, iob_index =>  9, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'),
	-- LED
	20 => (dir_type => DIROUT, group_id  => -1, index =>  0, iob_type => LA, iob_index =>  1, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'),
    21 => (dir_type => DIROUT, group_id  => -1, index =>  0, iob_type => LA, iob_index =>  1, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'),
	-- ONEWIRE
	22 => (dir_type => DIRIO,  group_id  => -1, index =>  0, iob_type => LA, iob_index => 23, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0')
  ) ;
 
end fmc_dio5chttl_pkg;


package body fmc_dio5chttl_pkg is

end fmc_dio5chttl_pkg;
