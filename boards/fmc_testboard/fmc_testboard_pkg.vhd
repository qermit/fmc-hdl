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



package fmc_testboard_pkg is


  constant fmc_testboard_pin_map : t_iodelay_map_vector(79 downto 0) := (
    -- inputs
  	 0 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index =>  0, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	 1 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index =>  1, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	 2 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index =>  2, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	 3 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index =>  3, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	 4 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index =>  4, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	 5 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index =>  5, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	 6 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index =>  6, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	 7 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index =>  7, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	 8 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index =>  8, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	 9 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index =>  9, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	10 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 10, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	11 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 11, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	12 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 12, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	13 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 13, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	14 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 14, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	15 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 15, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	16 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 16, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	17 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 17, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	18 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 18, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	19 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 19, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
   	20 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 20, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	21 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 21, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	22 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 22, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	23 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 23, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	24 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 24, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	25 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 25, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	26 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 26, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	27 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 27, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	28 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 28, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	29 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 29, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	30 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 30, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	31 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 31, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	32 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 32, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	33 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => LA, iob_index => 33, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	34 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index =>  0, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	35 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index =>  1, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	36 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index =>  2, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	37 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index =>  3, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	38 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index =>  4, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	39 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index =>  5, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	40 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index =>  6, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	41 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index =>  7, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	42 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index =>  8, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	43 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index =>  9, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	44 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 10, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	45 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 11, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	46 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 12, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	47 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 13, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	48 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 14, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	49 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 15, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	50 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 16, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	51 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 17, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	52 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 18, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	53 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 19, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
   	54 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 20, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	55 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 21, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	56 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 22, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	57 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HA, iob_index => 23, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	58 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index =>  0, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	59 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index =>  1, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	60 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index =>  2, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	61 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index =>  3, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	62 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index =>  4, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	63 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index =>  5, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	64 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index =>  6, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	65 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index =>  7, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	66 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index =>  8, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	67 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index =>  9, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
  	68 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 10, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	69 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 11, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	70 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 12, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	71 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 13, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	72 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 14, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	73 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 15, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	74 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 16, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	75 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 17, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	76 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 18, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	77 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 19, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
   	78 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 20, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0'),
	79 => (dir_type => DIRIN, group_id  => -1, index  =>  0, iob_type  => HB, iob_index => 21, iob_diff => DIFF, iob_ddr => '0', iob_delay => '0')
	 
  ) ;
 
end fmc_testboard_pkg;


package body fmc_testboard_pkg is

end fmc_testboard_pkg;
