------------------------------------------------------------------------------
-- Title      : AFC board support package
------------------------------------------------------------------------------
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2016-03-07
-- Platform   : FPGA-generic
-------------------------------------------------------------------------------
-- Description: General definitions package for the FMC ADC boards.
-------------------------------------------------------------------------------
-- Copyright (c) 2016 GSI
-- Licensed under GNU Lesser General Public License (LGPL) v3.0
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.fmc_general_pkg.all;

package afc_pkg is
  -- Constant default values.
  constant afc_v2_csv : string := "FMC_ID;IOB_TYPE;IOB_INDEX;IOB_DIR;IOB_SWAP" & CR &
"1;HA;00;DIRIO;0" & CR &
"1;HA;01;DIRIO;0" & CR &
"1;HA;02;DIRIO;1" & CR &
"1;HA;03;DIRIO;0" & CR &
"1;HA;04;DIRIO;1" & CR &
"1;HA;05;DIRIO;1" & CR &
"1;HA;06;DIRIO;1" & CR &
"1;HA;07;DIRIO;1" & CR &
"1;HA;08;DIRIO;1" & CR &
"1;HA;09;DIRIO;1" & CR &
"1;HA;10;DIRIO;1" & CR &
"1;HA;11;DIRIO;1" & CR &
"1;HA;12;DIRIO;1" & CR &
"1;HA;13;DIRIO;0" & CR &
"1;HA;14;DIRIO;1" & CR &
"1;HA;15;DIRIO;1" & CR &
"1;HA;16;DIRIO;1" & CR &
"1;HA;17;DIRIO;0" & CR &
"1;HA;18;DIRIO;1" & CR &
"1;HA;19;DIRIO;1" & CR &
"1;HA;20;DIRIO;0" & CR &
"1;HA;21;DIRIO;1" & CR &
"1;HA;22;DIRIO;1" & CR &
"1;HA;23;DIRIO;1" & CR &
"1;HB;00;DIRIO;1" & CR &
"1;HB;01;DIRIO;0" & CR &
"1;HB;02;DIRIO;0" & CR &
"1;HB;03;DIRIO;0" & CR &
"1;HB;04;DIRIO;0" & CR &
"1;HB;05;DIRIO;0" & CR &
"1;HB;06;DIRIO;0" & CR &
"1;HB;07;DIRIO;0" & CR &
"1;HB;08;DIRIO;0" & CR &
"1;HB;09;DIRIO;0" & CR &
"1;HB;10;DIRIO;0" & CR &
"1;HB;11;DIRIO;0" & CR &
"1;HB;12;DIRIO;0" & CR &
"1;HB;13;DIRIO;0" & CR &
"1;HB;14;DIRIO;0" & CR &
"1;HB;15;DIRIO;0" & CR &
"1;HB;16;DIRIO;0" & CR &
"1;HB;17;DIRIO;0" & CR &
"1;HB;18;DIRIO;0" & CR &
"1;HB;19;DIRIO;0" & CR &
"1;HB;20;DIRIO;0" & CR &
"1;HB;21;DIRIO;1" & CR &
"1;LA;00;DIRIO;0" & CR &
"1;LA;01;DIRIO;0" & CR &
"1;LA;02;DIRIO;0" & CR &
"1;LA;03;DIRIO;1" & CR &
"1;LA;04;DIRIO;1" & CR &
"1;LA;05;DIRIO;0" & CR &
"1;LA;06;DIRIO;1" & CR &
"1;LA;07;DIRIO;0" & CR &
"1;LA;08;DIRIO;0" & CR &
"1;LA;09;DIRIO;0" & CR &
"1;LA;10;DIRIO;1" & CR &
"1;LA;11;DIRIO;1" & CR &
"1;LA;12;DIRIO;1" & CR &
"1;LA;13;DIRIO;0" & CR &
"1;LA;14;DIRIO;0" & CR &
"1;LA;15;DIRIO;1" & CR &
"1;LA;16;DIRIO;0" & CR &
"1;LA;17;DIRIO;0" & CR &
"1;LA;18;DIRIO;0" & CR &
"1;LA;19;DIRIO;0" & CR &
"1;LA;20;DIRIO;1" & CR &
"1;LA;21;DIRIO;1" & CR &
"1;LA;22;DIRIO;0" & CR &
"1;LA;23;DIRIO;1" & CR &
"1;LA;24;DIRIO;1" & CR &
"1;LA;25;DIRIO;1" & CR &
"1;LA;26;DIRIO;0" & CR &
"1;LA;27;DIRIO;0" & CR &
"1;LA;28;DIRIO;0" & CR &
"1;LA;29;DIRIO;1" & CR &
"1;LA;30;DIRIO;0" & CR &
"1;LA;31;DIRIO;1" & CR &
"1;LA;32;DIRIO;0" & CR &
"1;LA;33;DIRIO;1" & CR &
"2;HA;00;DIRIO;1" & CR &
"2;HA;01;DIRIO;0" & CR &
"2;HA;02;DIRIO;1" & CR &
"2;HA;03;DIRIO;0" & CR &
"2;HA;04;DIRIO;1" & CR &
"2;HA;05;DIRIO;0" & CR &
"2;HA;06;DIRIO;1" & CR &
"2;HA;07;DIRIO;1" & CR &
"2;HA;08;DIRIO;1" & CR &
"2;HA;09;DIRIO;1" & CR &
"2;HA;10;DIRIO;0" & CR &
"2;HA;11;DIRIO;1" & CR &
"2;HA;12;DIRIO;1" & CR &
"2;HA;13;DIRIO;1" & CR &
"2;HA;14;DIRIO;1" & CR &
"2;HA;15;DIRIO;0" & CR &
"2;HA;16;DIRIO;1" & CR &
"2;HA;17;DIRIO;1" & CR &
"2;HA;18;DIRIO;1" & CR &
"2;HA;19;DIRIO;1" & CR &
"2;HA;20;DIRIO;1" & CR &
"2;HA;21;DIRIO;0" & CR &
"2;HA;22;DIRIO;1" & CR &
"2;HA;23;DIRIO;1" & CR &
"2;HB;00;DIRIO;0" & CR &
"2;HB;01;DIRIO;1" & CR &
"2;HB;02;DIRIO;1" & CR &
"2;HB;03;DIRIO;0" & CR &
"2;HB;04;DIRIO;0" & CR &
"2;HB;05;DIRIO;0" & CR &
"2;HB;06;DIRIO;0" & CR &
"2;HB;07;DIRIO;1" & CR &
"2;HB;08;DIRIO;0" & CR &
"2;HB;09;DIRIO;0" & CR &
"2;HB;10;DIRIO;1" & CR &
"2;HB;11;DIRIO;1" & CR &
"2;HB;12;DIRIO;0" & CR &
"2;HB;13;DIRIO;0" & CR &
"2;HB;14;DIRIO;0" & CR &
"2;HB;15;DIRIO;0" & CR &
"2;HB;16;DIRIO;1" & CR &
"2;HB;17;DIRIO;1" & CR &
"2;HB;18;DIRIO;0" & CR &
"2;HB;19;DIRIO;1" & CR &
"2;HB;20;DIRIO;0" & CR &
"2;HB;21;DIRIO;0" & CR &
"2;LA;00;DIRIO;0" & CR &
"2;LA;01;DIRIO;1" & CR &
"2;LA;02;DIRIO;1" & CR &
"2;LA;03;DIRIO;1" & CR &
"2;LA;04;DIRIO;1" & CR &
"2;LA;05;DIRIO;1" & CR &
"2;LA;06;DIRIO;0" & CR &
"2;LA;07;DIRIO;1" & CR &
"2;LA;08;DIRIO;0" & CR &
"2;LA;09;DIRIO;1" & CR &
"2;LA;10;DIRIO;1" & CR &
"2;LA;11;DIRIO;1" & CR &
"2;LA;12;DIRIO;1" & CR &
"2;LA;13;DIRIO;1" & CR &
"2;LA;14;DIRIO;1" & CR &
"2;LA;15;DIRIO;1" & CR &
"2;LA;16;DIRIO;0" & CR &
"2;LA;17;DIRIO;1" & CR &
"2;LA;18;DIRIO;0" & CR &
"2;LA;19;DIRIO;1" & CR &
"2;LA;20;DIRIO;0" & CR &
"2;LA;21;DIRIO;1" & CR &
"2;LA;22;DIRIO;1" & CR &
"2;LA;23;DIRIO;1" & CR &
"2;LA;24;DIRIO;0" & CR &
"2;LA;25;DIRIO;1" & CR &
"2;LA;26;DIRIO;1" & CR &
"2;LA;27;DIRIO;0" & CR &
"2;LA;28;DIRIO;1" & CR &
"2;LA;29;DIRIO;1" & CR &
"2;LA;30;DIRIO;0" & CR &
"2;LA;31;DIRIO;1" & CR &
"2;LA;32;DIRIO;0" & CR &
"2;LA;33;DIRIO;0" & CR;
  
  
  
  constant afc_pinmap_len: natural := 2 * (c_fmc_LA_pin_count + c_fmc_HA_pin_count + c_fmc_HB_pin_count);
  constant afc_v2_FMC_pinmap : t_fmc_pin_map_vector(afc_pinmap_len - 1 downto 0) := (
  0 => ( fmc_id => 1, iob_type  => HA, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
  1 => ( fmc_id => 1, iob_type  => HA, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
  2 => ( fmc_id => 1, iob_type  => HA, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
  3 => ( fmc_id => 1, iob_type  => HA, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
  4 => ( fmc_id => 1, iob_type  => HA, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
  5 => ( fmc_id => 1, iob_type  => HA, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
  6 => ( fmc_id => 1, iob_type  => HA, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
  7 => ( fmc_id => 1, iob_type  => HA, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
  8 => ( fmc_id => 1, iob_type  => HA, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
  9 => ( fmc_id => 1, iob_type  => HA, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
  
 10 => ( fmc_id => 1, iob_type  => HA, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 11 => ( fmc_id => 1, iob_type  => HA, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 12 => ( fmc_id => 1, iob_type  => HA, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 13 => ( fmc_id => 1, iob_type  => HA, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 14 => ( fmc_id => 1, iob_type  => HA, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 15 => ( fmc_id => 1, iob_type  => HA, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 16 => ( fmc_id => 1, iob_type  => HA, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 17 => ( fmc_id => 1, iob_type  => HA, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 18 => ( fmc_id => 1, iob_type  => HA, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 19 => ( fmc_id => 1, iob_type  => HA, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 
 20 => ( fmc_id => 1, iob_type  => HA, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 21 => ( fmc_id => 1, iob_type  => HA, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 22 => ( fmc_id => 1, iob_type  => HA, iob_index => 22, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 23 => ( fmc_id => 1, iob_type  => HA, iob_index => 23, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 24 => ( fmc_id => 1, iob_type  => HB, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 25 => ( fmc_id => 1, iob_type  => HB, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 26 => ( fmc_id => 1, iob_type  => HB, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 27 => ( fmc_id => 1, iob_type  => HB, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 28 => ( fmc_id => 1, iob_type  => HB, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 29 => ( fmc_id => 1, iob_type  => HB, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 30 => ( fmc_id => 1, iob_type  => HB, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 31 => ( fmc_id => 1, iob_type  => HB, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 32 => ( fmc_id => 1, iob_type  => HB, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 33 => ( fmc_id => 1, iob_type  => HB, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 34 => ( fmc_id => 1, iob_type  => HB, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 35 => ( fmc_id => 1, iob_type  => HB, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 36 => ( fmc_id => 1, iob_type  => HB, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 37 => ( fmc_id => 1, iob_type  => HB, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 38 => ( fmc_id => 1, iob_type  => HB, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 39 => ( fmc_id => 1, iob_type  => HB, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 40 => ( fmc_id => 1, iob_type  => HB, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 41 => ( fmc_id => 1, iob_type  => HB, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 42 => ( fmc_id => 1, iob_type  => HB, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 43 => ( fmc_id => 1, iob_type  => HB, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 44 => ( fmc_id => 1, iob_type  => HB, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 45 => ( fmc_id => 1, iob_type  => HB, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 46 => ( fmc_id => 1, iob_type  => LA, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 47 => ( fmc_id => 1, iob_type  => LA, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 48 => ( fmc_id => 1, iob_type  => LA, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 49 => ( fmc_id => 1, iob_type  => LA, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 50 => ( fmc_id => 1, iob_type  => LA, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 51 => ( fmc_id => 1, iob_type  => LA, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 52 => ( fmc_id => 1, iob_type  => LA, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 53 => ( fmc_id => 1, iob_type  => LA, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 54 => ( fmc_id => 1, iob_type  => LA, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 55 => ( fmc_id => 1, iob_type  => LA, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 56 => ( fmc_id => 1, iob_type  => LA, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 57 => ( fmc_id => 1, iob_type  => LA, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 58 => ( fmc_id => 1, iob_type  => LA, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 59 => ( fmc_id => 1, iob_type  => LA, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 60 => ( fmc_id => 1, iob_type  => LA, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 61 => ( fmc_id => 1, iob_type  => LA, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 62 => ( fmc_id => 1, iob_type  => LA, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 63 => ( fmc_id => 1, iob_type  => LA, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 64 => ( fmc_id => 1, iob_type  => LA, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 65 => ( fmc_id => 1, iob_type  => LA, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 66 => ( fmc_id => 1, iob_type  => LA, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 67 => ( fmc_id => 1, iob_type  => LA, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 68 => ( fmc_id => 1, iob_type  => LA, iob_index => 22, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 69 => ( fmc_id => 1, iob_type  => LA, iob_index => 23, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 70 => ( fmc_id => 1, iob_type  => LA, iob_index => 24, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 71 => ( fmc_id => 1, iob_type  => LA, iob_index => 25, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 72 => ( fmc_id => 1, iob_type  => LA, iob_index => 26, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 73 => ( fmc_id => 1, iob_type  => LA, iob_index => 27, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 74 => ( fmc_id => 1, iob_type  => LA, iob_index => 28, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 75 => ( fmc_id => 1, iob_type  => LA, iob_index => 29, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 76 => ( fmc_id => 1, iob_type  => LA, iob_index => 30, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 77 => ( fmc_id => 1, iob_type  => LA, iob_index => 31, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 78 => ( fmc_id => 1, iob_type  => LA, iob_index => 32, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 79 => ( fmc_id => 1, iob_type  => LA, iob_index => 33, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 80 => ( fmc_id => 2, iob_type  => HA, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 81 => ( fmc_id => 2, iob_type  => HA, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 82 => ( fmc_id => 2, iob_type  => HA, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 83 => ( fmc_id => 2, iob_type  => HA, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 84 => ( fmc_id => 2, iob_type  => HA, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 85 => ( fmc_id => 2, iob_type  => HA, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 86 => ( fmc_id => 2, iob_type  => HA, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 87 => ( fmc_id => 2, iob_type  => HA, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 88 => ( fmc_id => 2, iob_type  => HA, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 89 => ( fmc_id => 2, iob_type  => HA, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 90 => ( fmc_id => 2, iob_type  => HA, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 91 => ( fmc_id => 2, iob_type  => HA, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 92 => ( fmc_id => 2, iob_type  => HA, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 93 => ( fmc_id => 2, iob_type  => HA, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 94 => ( fmc_id => 2, iob_type  => HA, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 95 => ( fmc_id => 2, iob_type  => HA, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
 96 => ( fmc_id => 2, iob_type  => HA, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 97 => ( fmc_id => 2, iob_type  => HA, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 98 => ( fmc_id => 2, iob_type  => HA, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
 99 => ( fmc_id => 2, iob_type  => HA, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
100 => ( fmc_id => 2, iob_type  => HA, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
101 => ( fmc_id => 2, iob_type  => HA, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
102 => ( fmc_id => 2, iob_type  => HA, iob_index => 22, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
103 => ( fmc_id => 2, iob_type  => HA, iob_index => 23, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
104 => ( fmc_id => 2, iob_type  => HB, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
105 => ( fmc_id => 2, iob_type  => HB, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
106 => ( fmc_id => 2, iob_type  => HB, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
107 => ( fmc_id => 2, iob_type  => HB, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
108 => ( fmc_id => 2, iob_type  => HB, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
109 => ( fmc_id => 2, iob_type  => HB, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
110 => ( fmc_id => 2, iob_type  => HB, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
111 => ( fmc_id => 2, iob_type  => HB, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
112 => ( fmc_id => 2, iob_type  => HB, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
113 => ( fmc_id => 2, iob_type  => HB, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
114 => ( fmc_id => 2, iob_type  => HB, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
115 => ( fmc_id => 2, iob_type  => HB, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
116 => ( fmc_id => 2, iob_type  => HB, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
117 => ( fmc_id => 2, iob_type  => HB, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
118 => ( fmc_id => 2, iob_type  => HB, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
119 => ( fmc_id => 2, iob_type  => HB, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
120 => ( fmc_id => 2, iob_type  => HB, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
121 => ( fmc_id => 2, iob_type  => HB, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
122 => ( fmc_id => 2, iob_type  => HB, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
123 => ( fmc_id => 2, iob_type  => HB, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
124 => ( fmc_id => 2, iob_type  => HB, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
125 => ( fmc_id => 2, iob_type  => HB, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
126 => ( fmc_id => 2, iob_type  => LA, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
127 => ( fmc_id => 2, iob_type  => LA, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
128 => ( fmc_id => 2, iob_type  => LA, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
129 => ( fmc_id => 2, iob_type  => LA, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
130 => ( fmc_id => 2, iob_type  => LA, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
131 => ( fmc_id => 2, iob_type  => LA, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
132 => ( fmc_id => 2, iob_type  => LA, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
133 => ( fmc_id => 2, iob_type  => LA, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
134 => ( fmc_id => 2, iob_type  => LA, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
135 => ( fmc_id => 2, iob_type  => LA, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
136 => ( fmc_id => 2, iob_type  => LA, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
137 => ( fmc_id => 2, iob_type  => LA, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
138 => ( fmc_id => 2, iob_type  => LA, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
139 => ( fmc_id => 2, iob_type  => LA, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
140 => ( fmc_id => 2, iob_type  => LA, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
141 => ( fmc_id => 2, iob_type  => LA, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
142 => ( fmc_id => 2, iob_type  => LA, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
143 => ( fmc_id => 2, iob_type  => LA, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
144 => ( fmc_id => 2, iob_type  => LA, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
145 => ( fmc_id => 2, iob_type  => LA, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
146 => ( fmc_id => 2, iob_type  => LA, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
147 => ( fmc_id => 2, iob_type  => LA, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
148 => ( fmc_id => 2, iob_type  => LA, iob_index => 22, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
149 => ( fmc_id => 2, iob_type  => LA, iob_index => 23, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
150 => ( fmc_id => 2, iob_type  => LA, iob_index => 24, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
151 => ( fmc_id => 2, iob_type  => LA, iob_index => 25, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
152 => ( fmc_id => 2, iob_type  => LA, iob_index => 26, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
153 => ( fmc_id => 2, iob_type  => LA, iob_index => 27, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
154 => ( fmc_id => 2, iob_type  => LA, iob_index => 28, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
155 => ( fmc_id => 2, iob_type  => LA, iob_index => 29, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
156 => ( fmc_id => 2, iob_type  => LA, iob_index => 30, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
157 => ( fmc_id => 2, iob_type  => LA, iob_index => 31, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "x", iob_pinb  =>"x" ),
158 => ( fmc_id => 2, iob_type  => LA, iob_index => 32, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ),
159 => ( fmc_id => 2, iob_type  => LA, iob_index => 33, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "x", iob_pinb  =>"x" ) --,
  --others => c_fmc_pin_empty
  );
  
  
  constant afc_v2_FMC1_LA_inv : bit_vector(33 downto 0) := fmc_pin_map_to_inv_vector(fmc_id => 1, pin_type => LA, fmc_pin_map => afc_v2_FMC_pinmap);
  constant afc_v2_FMC1_HA_inv : bit_vector(23 downto 0) := fmc_pin_map_to_inv_vector(fmc_id => 1, pin_type => HA, fmc_pin_map => afc_v2_FMC_pinmap);
  constant afc_v2_FMC1_HB_inv : bit_vector(21 downto 0) := fmc_pin_map_to_inv_vector(fmc_id => 1, pin_type => HB, fmc_pin_map => afc_v2_FMC_pinmap);

  constant afc_v2_FMC2_LA_inv : bit_vector(33 downto 0) := fmc_pin_map_to_inv_vector(fmc_id => 1, pin_type => LA, fmc_pin_map => afc_v2_FMC_pinmap);
  constant afc_v2_FMC2_HA_inv : bit_vector(23 downto 0) := fmc_pin_map_to_inv_vector(fmc_id => 1, pin_type => HA, fmc_pin_map => afc_v2_FMC_pinmap);
  constant afc_v2_FMC2_HB_inv : bit_vector(21 downto 0) := fmc_pin_map_to_inv_vector(fmc_id => 1, pin_type => HB, fmc_pin_map => afc_v2_FMC_pinmap);
  
end afc_pkg;


package body afc_pkg is

end afc_pkg;
