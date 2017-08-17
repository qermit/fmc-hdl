library ieee;
use ieee.std_logic_1164.all;

library std;
use std.textio.all;

use work.fmc_general_pkg.all;
use work.txt_util.all;
use work.wishbone_pkg.all;


package fmc_helper_pkg is

function write_xdc(FileName : String;
                   fmc_id: natural;
                   carrier_board: t_fmc_pin_map_vector;
                   fmc_board: t_iodelay_map_vector) return boolean;
                   
                   
function write_carrier_to_csv(FileName : String; carrier_board: t_fmc_pin_map_vector) return boolean;                   


function sdb_dump_to_file(FileName : String; layout: t_sdb_record_array; sdb_address : t_wishbone_address) return boolean;

function f_test_logger(FileName : String; value: string) return boolean;
function f_test_open(FileName : String) return boolean;
                   
end fmc_helper_pkg;


package body fmc_helper_pkg is

function f_test_logger(FileName : String; value: string) return boolean is
  file FileHandle   : TEXT open append_MODE is FileName;
variable VEC_LINE : line;
begin
  write(vec_line, value);
  writeline(FileHandle, vec_line);
  return true;
end function;

function f_test_open(FileName : String) return boolean is
  file FileHandle   : TEXT open read_mode is FileName;
variable VEC_LINE : line;
begin
  
  return true;
end function;


function gen_xdc_line_location(carrier_pin: t_fmc_pin_map; fmc_pin: t_iodelay_map) return string is
  variable pin_pol: string := "p";
  variable iob_pin: string := pin_unknown;
  variable is_comment: string := "#";
begin

   if fmc_pin.iob_diff = DIFF then
     pin_pol:="p";
     iob_pin := carrier_pin.iob_pin;
   elsif fmc_pin.iob_diff = NEG then
     pin_pol:="n";
     if carrier_pin.iob_swap = '0' then
       iob_pin := carrier_pin.iob_pinb;
     else
       iob_pin := carrier_pin.iob_pin;
     end if;
   elsif fmc_pin.iob_diff = POS then
     pin_pol:="p";
     if carrier_pin.iob_swap = '0' then
       iob_pin := carrier_pin.iob_pin; 
     else
       iob_pin := carrier_pin.iob_pinb;
     end if;
   end if;

   if iob_pin /= pin_unknown then
     is_comment:=string'(" ");
   end if;
   
   
      assert iob_pin /= pin_unknown report "FMC" & str(carrier_pin.fmc_id) & ": cannot find pin: " & str(fmc_pin.iob_index) severity note;
   
     return is_comment & string'("set_property PACKAGE_PIN ") & 
          iob_pin & "    " &
          string'(" [get_ports {fmc_inout[" ) & 
          str(carrier_pin.fmc_id) & 
          string'("][") & 
          fmc_pin_type_to_str(fmc_pin.iob_type) & 
          string'("_") & 
          pin_pol & 
          string'("][") 
          & str(fmc_pin.iob_index) & 
          string'("]}]");

end function;

function gen_xdc_line_iostandard(carrier_pin: t_fmc_pin_map; fmc_pin: t_iodelay_map) return string is
  variable pin_pol: string := "p";
  variable iob_pin: string := "        ";
  variable is_comment: string := "#";
begin

   if fmc_pin.iob_diff = DIFF then
     pin_pol:="p";
     iob_pin := "LVDS_25 ";
   elsif fmc_pin.iob_diff = NEG then
     pin_pol:="n";
     iob_pin := "LVCMOS25";
   elsif fmc_pin.iob_diff = POS then
     pin_pol:="p";
     iob_pin := "LVCMOS25";
   end if;

   if iob_pin /= pin_unknown then
     is_comment:=string'(" ");
   end if;
   
   
      assert iob_pin /= pin_unknown report "FMC" & str(carrier_pin.fmc_id) & ": cannot find pin: " & str(fmc_pin.iob_index) severity note;
-- set_property IOSTANDARD LVDS_25 [get_ports {fmc2_inout[LA_p][17]}]
   
     return is_comment & string'("set_property IOSTANDARD  ") & 
          iob_pin &
          string'(" [get_ports {fmc_inout[" ) & 
          str(carrier_pin.fmc_id) & 
          string'("][") & 
          fmc_pin_type_to_str(fmc_pin.iob_type) & 
          string'("_") & 
          pin_pol & 
          string'("][") 
          & str(fmc_pin.iob_index) & 
          string'("]}]");

end function;

constant C_SDB_DEVICE_ID : std_logic_vector(7 downto 0) := x"01";
constant C_SDB_BRIDGE_ID : std_logic_vector(7 downto 0) := x"02";

