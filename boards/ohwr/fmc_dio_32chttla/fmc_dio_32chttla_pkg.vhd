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



package fmc_dio_32chttla_pkg is

  -- V1.1
  constant fmc_dio_32chttla_pin_map : t_iodelay_map_vector(42 downto 0) := (
    -- inputs
  	 0 => (dir_type =>  DIRIO, group_id  => 0, index  =>  0, iob_type  => LA, iob_index =>  7, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
     1 => (dir_type =>  DIRIO, group_id  => 0, index  =>  1, iob_type  => LA, iob_index =>  8, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	 2 => (dir_type =>  DIRIO, group_id  => 0, index  =>  2, iob_type  => LA, iob_index =>  8, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	 3 => (dir_type =>  DIRIO, group_id  => 0, index  =>  3, iob_type  => LA, iob_index =>  4, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	 4 => (dir_type =>  DIRIO, group_id  => 0, index  =>  4, iob_type  => LA, iob_index =>  4, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	 5 => (dir_type =>  DIRIO, group_id  => 0, index  =>  5, iob_type  => LA, iob_index =>  2, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
     6 => (dir_type =>  DIRIO, group_id  => 0, index  =>  6, iob_type  => LA, iob_index =>  2, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	 7 => (dir_type =>  DIRIO, group_id  => 0, index  =>  7, iob_type  => LA, iob_index =>  0, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),

  	 8 => (dir_type =>  DIRIO, group_id  => 1, index  =>  0, iob_type  => LA, iob_index =>  0, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),  	 
  	 9 => (dir_type =>  DIRIO, group_id  => 1, index  =>  1, iob_type  => LA, iob_index =>  9, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	10 => (dir_type =>  DIRIO, group_id  => 1, index  =>  2, iob_type  => LA, iob_index =>  9, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
    11 => (dir_type =>  DIRIO, group_id  => 1, index  =>  3, iob_type  => LA, iob_index =>  3, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	12 => (dir_type =>  DIRIO, group_id  => 1, index  =>  4, iob_type  => LA, iob_index =>  3, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	13 => (dir_type =>  DIRIO, group_id  => 1, index  =>  5, iob_type  => LA, iob_index => 10, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	14 => (dir_type =>  DIRIO, group_id  => 1, index  =>  6, iob_type  => LA, iob_index => 10, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	15 => (dir_type =>  DIRIO, group_id  => 1, index  =>  7, iob_type  => LA, iob_index =>  1, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
    16 => (dir_type =>  DIRIO, group_id  => 2, index  =>  0, iob_type  => LA, iob_index =>  1, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),

  	17 => (dir_type =>  DIRIO, group_id  => 2, index  =>  1, iob_type  => LA, iob_index =>  6, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	18 => (dir_type =>  DIRIO, group_id  => 2, index  =>  2, iob_type  => LA, iob_index =>  6, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	19 => (dir_type =>  DIRIO, group_id  => 2, index  =>  3, iob_type  => LA, iob_index =>  5, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	20 => (dir_type =>  DIRIO, group_id  => 2, index  =>  4, iob_type  => LA, iob_index =>  5, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
    21 => (dir_type =>  DIRIO, group_id  => 2, index  =>  5, iob_type  => LA, iob_index => 13, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	22 => (dir_type =>  DIRIO, group_id  => 2, index  =>  6, iob_type  => LA, iob_index => 13, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	23 => (dir_type =>  DIRIO, group_id  => 2, index  =>  7, iob_type  => LA, iob_index => 16, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),

  	24 => (dir_type =>  DIRIO, group_id  => 3, index  =>  0, iob_type  => LA, iob_index => 16, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	25 => (dir_type =>  DIRIO, group_id  => 3, index  =>  1, iob_type  => LA, iob_index => 14, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
    26 => (dir_type =>  DIRIO, group_id  => 3, index  =>  2, iob_type  => LA, iob_index => 14, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	27 => (dir_type =>  DIRIO, group_id  => 3, index  =>  3, iob_type  => LA, iob_index => 17, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	28 => (dir_type =>  DIRIO, group_id  => 3, index  =>  4, iob_type  => LA, iob_index => 17, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	29 => (dir_type =>  DIRIO, group_id  => 3, index  =>  5, iob_type  => LA, iob_index => 20, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	30 => (dir_type =>  DIRIO, group_id  => 3, index  =>  6, iob_type  => LA, iob_index => 20, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
    31 => (dir_type =>  DIRIO, group_id  => 3, index  =>  7, iob_type  => LA, iob_index => 19, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
     
	-- Output controll
  	32 => (dir_type => DIROUT, group_id => 4, index  =>  0, iob_type => LA, iob_index => 19, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'), -- OE1
    33 => (dir_type => DIROUT, group_id => 4, index  =>  1, iob_type => LA, iob_index => 18, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'), -- OE2
  	34 => (dir_type => DIROUT, group_id => 4, index  =>  2, iob_type => LA, iob_index => 18, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'), -- OE3
  	35 => (dir_type => DIROUT, group_id => 4, index  =>  3, iob_type => LA, iob_index => 21, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'), -- OE4

	-- DIRECTION controll
  	36 => (dir_type => DIROUT, group_id => 4, index  =>  4, iob_type => LA, iob_index => 21, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'), -- DIR1
    37 => (dir_type => DIROUT, group_id => 4, index  =>  5, iob_type => LA, iob_index => 22, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'), -- DIR2
  	38 => (dir_type => DIROUT, group_id => 4, index  =>  6, iob_type => LA, iob_index => 22, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'), -- DIR3
  	39 => (dir_type => DIROUT, group_id => 4, index  =>  7, iob_type => LA, iob_index => 23, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'), -- DIR4
    
    40 => (dir_type =>  DIRIN, group_id => 5, index  =>  0, iob_type => LA, iob_index => 12, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'), -- PATCH_CONn
    41 => (dir_type => DIROUT, group_id => 5, index  =>  1, iob_type => LA, iob_index =>  7, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'), -- LED1
    42 => (dir_type =>  DIRIN, group_id => 5, index  =>  2, iob_type => LA, iob_index => 23, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0')  -- ALERT
    

    ) ;

  constant fmc_dio_32chttla_pin_map_wrong : t_iodelay_map_vector(42 downto 0) := (
    -- inputs
  	 0 => (dir_type =>  DIRIO, group_id  => 0, index  =>  0, iob_type  => LA, iob_index =>  3, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
     1 => (dir_type =>  DIRIO, group_id  => 0, index  =>  1, iob_type  => LA, iob_index =>  4, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	 2 => (dir_type =>  DIRIO, group_id  => 0, index  =>  2, iob_type  => LA, iob_index =>  4, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	 3 => (dir_type =>  DIRIO, group_id  => 0, index  =>  3, iob_type  => LA, iob_index =>  5, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	 4 => (dir_type =>  DIRIO, group_id  => 0, index  =>  4, iob_type  => LA, iob_index =>  5, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	 5 => (dir_type =>  DIRIO, group_id  => 0, index  =>  5, iob_type  => LA, iob_index =>  6, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
     6 => (dir_type =>  DIRIO, group_id  => 0, index  =>  6, iob_type  => LA, iob_index =>  6, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	 7 => (dir_type =>  DIRIO, group_id  => 0, index  =>  7, iob_type  => LA, iob_index =>  7, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	 8 => (dir_type =>  DIRIO, group_id  => 1, index  =>  0, iob_type  => LA, iob_index =>  7, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	 9 => (dir_type =>  DIRIO, group_id  => 1, index  =>  1, iob_type  => LA, iob_index =>  8, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	10 => (dir_type =>  DIRIO, group_id  => 1, index  =>  2, iob_type  => LA, iob_index =>  8, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
    11 => (dir_type =>  DIRIO, group_id  => 1, index  =>  3, iob_type  => LA, iob_index =>  9, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	12 => (dir_type =>  DIRIO, group_id  => 1, index  =>  4, iob_type  => LA, iob_index =>  9, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	13 => (dir_type =>  DIRIO, group_id  => 1, index  =>  5, iob_type  => LA, iob_index => 10, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	14 => (dir_type =>  DIRIO, group_id  => 1, index  =>  6, iob_type  => LA, iob_index => 10, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	15 => (dir_type =>  DIRIO, group_id  => 1, index  =>  7, iob_type  => LA, iob_index => 11, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
    -- the library supports only up to 16 bits per channel
    16 => (dir_type =>  DIRIO, group_id  => 2, index  =>  0, iob_type  => LA, iob_index => 11, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	17 => (dir_type =>  DIRIO, group_id  => 2, index  =>  1, iob_type  => LA, iob_index => 12, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	18 => (dir_type =>  DIRIO, group_id  => 2, index  =>  2, iob_type  => LA, iob_index => 12, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	19 => (dir_type =>  DIRIO, group_id  => 2, index  =>  3, iob_type  => LA, iob_index => 13, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	20 => (dir_type =>  DIRIO, group_id  => 2, index  =>  4, iob_type  => LA, iob_index => 13, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
    21 => (dir_type =>  DIRIO, group_id  => 2, index  =>  5, iob_type  => LA, iob_index => 14, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	22 => (dir_type =>  DIRIO, group_id  => 2, index  =>  6, iob_type  => LA, iob_index => 14, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	23 => (dir_type =>  DIRIO, group_id  => 2, index  =>  7, iob_type  => LA, iob_index => 15, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	24 => (dir_type =>  DIRIO, group_id  => 3, index  =>  0, iob_type  => LA, iob_index => 15, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	25 => (dir_type =>  DIRIO, group_id  => 3, index  =>  1, iob_type  => LA, iob_index => 16, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
    26 => (dir_type =>  DIRIO, group_id  => 3, index  =>  2, iob_type  => LA, iob_index => 16, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	27 => (dir_type =>  DIRIO, group_id  => 3, index  =>  3, iob_type  => LA, iob_index => 17, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	28 => (dir_type =>  DIRIO, group_id  => 3, index  =>  4, iob_type  => LA, iob_index => 17, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
  	29 => (dir_type =>  DIRIO, group_id  => 3, index  =>  5, iob_type  => LA, iob_index => 18, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
  	30 => (dir_type =>  DIRIO, group_id  => 3, index  =>  6, iob_type  => LA, iob_index => 18, iob_diff => NEG, iob_ddr => '0', iob_delay => '0'),
    31 => (dir_type =>  DIRIO, group_id  => 3, index  =>  7, iob_type  => LA, iob_index => 19, iob_diff => POS, iob_ddr => '0', iob_delay => '0'),
     
	-- Output controll
  	32 => (dir_type => DIROUT, group_id => 4, index  =>  0, iob_type => LA, iob_index => 19, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'), -- OE1
    33 => (dir_type => DIROUT, group_id => 4, index  =>  1, iob_type => LA, iob_index => 20, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'), -- OE2
  	34 => (dir_type => DIROUT, group_id => 4, index  =>  2, iob_type => LA, iob_index => 20, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'), -- OE3
  	35 => (dir_type => DIROUT, group_id => 4, index  =>  3, iob_type => LA, iob_index => 21, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'), -- OE4

	-- DIRECTION controll
  	36 => (dir_type => DIROUT, group_id => 4, index  =>  4, iob_type => LA, iob_index => 21, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'), -- DIR1
    37 => (dir_type => DIROUT, group_id => 4, index  =>  5, iob_type => LA, iob_index => 22, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'), -- DIR2
  	38 => (dir_type => DIROUT, group_id => 4, index  =>  6, iob_type => LA, iob_index => 22, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'), -- DIR3
  	39 => (dir_type => DIROUT, group_id => 4, index  =>  7, iob_type => LA, iob_index => 23, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'), -- DIR4
    
    40 => (dir_type =>  DIRIN, group_id => 5, index  =>  0, iob_type => LA, iob_index =>  2, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0'), -- PATCH_CONn
    41 => (dir_type => DIROUT, group_id => 5, index  =>  1, iob_type => LA, iob_index =>  3, iob_diff =>  POS, iob_ddr => '0', iob_delay => '0'), -- LED1
    42 => (dir_type =>  DIRIN, group_id => 5, index  =>  2, iob_type => LA, iob_index => 23, iob_diff =>  NEG, iob_ddr => '0', iob_delay => '0')  -- ALERT
    

    ) ;
 
end fmc_dio_32chttla_pkg;


package body fmc_dio_32chttla_pkg is

end fmc_dio_32chttla_pkg;
