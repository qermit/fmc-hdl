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
  
  -- pins are defined always as native - positive/negative according to fpga
  -- swap means they were swapped for some reason during routing
  -- iob_pin - positive
  -- iob_pinb - negative
  
  
  constant afc_pinmap_len: natural := 2 * (c_fmc_LA_pin_count + c_fmc_HA_pin_count + c_fmc_HB_pin_count);
  constant afc_v2_FMC_pinmap : t_fmc_pin_map_vector(afc_pinmap_len - 1 downto 0) := (
  0 => ( fmc_id => 1, iob_type  => HA, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "J29 ", iob_pinb  => "H29 " ),
  1 => ( fmc_id => 1, iob_type  => HA, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "L28 ", iob_pinb  => "K28 " ),
  2 => ( fmc_id => 1, iob_type  => HA, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "K33 ", iob_pinb  => "K34 " ),
  3 => ( fmc_id => 1, iob_type  => HA, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "K30 ", iob_pinb  => "J30 " ),
  4 => ( fmc_id => 1, iob_type  => HA, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "L33 ", iob_pinb  => "L34 " ),
  5 => ( fmc_id => 1, iob_type  => HA, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "J33 ", iob_pinb  => "J34 " ),
  6 => ( fmc_id => 1, iob_type  => HA, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "L27 ", iob_pinb  => "K27 " ),
  7 => ( fmc_id => 1, iob_type  => HA, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "L32 ", iob_pinb  => "K32 " ),
  8 => ( fmc_id => 1, iob_type  => HA, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "L29 ", iob_pinb  => "L30 " ),
  9 => ( fmc_id => 1, iob_type  => HA, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "K31 ", iob_pinb  => "J31 " ),
  
 10 => ( fmc_id => 1, iob_type  => HA, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "H32 ", iob_pinb  => "G32 " ),
 11 => ( fmc_id => 1, iob_type  => HA, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "M25 ", iob_pinb  => "L25 " ),
 12 => ( fmc_id => 1, iob_type  => HA, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "H33 ", iob_pinb  => "G34 " ),
 13 => ( fmc_id => 1, iob_type  => HA, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "K25 ", iob_pinb  => "J25 " ),
 14 => ( fmc_id => 1, iob_type  => HA, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "M24 ", iob_pinb  => "L24 " ),
 15 => ( fmc_id => 1, iob_type  => HA, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "G29 ", iob_pinb  => "G30 " ),
 16 => ( fmc_id => 1, iob_type  => HA, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "H31 ", iob_pinb  => "G31 " ),
 17 => ( fmc_id => 1, iob_type  => HA, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "J28 ", iob_pinb  => "H28 " ),
 18 => ( fmc_id => 1, iob_type  => HA, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "H27 ", iob_pinb  => "H27 " ),
 19 => ( fmc_id => 1, iob_type  => HA, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "H26 ", iob_pinb  => "G26 " ),
 
 20 => ( fmc_id => 1, iob_type  => HA, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "K26 ", iob_pinb  => "J26 " ),
 21 => ( fmc_id => 1, iob_type  => HA, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "G24 ", iob_pinb  => "G25 " ),
 22 => ( fmc_id => 1, iob_type  => HA, iob_index => 22, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "J24 ", iob_pinb  => "H24 " ),
 23 => ( fmc_id => 1, iob_type  => HA, iob_index => 23, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "K23 ", iob_pinb  => "J23 " ),
 
 24 => ( fmc_id => 1, iob_type  => HB, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "W5  ", iob_pinb  => "Y5  " ),
 25 => ( fmc_id => 1, iob_type  => HB, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "W9  ", iob_pinb  => "W8  " ),
 26 => ( fmc_id => 1, iob_type  => HB, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "V9  ", iob_pinb  => "V8  " ),
 27 => ( fmc_id => 1, iob_type  => HB, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "W10 ", iob_pinb  => "Y10 " ),
 28 => ( fmc_id => 1, iob_type  => HB, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "Y8  ", iob_pinb  => "Y7  " ),
 29 => ( fmc_id => 1, iob_type  => HB, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AA10", iob_pinb  => "AA9 " ),
 30 => ( fmc_id => 1, iob_type  => HB, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "V4  ", iob_pinb  => "W4  " ),
 31 => ( fmc_id => 1, iob_type  => HB, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AB10", iob_pinb  => "AB9 " ),
 32 => ( fmc_id => 1, iob_type  => HB, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "V3  ", iob_pinb  => "W3  " ),
 33 => ( fmc_id => 1, iob_type  => HB, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "V2  ", iob_pinb  => "V1  " ),
 
 34 => ( fmc_id => 1, iob_type  => HB, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "V7  ", iob_pinb  => "V6  " ),
 35 => ( fmc_id => 1, iob_type  => HB, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "W1  ", iob_pinb  => "Y1  " ),
 36 => ( fmc_id => 1, iob_type  => HB, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AC7 ", iob_pinb  => "AC6 " ),
 37 => ( fmc_id => 1, iob_type  => HB, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "Y3  ", iob_pinb  => "Y2  " ),
 38 => ( fmc_id => 1, iob_type  => HB, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AC2 ", iob_pinb  => "AC1 " ),
 39 => ( fmc_id => 1, iob_type  => HB, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AC9 ", iob_pinb  => "AC8 " ),
 40 => ( fmc_id => 1, iob_type  => HB, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AB2 ", iob_pinb  => "AB1 " ),
 41 => ( fmc_id => 1, iob_type  => HB, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AA5 ", iob_pinb  => "AA4 " ),
 42 => ( fmc_id => 1, iob_type  => HB, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AB7 ", iob_pinb  => "AB6 " ),
 43 => ( fmc_id => 1, iob_type  => HB, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AB5 ", iob_pinb  => "AB4 " ),
 
 44 => ( fmc_id => 1, iob_type  => HB, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AA3 ", iob_pinb  => "AA2 " ),
 45 => ( fmc_id => 1, iob_type  => HB, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AC4 ", iob_pinb  => "AC3 " ),
 
 46 => ( fmc_id => 1, iob_type  => LA, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "K7  ", iob_pinb  => "K8  " ),
 47 => ( fmc_id => 1, iob_type  => LA, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "J6  ", iob_pinb  => "J5  " ),
 48 => ( fmc_id => 1, iob_type  => LA, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "G7  ", iob_pinb  => "G6  " ),
 49 => ( fmc_id => 1, iob_type  => LA, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "H1  ", iob_pinb  => "G1  " ),
 50 => ( fmc_id => 1, iob_type  => LA, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "K1  ", iob_pinb  => "J1  " ),
 51 => ( fmc_id => 1, iob_type  => LA, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "H4  ", iob_pinb  => "H3  " ),
 52 => ( fmc_id => 1, iob_type  => LA, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "L5  ", iob_pinb  => "K5  " ),
 53 => ( fmc_id => 1, iob_type  => LA, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "K3  ", iob_pinb  => "K2  " ),
 54 => ( fmc_id => 1, iob_type  => LA, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "F3  ", iob_pinb  => "F2  " ),
 55 => ( fmc_id => 1, iob_type  => LA, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "J4  ", iob_pinb  => "J3  " ),
 56 => ( fmc_id => 1, iob_type  => LA, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "H2  ", iob_pinb  => "G2  " ),
 57 => ( fmc_id => 1, iob_type  => LA, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "M2  ", iob_pinb  => "L2  " ),
 58 => ( fmc_id => 1, iob_type  => LA, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "L8  ", iob_pinb  => "K8  " ),
 59 => ( fmc_id => 1, iob_type  => LA, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "G10 ", iob_pinb  => "G9  " ),
 60 => ( fmc_id => 1, iob_type  => LA, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "H9  ", iob_pinb  => "H8  " ),
 61 => ( fmc_id => 1, iob_type  => LA, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "K11 ", iob_pinb  => "J11 " ),
 62 => ( fmc_id => 1, iob_type  => LA, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "L10 ", iob_pinb  => "L9  " ),
 63 => ( fmc_id => 1, iob_type  => LA, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "T5  ", iob_pinb  => "T4  " ),
 64 => ( fmc_id => 1, iob_type  => LA, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "P4  ", iob_pinb  => "P3  " ),
 65 => ( fmc_id => 1, iob_type  => LA, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "U5  ", iob_pinb  => "U4  " ),
 66 => ( fmc_id => 1, iob_type  => LA, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "R10 ", iob_pinb  => "P10 " ),
 67 => ( fmc_id => 1, iob_type  => LA, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "M7  ", iob_pinb  => "M6  " ),
 68 => ( fmc_id => 1, iob_type  => LA, iob_index => 22, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "M5  ", iob_pinb  => "M4  " ),
 69 => ( fmc_id => 1, iob_type  => LA, iob_index => 23, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "N3  ", iob_pinb  => "N2  " ),
 70 => ( fmc_id => 1, iob_type  => LA, iob_index => 24, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "M11 ", iob_pinb  => "M10 " ),
 71 => ( fmc_id => 1, iob_type  => LA, iob_index => 25, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "N8  ", iob_pinb  => "N7  " ),
 72 => ( fmc_id => 1, iob_type  => LA, iob_index => 26, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "T3  ", iob_pinb  => "T2  " ),
 73 => ( fmc_id => 1, iob_type  => LA, iob_index => 27, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "R3  ", iob_pinb  => "R2  " ),
 74 => ( fmc_id => 1, iob_type  => LA, iob_index => 28, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "T8  ", iob_pinb  => "T7  " ),
 75 => ( fmc_id => 1, iob_type  => LA, iob_index => 29, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "P9  ", iob_pinb  => "P8  " ),
 76 => ( fmc_id => 1, iob_type  => LA, iob_index => 30, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "N1  ", iob_pinb  => "M1  " ),
 77 => ( fmc_id => 1, iob_type  => LA, iob_index => 31, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "U7  ", iob_pinb  => "U6  " ),
 78 => ( fmc_id => 1, iob_type  => LA, iob_index => 32, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "R1  ", iob_pinb  => "P1  " ),
 79 => ( fmc_id => 1, iob_type  => LA, iob_index => 33, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "U2  ", iob_pinb  => "U1  " ),
 
 80 => ( fmc_id => 2, iob_type  => HA, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AL30", iob_pinb  => "AM30" ),
 81 => ( fmc_id => 2, iob_type  => HA, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AL28", iob_pinb  => "AL29" ),
 82 => ( fmc_id => 2, iob_type  => HA, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AN31", iob_pinb  => "AP31" ),
 83 => ( fmc_id => 2, iob_type  => HA, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AM26", iob_pinb  => "AL26" ),
 84 => ( fmc_id => 2, iob_type  => HA, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AJ25", iob_pinb  => "AK25" ),
 85 => ( fmc_id => 2, iob_type  => HA, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AL25", iob_pinb  => "AM25" ),
 86 => ( fmc_id => 2, iob_type  => HA, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AL32", iob_pinb  => "AM32" ),
 87 => ( fmc_id => 2, iob_type  => HA, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AM31", iob_pinb  => "AN32" ),
 88 => ( fmc_id => 2, iob_type  => HA, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AM27", iob_pinb  => "AN27" ),
 89 => ( fmc_id => 2, iob_type  => HA, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AK26", iob_pinb  => "AJ26" ),
 
 90 => ( fmc_id => 2, iob_type  => HA, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AP25", iob_pinb  => "AP26" ),
 91 => ( fmc_id => 2, iob_type  => HA, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AK33", iob_pinb  => "AL33" ),
 92 => ( fmc_id => 2, iob_type  => HA, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AM29", iob_pinb  => "AL29" ),
 93 => ( fmc_id => 2, iob_type  => HA, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AN28", iob_pinb  => "AP28" ),
 94 => ( fmc_id => 2, iob_type  => HA, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AN34", iob_pinb  => "AP34" ),
 95 => ( fmc_id => 2, iob_type  => HA, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AJ28", iob_pinb  => "AK30" ),
 96 => ( fmc_id => 2, iob_type  => HA, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AK27", iob_pinb  => "AL27" ),
 97 => ( fmc_id => 2, iob_type  => HA, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AJ28", iob_pinb  => "AK28" ),
 98 => ( fmc_id => 2, iob_type  => HA, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AN33", iob_pinb  => "AP33" ),
 99 => ( fmc_id => 2, iob_type  => HA, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AJ30", iob_pinb  => "AK31" ),
 
100 => ( fmc_id => 2, iob_type  => HA, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AJ31", iob_pinb  => "AK32" ),
101 => ( fmc_id => 2, iob_type  => HA, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AP29", iob_pinb  => "AP30" ),
102 => ( fmc_id => 2, iob_type  => HA, iob_index => 22, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AJ33", iob_pinb  => "AJ34" ),
103 => ( fmc_id => 2, iob_type  => HA, iob_index => 23, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AL34", iob_pinb  => "AM34" ),

104 => ( fmc_id => 2, iob_type  => HB, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "U29 ", iob_pinb  => "T29 " ),
105 => ( fmc_id => 2, iob_type  => HB, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "N26 ", iob_pinb  => "M27 " ),
106 => ( fmc_id => 2, iob_type  => HB, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "N34 ", iob_pinb  => "M34 " ),
107 => ( fmc_id => 2, iob_type  => HB, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "T34 ", iob_pinb  => "U34 " ),
108 => ( fmc_id => 2, iob_type  => HB, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "U26 ", iob_pinb  => "U27 " ),
109 => ( fmc_id => 2, iob_type  => HB, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "P33 ", iob_pinb  => "P34 " ),
110 => ( fmc_id => 2, iob_type  => HB, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "R30 ", iob_pinb  => "P30 " ),
111 => ( fmc_id => 2, iob_type  => HB, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "P24 ", iob_pinb  => "N24 " ),
112 => ( fmc_id => 2, iob_type  => HB, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "R26 ", iob_pinb  => "P26 " ),
113 => ( fmc_id => 2, iob_type  => HB, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "T28 ", iob_pinb  => "R28 " ),

114 => ( fmc_id => 2, iob_type  => HB, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "U25 ", iob_pinb  => "T25 " ),
115 => ( fmc_id => 2, iob_type  => HB, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "T27 ", iob_pinb  => "R27 " ),
116 => ( fmc_id => 2, iob_type  => HB, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "N31 ", iob_pinb  => "M32 " ),
117 => ( fmc_id => 2, iob_type  => HB, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "N27 ", iob_pinb  => "N28 " ),
118 => ( fmc_id => 2, iob_type  => HB, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "R31 ", iob_pinb  => "P31 " ),
119 => ( fmc_id => 2, iob_type  => HB, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "U30 ", iob_pinb  => "T30 " ),
120 => ( fmc_id => 2, iob_type  => HB, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "U31 ", iob_pinb  => "U32 " ),
121 => ( fmc_id => 2, iob_type  => HB, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "P28 ", iob_pinb  => "P29 " ),
122 => ( fmc_id => 2, iob_type  => HB, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "N29 ", iob_pinb  => "M29 " ),
123 => ( fmc_id => 2, iob_type  => HB, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "M30 ", iob_pinb  => "M31 " ),

124 => ( fmc_id => 2, iob_type  => HB, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "N32 ", iob_pinb  => "N33 " ),
125 => ( fmc_id => 2, iob_type  => HB, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "T33 ", iob_pinb  => "R33 " ),

126 => ( fmc_id => 2, iob_type  => LA, iob_index => 00, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AE28", iob_pinb  => "AF28" ),
127 => ( fmc_id => 2, iob_type  => LA, iob_index => 01, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AF29", iob_pinb  => "AF30" ),
128 => ( fmc_id => 2, iob_type  => LA, iob_index => 02, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AG31", iob_pinb  => "AH31" ),
129 => ( fmc_id => 2, iob_type  => LA, iob_index => 03, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AG24", iob_pinb  => "AH24" ),
130 => ( fmc_id => 2, iob_type  => LA, iob_index => 04, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AC26", iob_pinb  => "AC27" ),
131 => ( fmc_id => 2, iob_type  => LA, iob_index => 05, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AH33", iob_pinb  => "AH34" ),
132 => ( fmc_id => 2, iob_type  => LA, iob_index => 06, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AE23", iob_pinb  => "AF23" ),
133 => ( fmc_id => 2, iob_type  => LA, iob_index => 07, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AG27", iob_pinb  => "AH27" ),
134 => ( fmc_id => 2, iob_type  => LA, iob_index => 08, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AD25", iob_pinb  => "AE25" ),
135 => ( fmc_id => 2, iob_type  => LA, iob_index => 09, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AF25", iob_pinb  => "AG25" ),

136 => ( fmc_id => 2, iob_type  => LA, iob_index => 10, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AG32", iob_pinb  => "AH32" ),
137 => ( fmc_id => 2, iob_type  => LA, iob_index => 11, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AD30", iob_pinb  => "AE30" ),
138 => ( fmc_id => 2, iob_type  => LA, iob_index => 12, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AF27", iob_pinb  => "AE27" ),
139 => ( fmc_id => 2, iob_type  => LA, iob_index => 13, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AF34", iob_pinb  => "AG34" ),
140 => ( fmc_id => 2, iob_type  => LA, iob_index => 14, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AE33", iob_pinb  => "AF33" ),
141 => ( fmc_id => 2, iob_type  => LA, iob_index => 15, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AD28", iob_pinb  => "AD29" ),
142 => ( fmc_id => 2, iob_type  => LA, iob_index => 16, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AD33", iob_pinb  => "AD34" ),
143 => ( fmc_id => 2, iob_type  => LA, iob_index => 17, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AB31", iob_pinb  => "AB32" ),
144 => ( fmc_id => 2, iob_type  => LA, iob_index => 18, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "W30 ", iob_pinb  => "W31 " ),
145 => ( fmc_id => 2, iob_type  => LA, iob_index => 19, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AB26", iob_pinb  => "AB27" ),

146 => ( fmc_id => 2, iob_type  => LA, iob_index => 20, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AB24", iob_pinb  => "AB25" ),
147 => ( fmc_id => 2, iob_type  => LA, iob_index => 21, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AA32", iob_pinb  => "AA33" ),
148 => ( fmc_id => 2, iob_type  => LA, iob_index => 22, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AA24", iob_pinb  => "AA25" ),
149 => ( fmc_id => 2, iob_type  => LA, iob_index => 23, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "W25 ", iob_pinb  => "Y25 " ),
150 => ( fmc_id => 2, iob_type  => LA, iob_index => 24, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "Y32 ", iob_pinb  => "Y33 " ),
151 => ( fmc_id => 2, iob_type  => LA, iob_index => 25, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AA29", iob_pinb  => "AB29" ),
152 => ( fmc_id => 2, iob_type  => LA, iob_index => 26, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AC31", iob_pinb  => "AC32" ),
153 => ( fmc_id => 2, iob_type  => LA, iob_index => 27, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AA27", iob_pinb  => "AA28" ),
154 => ( fmc_id => 2, iob_type  => LA, iob_index => 28, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "W28 ", iob_pinb  => "W29 " ),
155 => ( fmc_id => 2, iob_type  => LA, iob_index => 29, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "AC33", iob_pinb  => "AC34" ),

156 => ( fmc_id => 2, iob_type  => LA, iob_index => 30, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "W33 ", iob_pinb  => "W34 " ),
157 => ( fmc_id => 2, iob_type  => LA, iob_index => 31, iob_dir   => DIRIO, iob_swap  => '1', iob_pin   => "V31 ", iob_pinb  => "V32 " ),
158 => ( fmc_id => 2, iob_type  => LA, iob_index => 32, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "AA34", iob_pinb  => "AB34" ),
159 => ( fmc_id => 2, iob_type  => LA, iob_index => 33, iob_dir   => DIRIO, iob_swap  => '0', iob_pin   => "V33 ", iob_pinb  => "V34 " ) --,
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
