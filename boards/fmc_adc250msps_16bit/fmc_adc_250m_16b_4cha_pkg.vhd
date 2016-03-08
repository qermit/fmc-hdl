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



package fmc_adc_250m_16b_4cha_pkg is


  constant adc_250m_pin_map: t_iodelay_map_vector(9 * 4 -1 downto 0) := (
  	0 => (dir_type => DIRIN, group_id  => 0, index  =>  0, iob_type  => HA, iob_index =>  1, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	1 => (dir_type => DIRIN, group_id  => 0, index  =>  1, iob_type  => HA, iob_index =>  4, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	2 => (dir_type => DIRIN, group_id  => 0, index  =>  2, iob_type  => HA, iob_index =>  5, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	3 => (dir_type => DIRIN, group_id  => 0, index  =>  3, iob_type  => HA, iob_index =>  9, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	4 => (dir_type => DIRIN, group_id  => 0, index  =>  4, iob_type  => HA, iob_index =>  3, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	5 => (dir_type => DIRIN, group_id  => 0, index  =>  5, iob_type  => HA, iob_index =>  2, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	6 => (dir_type => DIRIN, group_id  => 0, index  =>  6, iob_type  => HA, iob_index =>  7, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	7 => (dir_type => DIRIN, group_id  => 0, index  =>  7, iob_type  => HA, iob_index =>  6, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	8 => (dir_type => DIRIN, group_id  => 0, index  => 16, iob_type  => HA, iob_index =>  0, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ), 
  	
  	
  	 9 => (dir_type => DIRIN, group_id  => 1, index  =>  0, iob_type  => LA, iob_index =>  4, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
    10 => (dir_type => DIRIN, group_id  => 1, index  =>  1, iob_type  => LA, iob_index =>  3, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	11 => (dir_type => DIRIN, group_id  => 1, index  =>  2, iob_type  => LA, iob_index =>  8, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	12 => (dir_type => DIRIN, group_id  => 1, index  =>  3, iob_type  => LA, iob_index =>  7, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	13 => (dir_type => DIRIN, group_id  => 1, index  =>  4, iob_type  => LA, iob_index => 12, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	14 => (dir_type => DIRIN, group_id  => 1, index  =>  5, iob_type  => LA, iob_index => 13, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	15 => (dir_type => DIRIN, group_id  => 1, index  =>  6, iob_type  => LA, iob_index => 11, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	16 => (dir_type => DIRIN, group_id  => 1, index  =>  7, iob_type  => LA, iob_index => 16, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	17 => (dir_type => DIRIN, group_id  => 1, index  => 16, iob_type  => LA, iob_index =>  1, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	
  	18 => (dir_type => DIRIN, group_id  => 2, index  =>  0, iob_type  => LA, iob_index => 17, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	19 => (dir_type => DIRIN, group_id  => 2, index  =>  1, iob_type  => LA, iob_index => 20, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	20 => (dir_type => DIRIN, group_id  => 2, index  =>  2, iob_type  => LA, iob_index => 23, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	21 => (dir_type => DIRIN, group_id  => 2, index  =>  3, iob_type  => LA, iob_index => 19, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	22 => (dir_type => DIRIN, group_id  => 2, index  =>  4, iob_type  => LA, iob_index => 22, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	23 => (dir_type => DIRIN, group_id  => 2, index  =>  5, iob_type  => LA, iob_index => 21, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	24 => (dir_type => DIRIN, group_id  => 2, index  =>  6, iob_type  => LA, iob_index => 25, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	25 => (dir_type => DIRIN, group_id  => 2, index  =>  7, iob_type  => LA, iob_index => 26, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	26 => (dir_type => DIRIN, group_id  => 2, index  => 16, iob_type  => LA, iob_index => 18, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	
  	27 => (dir_type => DIRIN, group_id  => 3, index  =>  0, iob_type  => HB, iob_index =>  0, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	28 => (dir_type => DIRIN, group_id  => 3, index  =>  1, iob_type  => HB, iob_index => 11, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	29 => (dir_type => DIRIN, group_id  => 3, index  =>  2, iob_type  => HB, iob_index => 12, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	30 => (dir_type => DIRIN, group_id  => 3, index  =>  3, iob_type  => HB, iob_index => 10, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	31 => (dir_type => DIRIN, group_id  => 3, index  =>  4, iob_type  => HB, iob_index => 15, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	32 => (dir_type => DIRIN, group_id  => 3, index  =>  5, iob_type  => HB, iob_index => 14, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	33 => (dir_type => DIRIN, group_id  => 3, index  =>  6, iob_type  => HB, iob_index => 18, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	34 => (dir_type => DIRIN, group_id  => 3, index  =>  7, iob_type  => HB, iob_index => 17, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	35 => (dir_type => DIRIN, group_id  => 3, index  => 16, iob_type  => HB, iob_index =>  6, iob_diff  => DIFF, iob_ddr => '1', iob_delay => '1' ),
  	others => c_iodelay_map_empty
  ) ;
   
  
  
end fmc_adc_250m_16b_4cha_pkg;


package body fmc_adc_250m_16b_4cha_pkg is

end fmc_adc_250m_16b_4cha_pkg;
