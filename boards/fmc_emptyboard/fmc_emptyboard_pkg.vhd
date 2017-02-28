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



package fmc_emptyboard_pkg is


  constant fmc_emptyboard_pin_map : t_iodelay_map_vector(0 downto 0):= c_iodelay_map_nullvector;
 
end fmc_emptyboard_pkg;


package body fmc_emptyboard_pkg is

end fmc_emptyboard_pkg;
