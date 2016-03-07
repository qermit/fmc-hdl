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
  	0 => (group_id  => 0, index  =>  0, iob_type  => HA, iob_index =>  1, iob_diff  => DIFF, iob_iddr => '1' ),
  	1 => (group_id  => 0, index  =>  1, iob_type  => HA, iob_index =>  4, iob_diff  => DIFF, iob_iddr => '1' ),
  	2 => (group_id  => 0, index  =>  2, iob_type  => HA, iob_index =>  5, iob_diff  => DIFF, iob_iddr => '1' ),
  	3 => (group_id  => 0, index  =>  3, iob_type  => HA, iob_index =>  9, iob_diff  => DIFF, iob_iddr => '1' ),
  	4 => (group_id  => 0, index  =>  4, iob_type  => HA, iob_index =>  3, iob_diff  => DIFF, iob_iddr => '1' ),
  	5 => (group_id  => 0, index  =>  5, iob_type  => HA, iob_index =>  2, iob_diff  => DIFF, iob_iddr => '1' ),
  	6 => (group_id  => 0, index  =>  6, iob_type  => HA, iob_index =>  7, iob_diff  => DIFF, iob_iddr => '1' ),
  	7 => (group_id  => 0, index  =>  7, iob_type  => HA, iob_index =>  6, iob_diff  => DIFF, iob_iddr => '1' ),
  	8 => (group_id  => 0, index  => 16, iob_type  => HA, iob_index =>  0, iob_diff  => DIFF, iob_iddr => '1'), 
  	
  	
  	 9 => (group_id  => 1, index  =>  0, iob_type  => LA, iob_index =>  4, iob_diff  => DIFF, iob_iddr => '1' ),
    10 => (group_id  => 1, index  =>  1, iob_type  => LA, iob_index =>  3, iob_diff  => DIFF, iob_iddr => '1' ),
  	11 => (group_id  => 1, index  =>  2, iob_type  => LA, iob_index =>  8, iob_diff  => DIFF, iob_iddr => '1' ),
  	12 => (group_id  => 1, index  =>  3, iob_type  => LA, iob_index =>  7, iob_diff  => DIFF, iob_iddr => '1' ),
  	13 => (group_id  => 1, index  =>  4, iob_type  => LA, iob_index => 12, iob_diff  => DIFF, iob_iddr => '1' ),
  	14 => (group_id  => 1, index  =>  5, iob_type  => LA, iob_index => 13, iob_diff  => DIFF, iob_iddr => '1' ),
  	15 => (group_id  => 1, index  =>  6, iob_type  => LA, iob_index => 11, iob_diff  => DIFF, iob_iddr => '1' ),
  	16 => (group_id  => 1, index  =>  7, iob_type  => LA, iob_index => 16, iob_diff  => DIFF, iob_iddr => '1' ),
  	17 => (group_id  => 1, index  => 16, iob_type  => LA, iob_index =>  1, iob_diff  => DIFF, iob_iddr => '1' ),
  	
  	18 => (group_id  => 2, index  =>  0, iob_type  => LA, iob_index => 17, iob_diff  => DIFF, iob_iddr => '1' ),
  	19 => (group_id  => 2, index  =>  1, iob_type  => LA, iob_index => 20, iob_diff  => DIFF, iob_iddr => '1' ),
  	20 => (group_id  => 2, index  =>  2, iob_type  => LA, iob_index => 23, iob_diff  => DIFF, iob_iddr => '1' ),
  	21 => (group_id  => 2, index  =>  3, iob_type  => LA, iob_index => 19, iob_diff  => DIFF, iob_iddr => '1' ),
  	22 => (group_id  => 2, index  =>  4, iob_type  => LA, iob_index => 22, iob_diff  => DIFF, iob_iddr => '1' ),
  	23 => (group_id  => 2, index  =>  5, iob_type  => LA, iob_index => 21, iob_diff  => DIFF, iob_iddr => '1' ),
  	24 => (group_id  => 2, index  =>  6, iob_type  => LA, iob_index => 25, iob_diff  => DIFF, iob_iddr => '1' ),
  	25 => (group_id  => 2, index  =>  7, iob_type  => LA, iob_index => 26, iob_diff  => DIFF, iob_iddr => '1' ),
  	26 => (group_id  => 2, index  => 16, iob_type  => LA, iob_index => 18, iob_diff  => DIFF, iob_iddr => '1' ),
  	
  	27 => (group_id  => 3, index  =>  0, iob_type  => HB, iob_index =>  0, iob_diff  => DIFF, iob_iddr => '1' ),
  	28 => (group_id  => 3, index  =>  1, iob_type  => HB, iob_index => 11, iob_diff  => DIFF, iob_iddr => '1' ),
  	29 => (group_id  => 3, index  =>  2, iob_type  => HB, iob_index => 12, iob_diff  => DIFF, iob_iddr => '1' ),
  	30 => (group_id  => 3, index  =>  3, iob_type  => HB, iob_index => 10, iob_diff  => DIFF, iob_iddr => '1' ),
  	31 => (group_id  => 3, index  =>  4, iob_type  => HB, iob_index => 15, iob_diff  => DIFF, iob_iddr => '1' ),
  	32 => (group_id  => 3, index  =>  5, iob_type  => HB, iob_index => 14, iob_diff  => DIFF, iob_iddr => '1' ),
  	33 => (group_id  => 3, index  =>  6, iob_type  => HB, iob_index => 18, iob_diff  => DIFF, iob_iddr => '1' ),
  	34 => (group_id  => 3, index  =>  7, iob_type  => HB, iob_index => 17, iob_diff  => DIFF, iob_iddr => '1' ),
  	35 => (group_id  => 3, index  => 16, iob_type  => HB, iob_index =>  6, iob_diff  => DIFF, iob_iddr => '1' ),
  	others => c_iodelay_map_empty
  ) ;
   
  
  
end fmc_adc_250m_16b_4cha_pkg;


package body fmc_adc_250m_16b_4cha_pkg is

end fmc_adc_250m_16b_4cha_pkg;