constant C_SDB_INTEGRATION_ID : std_logic_vector(7 downto 0) := x"80";


function sdb_dump_to_file(FileName : String; layout: t_sdb_record_array; sdb_address : t_wishbone_address) return boolean is
  file FileHandle   : TEXT open WRITE_MODE is FileName;
  variable VEC_LINE : line;
  variable entry: std_logic_vector(31 downto 0);
--  variable entry_line: std_logic_vector(32*16-1 downto 0);
  variable v_device: t_sdb_device;
  variable v_bridge: t_sdb_bridge;
  
begin
  write(vec_line, string'("SDB Address"));
  writeline(FileHandle, vec_line);
  
  write(vec_line, hstr(sdb_address));
  writeline(FileHandle, vec_line);
  
  for I in layout'low to layout'high loop
     write(vec_line, string'("     SDB Entry: "));
     for J in 15 downto 0 loop 
       entry := layout(I)(((J+1)*32)-1  downto ((J)*32));
       write(vec_line, hstr(entry));
     end loop;
     writeline(FileHandle, vec_line);   
     if  layout(I)(7 downto 0) =  C_SDB_DEVICE_ID then
       v_device := f_sdb_extract_device(layout(I));
       write(vec_line, string'("Component name: "));
       write(vec_line, v_device.sdb_component.product.name);
       writeline(FileHandle, vec_line);
       
       write(vec_line, string'(" Address range: "));
       write(vec_line, hstr(v_device.sdb_component.addr_first));
       write(vec_line, string'(" - "));
       write(vec_line, hstr(v_bridge.sdb_component.addr_last));
       writeline(FileHandle, vec_line);
     elsif  layout(I)(7 downto 0) =  C_SDB_BRIDGE_ID then
         v_bridge := f_sdb_extract_bridge(layout(I));
         write(vec_line, string'("   Bridge name: "));
         write(vec_line, v_bridge.sdb_component.product.name);
         writeline(FileHandle, vec_line);
         
         write(vec_line, string'(" Address range: "));
         write(vec_line, hstr(v_bridge.sdb_component.addr_first));
         write(vec_line, string'(" - "));
         write(vec_line, hstr(v_bridge.sdb_component.addr_last));
         
         writeline(FileHandle, vec_line);
     end if; 
     
     
  end loop;
  
  
  
  
  
    
  return true;
end function;

function write_carrier_to_csv(FileName : String; carrier_board: t_fmc_pin_map_vector) return boolean is
  file FileHandle   : TEXT open WRITE_MODE is FileName;
  variable VEC_LINE : line;
  variable swap : string := "0";
begin
  write(vec_line, string'("FMC_ID;IOB_TYPE;IOB_INDEX;IOB_DIR;IOB_SWAP;IOB_PIN;IOB_PINB"));
  writeline(FileHandle, vec_line);
  
  for I in carrier_board'low to carrier_board'high loop
    if carrier_board(I).iob_swap = '1' then
      swap := "1";
    else
      swap := "0";
    end if;
    write(vec_line, str(carrier_board(I).fmc_id) & ";" & 
                    fmc_pin_type_to_str(carrier_board(I).iob_type) & ";" & 
                    str(carrier_board(I).iob_index) & ";" & 
                    fmc_dir_type_to_str(carrier_board(I).iob_dir) & ";" &
                    swap & ";" & 
                    carrier_board(I).iob_pin & ";" & 
                    carrier_board(I).iob_pinb & ";" );
    writeline(FileHandle, vec_line);
  end loop;
  return true;
end function;

function write_xdc(FileName : String; 
                   fmc_id: natural;
                   carrier_board: t_fmc_pin_map_vector;
                   fmc_board: t_iodelay_map_vector) return boolean is
  file FileHandle   : TEXT open WRITE_MODE is FileName;
  variable VEC_LINE : line;
  
begin
  
  for I in fmc_board'low to fmc_board'high loop
      if fmc_board(I) /= c_iodelay_map_empty then
      -- Location
         write(vec_line, gen_xdc_line_location( fmc_pin_map_extract_fmc_pin(fmc_id, fmc_board(I).iob_type, fmc_board(I).iob_index, carrier_board), fmc_board(I))); 
         writeline(FileHandle, vec_line);
         write(vec_line, gen_xdc_line_iostandard( fmc_pin_map_extract_fmc_pin(fmc_id, fmc_board(I).iob_type, fmc_board(I).iob_index, carrier_board), fmc_board(I)));
         writeline(FileHandle, vec_line);
      -- io standard ??
         
      end if;
  end loop;

   
  return true;
end function;

end fmc_helper_pkg;