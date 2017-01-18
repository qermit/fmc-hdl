library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

use work.fmc_general_pkg.all;

package fmc_carrier_helpers_pkg is
	function fmc_file_line_count(FileName: string) return integer ;
    function fmc_pin_map_from_csv(FileName: string) return t_fmc_pin_map_vector;
    function fmc_csv2pin_map_vector(constant csv : in string; constant  csv_separator: in character; constant csv_nl: in character) return t_fmc_pin_map_vector;

	
end package fmc_carrier_helpers_pkg;

package body fmc_carrier_helpers_pkg is	
-- private functions

    function str_search_ch(constant str: in string;
                           constant ch: in character;
                           constant start: in integer;
                           constant last: in integer) return integer is
        variable I: integer := -1;
        variable vlast: integer;
    begin
        if last = -1 then
          vlast:=str'length+1;
        elsif last < str'length then
          vlast:=last;
        else
          vlast:=str'length+1;
        end if;
        
        I:=start;
        while I < vlast loop
          if str(I) = ch then
            return I;
          end if;
          I:=I+1;
        end loop;
        if I = start then
            return -1;
        else
            return last;
        end if;
        return -1;
    end str_search_ch;
	
    function str_to_int(constant str: in string) return integer is
      variable c : integer;
    begin
       if str = "00" or str = "0" then c:= 0;
    elsif str = "01" or str = "1"  then c:= 1;
    elsif str = "02" or str = "2"  then c:= 2;
    elsif str = "03" or str = "3"  then c:= 3;
    elsif str = "04" or str = "4"  then c:= 4;
    elsif str = "05" or str = "5"  then c:= 5;
    elsif str = "06" or str = "6"  then c:= 6;
    elsif str = "07" or str = "7"  then c:= 7;
    elsif str = "08" or str = "8"  then c:= 8;
    elsif str = "09" or str = "9"  then c:= 9;
    elsif str = "10" then c:= 10;
    elsif str = "11" then c:= 11;
    elsif str = "12" then c:= 12;
    elsif str = "13" then c:= 13;
    elsif str = "14" then c:= 14;
    elsif str = "15" then c:= 15;
    elsif str = "16" then c:= 16;
    elsif str = "17" then c:= 17;
    elsif str = "18" then c:= 18;
    elsif str = "19" then c:= 19;
    elsif str = "20" then c:= 20;
    elsif str = "21" then c:= 21;
    elsif str = "22" then c:= 22;
    elsif str = "23" then c:= 23;
    elsif str = "24" then c:= 24;
    elsif str = "25" then c:= 25;
    elsif str = "26" then c:= 26;
    elsif str = "27" then c:= 27;
    elsif str = "28" then c:= 28;
    elsif str = "29" then c:= 29;
    elsif str = "30" then c:= 30;
    elsif str = "31" then c:= 31;
    elsif str = "32" then c:= 32;
    elsif str = "33" then c:= 33;
    elsif str = "34" then c:= 34;
    elsif str = "35" then c:= 35;
    elsif str = "36" then c:= 36;
    elsif str = "37" then c:= 37;
    elsif str = "38" then c:= 38;
    elsif str = "39" then c:= 39;
    elsif str = "40" then c:= 40;
    elsif str = "41" then c:= 41;
    elsif str = "42" then c:= 42;
    elsif str = "43" then c:= 43;
    elsif str = "44" then c:= 44;
    elsif str = "45" then c:= 45;
    elsif str = "46" then c:= 46;
    elsif str = "47" then c:= 47;
    elsif str = "48" then c:= 48;
    elsif str = "49" then c:= 49;
    else c:= -1;
    end if;
  return c;
    end str_to_int;	
	-- public

	
	    function fmc_pin_normalize(pin: string) return string is
       variable pin_normalized : string(1 to pin_unknown'high);
    begin
       
       if pin'length > pin_unknown'length then
          pin_normalized(1 to pin_unknown'high) := pin(pin_unknown'low to pin_unknown'low+pin_unknown'length-1);
       else
          pin_normalized(1 to pin'length) := pin;
       end if;
       assert false report "fmc_pin_normalize("&pin&"): => "&  pin_normalized;
       return pin_normalized;
    end function;
    
    function fmc_file_line_count(FileName: string) return integer is
      variable line_count: integer := 0;
      variable status   : file_open_status;
      file f_in         : text;
      variable l        : line;

    begin
      file_open(status, f_in, FileName, read_mode);
      if(status /= open_ok) then
        report "fmc_file_line_count(): can't open file '"&FileName&"'" severity failure;
      end if;
      
      while true loop
        readline(f_in, l);
        if endfile(f_in) then
          file_close(f_in);
          return line_count;
        end if;
        line_count := line_count + 1;
      end loop;
      
      return line_count;
    end function;
    
    function fmc_pin_map_from_csv(FileName: string) return t_fmc_pin_map_vector is
      variable max_entries: integer := fmc_file_line_count(FileName);
      variable entries : t_fmc_pin_map_vector(max_entries-1 downto 0) := (others => c_fmc_pin_empty);
      
       variable status   : file_open_status;
       file f_in         : text;
       variable l        : line;
       variable good     : boolean := false;
       
       -- 
       variable tmp_pin_map: t_fmc_pin_map;
       
       variable ls       : string(1 to 128);
       variable lsc      : character;
       variable line_id: integer;
       variable line_end: integer;
       variable field_id: integer;
       variable field_end: integer;
       variable field_start: integer;
       variable csv_separator : character := ';';
       
       variable FMC_ID: integer := -1;
       variable IOB_TYPE: integer := -1;
       variable IOB_INDEX: integer := -1;
       variable IOB_DIR: integer := -1;
       variable IOB_SWAP: integer := -1;
       variable IOB_PIN: integer := -1;
       variable IOB_PINB: integer := -1;
    begin

      file_open(status, f_in, FileName, read_mode);
      if(status /= open_ok) then
        report "fmc_file_line_count(): can't open file '"&FileName&"'" severity failure;
      end if;
      
      
      
      -- read header
      readline(f_in, l);
      line_end := 0;
      while line_end < ls'high loop 
         lsc := character'val(0);
         read(l, lsc, good);         
         exit when good = false or lsc = character'val(0);
         line_end := line_end+1;
         ls(line_end) := lsc;
      end loop;
      
      
      field_id := 0;
      field_end := 0;
      
      HEADER_SEARCH: while field_id < 10 loop
         field_start := field_end + 1;
         field_end := str_search_ch(ls,csv_separator,field_start, line_end+1);
                     
         if field_end = -1 then
            exit HEADER_SEARCH;
         end if;

        if ls(field_start to field_end-1) = "FMC_ID" then
          FMC_ID := field_id;
        elsif ls(field_start to field_end-1) = "IOB_TYPE" then
          IOB_TYPE := field_id;
        elsif ls(field_start to field_end-1) = "IOB_INDEX" then
          IOB_INDEX := field_id;
        elsif ls(field_start to field_end-1) = "IOB_DIR" then
          IOB_DIR := field_id;
        elsif ls(field_start to field_end-1) = "IOB_SWAP" then
          IOB_SWAP := field_id;
        elsif ls(field_start to field_end-1) = "IOB_PIN" then
          IOB_PIN := field_id;
        elsif ls(field_start to field_end-1) = "IOB_PINB" then
          IOB_PINB := field_id;
        end if;         
      
         field_id := field_id + 1;
      end loop;
            
      line_id:=0;
      
      while endfile(f_in) = false loop
        readline(f_in, l);
        line_end := 0;
        while line_end < ls'high loop 
          lsc := character'val(0);
          read(l, lsc, good);         
          exit when good = false or lsc = character'val(0);
          line_end := line_end+1;
          ls(line_end) := lsc;
        end loop;
      
      
        field_end := 0;
        field_id := 0;
          FIELD_SEARCH: loop
                            field_start := field_end + 1;
                            field_end := str_search_ch(ls,csv_separator,field_start,line_end+1);
                            if field_end = -1 then
                                exit FIELD_SEARCH;
                            end if;
                            
                            if field_id = FMC_ID then
                               if ls(field_start to field_end-1) = "1" then
                                 tmp_pin_map.fmc_id := 1;
                               elsif ls(field_start to field_end-1) = "2" then
                                 tmp_pin_map.fmc_id := 2;
                               end if;
                                
                            elsif field_id = IOB_TYPE then
                                if ls(field_start to field_end-1) = "LA" then
                                    tmp_pin_map.iob_type:=LA;
                                elsif ls(field_start to field_end-1) = "HA" then
                                    tmp_pin_map.iob_type:=HA;
                                elsif ls(field_start to field_end-1) = "HB" then
                                    tmp_pin_map.iob_type:=HB;
                                end if;
                                
                             elsif field_id = IOB_INDEX then
                                 tmp_pin_map.iob_index := str_to_int(ls(field_start to field_end-1));
                                 
                             elsif field_id = IOB_DIR then
                                 if ls(field_start to field_end-1) = "DIRIN" then
                                     tmp_pin_map.iob_dir:=DIRIN;
                                 elsif ls(field_start to field_end-1) = "DIROUT" then
                                     tmp_pin_map.iob_dir:=DIROUT;
                                 elsif ls(field_start to field_end-1) = "DIRIO" then
                                     tmp_pin_map.iob_dir:=DIRIO;
                                 elsif ls(field_start to field_end-1) = "DIRNONE" then
                                     tmp_pin_map.iob_dir:=DIRNONE;
                                 end if;
                             elsif field_id = IOB_SWAP then
                                 if ls(field_start to field_end-1) = "0" then
                                     tmp_pin_map.iob_swap:='0';
                                 elsif ls(field_start to field_end-1) = "1" then
                                     tmp_pin_map.iob_swap:='1';
                                 end if;
                             elsif field_id = IOB_PIN then
                                 tmp_pin_map.iob_pin := fmc_pin_normalize(ls(field_start to field_end-1));                       
                             elsif field_id = IOB_PINB then
                                 tmp_pin_map.iob_pinb := fmc_pin_normalize(ls(field_start to field_end-1));                       
                             end if;
                             field_id := field_id + 1;
                        end loop;
                        
                        entries(line_id).fmc_id := tmp_pin_map.fmc_id;
                        entries(line_id).iob_type := tmp_pin_map.iob_type;
                        entries(line_id).iob_index := tmp_pin_map.iob_index;
                        entries(line_id).iob_dir := tmp_pin_map.iob_dir;
                        entries(line_id).iob_swap := tmp_pin_map.iob_swap;
                        entries(line_id).iob_pin := tmp_pin_map.iob_pin;
                        entries(line_id).iob_pinb := tmp_pin_map.iob_pinb;
        
         -- assert false report "fmc_file_line_count("& integer'IMAGE(entries(line_id).fmc_id) & "): " & integer'IMAGE(entries(line_id).iob_index) & "->" & entries(line_id).iob_pinb severity note;
        
          line_id := line_id + 1;
      end loop;
      
      --max_entries 
      
      --assert false report "fmc_file_line_count(): can't open file '"&FileName&"' -> " & integer'IMAGE(line_id) severity error;
      return entries(line_id-1 downto 0);
    end function;
    
    
	function fmc_csv2pin_map_vector(constant csv : in string; constant  csv_separator: in character; constant csv_nl: in character) return t_fmc_pin_map_vector is
        variable FMC_ID: integer := -1;
        variable IOB_TYPE: integer := -1;
        variable IOB_INDEX: integer := -1;
        variable IOB_DIR: integer := -1;
        variable IOB_SWAP: integer := -1;
        
        variable line_start: integer;
        variable line_end: integer;
        variable line_id: integer;
        variable field_id: integer;
        variable field_start: integer;
        variable field_end: integer;
        
        variable tmp_pin_map: t_fmc_pin_map;
        variable fmc_pin_map_vector: t_fmc_pin_map_vector(1000 downto 0);
    begin
        line_start := 1;
        line_id := 0;
	    tmp_pin_map.fmc_id := 0;
	    line_end := 0;
	    LINE_SEARCH: loop
            line_start:=line_end+1;
            line_end := str_search_ch(csv, csv_nl, line_start, -1);
            if line_end = -1 then
                exit LINE_SEARCH;
            end if;
	    
            field_id := 0;
            field_end := line_start-1;
	        if line_id = 0 then
                HEADER_SEARCH: while field_id < 10 loop	        
                    field_start := field_end + 1;
	                field_end := str_search_ch(csv,csv_separator,field_start,line_end);
	           
	                if field_end = -1 then
                        exit HEADER_SEARCH;
                    end if;
	           
	                if csv(field_start to field_end-1) = "FMC_ID" then
	                    FMC_ID := field_id;
	                elsif csv(field_start to field_end-1) = "IOB_TYPE" then
	                    IOB_TYPE := field_id;
                    elsif csv(field_start to field_end-1) = "IOB_INDEX" then
                        IOB_INDEX := field_id;
                    elsif csv(field_start to field_end-1) = "IOB_DIR" then
                        IOB_DIR := field_id;
                    elsif csv(field_start to field_end-1) = "IOB_SWAP" then
                        IOB_SWAP := field_id;
                    end if;

	                field_id := field_id + 1;
	            end loop;
	        else
	            
	            FIELD_SEARCH: loop
	                field_start := field_end + 1;
                    field_end := str_search_ch(csv,csv_separator,field_start,line_end);
                    if field_end = -1 then
                        exit FIELD_SEARCH;
                    end if;
                    if field_id = FMC_ID then
                       if csv(field_start to field_end-1) = "1" then
                         tmp_pin_map.fmc_id := 1;
                       elsif csv(field_start to field_end-1) = "2" then
                         tmp_pin_map.fmc_id := 1;
                       end if;
                        --tmp_pin_map.fmc_id := integer'value(csv(field_start to field_end-1));
                    elsif field_id = IOB_TYPE then
                        if csv(field_start to field_end-1) = "LA" then
                            tmp_pin_map.iob_type:=LA;
                        elsif csv(field_start to field_end-1) = "HA" then
                            tmp_pin_map.iob_type:=HA;
                        elsif csv(field_start to field_end-1) = "HB" then
                            tmp_pin_map.iob_type:=HB;
                        end if;
                     elsif field_id = IOB_INDEX then
                         tmp_pin_map.iob_index := str_to_int(csv(field_start to field_end-1));
                     elsif field_id = IOB_DIR then
                         if csv(field_start to field_end-1) = "DIRIN" then
                             tmp_pin_map.iob_dir:=DIRIN;
                         elsif csv(field_start to field_end-1) = "DIROUT" then
                             tmp_pin_map.iob_dir:=DIROUT;
                         elsif csv(field_start to field_end-1) = "DIRIO" then
                             tmp_pin_map.iob_dir:=DIRIO;
                         elsif csv(field_start to field_end-1) = "DIRNONE" then
                             tmp_pin_map.iob_dir:=DIRNONE;
                         end if;
                     elsif field_id = IOB_SWAP then
                         if csv(field_start to field_end-1) = "0" then
                             tmp_pin_map.iob_swap:='0';
                         elsif csv(field_start to field_end-1) = "1" then
                             tmp_pin_map.iob_swap:='1';
                         end if;
                                              
                     end if;
                     field_id := field_id + 1;
                end loop;
                fmc_pin_map_vector(line_id-1).fmc_id := tmp_pin_map.fmc_id;
                fmc_pin_map_vector(line_id-1).iob_type := tmp_pin_map.iob_type;
                fmc_pin_map_vector(line_id-1).iob_index := tmp_pin_map.iob_index;
                fmc_pin_map_vector(line_id-1).iob_dir := tmp_pin_map.iob_dir;
                fmc_pin_map_vector(line_id-1).iob_swap := tmp_pin_map.iob_swap;
                fmc_pin_map_vector(line_id-1).iob_pin := "x";
                fmc_pin_map_vector(line_id-1).iob_pinb := "x";
	        end if;
	    
	        line_id := line_id+1;
	    end loop;
	    return fmc_pin_map_vector(line_id-2 downto 0);
	end fmc_csv2pin_map_vector;
	
end fmc_carrier_helpers_pkg;
