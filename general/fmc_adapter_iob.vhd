-------------------------------------------------------------------------------
-- Title      : InOut port adapter
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : fmc_adapter_io.vhd
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2015-09-11
-- Last update: 2016-02-10
-- Platform   : FPGA-generics
-- Standard   : VHDL
-------------------------------------------------------------------------------
-- Description:
-- 
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2016 Piotr Miedzik
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.fmc_general_pkg.all;

entity fmc_adapter_iob is
	generic (
	g_connector: t_fmc_connector_type := FMC_LPC;
	g_use_jtag: boolean := false;
	g_use_system_i2c : boolean := false;
	g_use_inout: boolean:= true;
	g_fmc_id    : natural := 1;
	g_fmc_map   : t_fmc_pin_map_vector := c_fmc_pin_nullvector;
	g_fmc_idelay_map: t_iodelay_map_vector := c_iodelay_map_nullvector   
    );
  Port (
  	--- FMC phisical
  	port_fmc_io: inout t_fmc_signals_bidir; 
  	port_fmc_in_i : in t_fmc_signals_in;
  	port_fmc_out_o : out t_fmc_signals_out;
  	
  	-- FMC input path
  	fmc_in_o : out t_fmc_signals_in;
  	
  	-- FMC output path
  	fmc_out_i : in t_fmc_signals_out;
  	fmc_out_dir_i : in t_fmc_signals_out
    );
end fmc_adapter_iob;

architecture Behavioral of fmc_adapter_iob is

component fmc_pinpair_iob
  generic (
    g_swap : bit := '0';
    g_diff    : character := 'X';
  
    g_in_p : bit := '0' ;
    g_out_p   : bit := '0';
    g_in_n : bit := '0' ;
    g_out_n   : bit := '0';
    test_1   : boolean := false
  );
  Port ( 
    fmc_p_io: inout std_logic;
    fmc_n_io: inout std_logic;
        
    fmc_p_i: in std_logic := '0';
    fmc_n_i: in std_logic := '0';
		
    fmc_p_dir: in std_logic := '0';
    fmc_n_dir: in std_logic := '0';
                
    fmc_p_o :out std_logic;		  
    fmc_n_o :out std_logic
	);
	end component;
	
	
	component jtag_adapter_iob 
        generic(
            g_use_inout : boolean := true
        );
        Port(
            port_jtag_io : inout t_jtag_port;
            jtag_i       : in    t_jtag_port;
            jtag_dir     : in    t_jtag_port;
            jtag_o       : out   t_jtag_port
        );
    end component;
    
    type t_iob_tmp_type is record
       swap : bit;
       diff : character;
       in_p : bit;
       in_n : bit;
       out_p : bit;
       out_n : bit;
    end record t_iob_tmp_type;
    constant c_iob_tmp_default :t_iob_tmp_type := (swap => '0', diff => 'X', in_p => '0', in_n => '0', out_p => '0' , out_n => '0' );
    
    function get_iob_vector (constant tmp_idelay_p : in t_iodelay_map; constant tmp_idelay_n : in t_iodelay_map; constant tmp_idelay_diff : in t_iodelay_map)
    	return t_iob_tmp_type is
       variable tmp_result : t_iob_tmp_type := c_iob_tmp_default; 
   begin
   	
    	if (tmp_idelay_diff.dir_type /= DIRNONE ) then
    		tmp_result.diff := '1';
    		
    		 if tmp_idelay_diff.dir_type = DIRIN then
    			tmp_result.in_p := '1';
    			tmp_result.out_p := '0';
    		elsif tmp_idelay_diff.dir_type = DIROUT then
    			tmp_result.in_p := '0';
    			tmp_result.out_p := '1';
    		elsif tmp_idelay_diff.dir_type = DIRIO then
    			tmp_result.in_p := '1';
    			tmp_result.out_p := '1';
    		end if;
    		
    	elsif tmp_idelay_p.dir_type /= DIRNONE or tmp_idelay_n.dir_type /= DIRNONE then
    		tmp_result.diff := '0';
    		
    		if tmp_idelay_p.dir_type = DIRIN then
    			tmp_result.in_p := '1';
    			tmp_result.out_p := '0';
    		elsif tmp_idelay_p.dir_type = DIROUT then
    			tmp_result.in_p := '0';
    			tmp_result.out_p := '1';
    		elsif tmp_idelay_p.dir_type = DIRIO then
    			tmp_result.in_p := '1';
    			tmp_result.out_p := '1';
    		end if;
    		
    		if tmp_idelay_n.dir_type = DIRIN then
    			tmp_result.in_n := '1';
    			tmp_result.out_n := '0';
    		elsif tmp_idelay_n.dir_type = DIROUT then
    			tmp_result.in_n := '0';
    			tmp_result.out_n := '1';
    		elsif tmp_idelay_n.dir_type = DIRIO then
    			tmp_result.in_n := '1';
    			tmp_result.out_n := '1';
    		end if;
  
    	end if;
    	return tmp_result;
    end function get_iob_vector;
    
      function generate_loc(i: integer) return boolean is
      
      begin
        if i = 4 then
          return true;
        end if;
        return false;
      end function;  
      
     component test_iob_loc is
          Port ( 
              fmc_p_io: inout std_logic
          );
      end component;
      
begin
-- unidirectional ports
fmc_in_o.CLK_M2C_p <= port_fmc_in_i.CLK_M2C_p;
fmc_in_o.CLK_M2C_n <= port_fmc_in_i.CLK_M2C_n;
port_fmc_out_o.CLK_M2C_p <= fmc_out_i.CLK_M2C_p;
port_fmc_out_o.CLK_M2C_n <= fmc_out_i.CLK_M2C_n;

fmc_in_o.CLK_MGT_p <= port_fmc_in_i.CLK_MGT_p; 
fmc_in_o.CLK_MGT_n <= port_fmc_in_i.CLK_MGT_n;

-- FMC_LPC
fmc_in_o.DP_p(0) <= port_fmc_in_i.DP_p(0);
fmc_in_o.DP_n(0) <= port_fmc_in_i.DP_n(0);
port_fmc_out_o.DP_p(0) <= fmc_out_i.DP_p(0);
port_fmc_out_o.DP_n(0) <= fmc_out_i.DP_n(0);

GEN_DP_HPC : if g_connector = FMC_HPC or g_connector = FMC_PLUS generate
fmc_in_o.DP_p(9 downto 1) <= port_fmc_in_i.DP_p(9 downto 1);
fmc_in_o.DP_n(9 downto 1) <= port_fmc_in_i.DP_n(9 downto 1);
port_fmc_out_o.DP_p(9 downto 1) <= fmc_out_i.DP_p(9 downto 1);
port_fmc_out_o.DP_n(9 downto 1) <= fmc_out_i.DP_n(9 downto 1);

-- bidirection @todo clkbidir
fmc_in_o.CLK_BIDIR_p <= port_fmc_io.CLK_BIDIR_p;
fmc_in_o.CLK_BIDIR_n <= port_fmc_io.CLK_BIDIR_n;
fmc_in_o.CLK_DIR <= port_fmc_io.CLK_DIR;


end generate GEN_DP_HPC;

-- MISC
fmc_in_o.prsnt_m2c_l <= port_fmc_in_i.prsnt_m2c_l; 
fmc_in_o.pg_c2m <= port_fmc_in_i.pg_c2m;
fmc_in_o.pg_m2c <= port_fmc_in_i.pg_m2c;


-- @ todo add single differentials
      
      
GEN_FMC_LA : for i in port_fmc_io.LA_p'range generate
		constant tmp_map         : t_fmc_pin_map := fmc_pin_map_extract_fmc_pin(fmc_id => g_fmc_id, pin_type => LA, pin_index => i, fmc_pin_map => g_fmc_map);
		constant tmp_idelay_p    : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => LA, pin_index => i, pin_diff => POS, iodelay_map => g_fmc_idelay_map);
		constant tmp_idelay_n    : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => LA, pin_index => i, pin_diff => NEG, iodelay_map => g_fmc_idelay_map);
		constant tmp_idelay_diff : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => LA, pin_index => i, pin_diff => DIFF, iodelay_map => g_fmc_idelay_map);
		
		constant tmp : t_iob_tmp_type := get_iob_vector( tmp_idelay_p => tmp_idelay_p, tmp_idelay_n => tmp_idelay_n, tmp_idelay_diff => tmp_idelay_diff );
		

begin
     
     
   
   u_pinpair_iob_LAx: fmc_pinpair_iob 
    generic map (
      g_swap  => tmp_map.iob_swap,
      g_diff => tmp.diff,
      g_in_p => tmp.in_p,
      g_in_n => tmp.in_n,
      g_out_p => tmp.out_p,
      g_out_n => tmp.out_n
       )
    Port map ( 
      fmc_p_io => port_fmc_io.LA_p(I),
      fmc_n_io => port_fmc_io.LA_n(I),

      fmc_p_i => fmc_out_i.LA_p(I),
      fmc_n_i => fmc_out_i.LA_n(I),            
      fmc_p_o => fmc_in_o.LA_p(I),
      fmc_n_o => fmc_in_o.LA_n(I),
      fmc_p_dir => fmc_out_dir_i.LA_p(I),
      fmc_n_dir => fmc_out_dir_i.LA_n(I)
      );
end generate;

GEN_FMC_HPC : if g_connector = FMC_HPC or g_connector = FMC_PLUS generate
GEN_FMC_HA : for i in port_fmc_io.HA_p'range generate

		constant tmp_map         : t_fmc_pin_map := fmc_pin_map_extract_fmc_pin(fmc_id => g_fmc_id, pin_type => HA, pin_index => i, fmc_pin_map => g_fmc_map);
		constant tmp_idelay_p    : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => HA, pin_index => i, pin_diff => POS, iodelay_map => g_fmc_idelay_map);
		constant tmp_idelay_n    : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => HA, pin_index => i, pin_diff => NEG, iodelay_map => g_fmc_idelay_map);
		constant tmp_idelay_diff : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => HA, pin_index => i, pin_diff => DIFF, iodelay_map => g_fmc_idelay_map);
		
		constant tmp : t_iob_tmp_type := get_iob_vector( tmp_idelay_p => tmp_idelay_p, tmp_idelay_n => tmp_idelay_n, tmp_idelay_diff => tmp_idelay_diff );
begin

   u_pinpair_iob_HAx: fmc_pinpair_iob 
    generic map (
      g_swap  => tmp_map.iob_swap,
      g_diff => tmp.diff,
      g_in_p => tmp.in_p,
      g_in_n => tmp.in_n,
      g_out_p => tmp.out_p,
      g_out_n => tmp.out_n
      )
    Port map ( 
      fmc_p_io => port_fmc_io.HA_p(I),
      fmc_n_io => port_fmc_io.HA_n(I),

      fmc_p_i => fmc_out_i.HA_p(I),
      fmc_n_i => fmc_out_i.HA_n(I),            
      fmc_p_o => fmc_in_o.HA_p(I),
      fmc_n_o => fmc_in_o.HA_n(I),
      fmc_p_dir => fmc_out_dir_i.HA_p(I),
      fmc_n_dir => fmc_out_dir_i.HA_n(I)
      );
      
end generate;

GEN_FMC_HB : for i in port_fmc_io.HB_p'range generate

		constant tmp_map         : t_fmc_pin_map := fmc_pin_map_extract_fmc_pin(fmc_id => g_fmc_id, pin_type => HB, pin_index => i, fmc_pin_map => g_fmc_map);
		constant tmp_idelay_p    : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => HB, pin_index => i, pin_diff => POS, iodelay_map => g_fmc_idelay_map);
		constant tmp_idelay_n    : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => HB, pin_index => i, pin_diff => NEG, iodelay_map => g_fmc_idelay_map);
		constant tmp_idelay_diff : t_iodelay_map := fmc_iodelay_extract_fmc_pin(pin_type => HB, pin_index => i, pin_diff => DIFF, iodelay_map => g_fmc_idelay_map);
		
		constant tmp : t_iob_tmp_type := get_iob_vector( tmp_idelay_p => tmp_idelay_p, tmp_idelay_n => tmp_idelay_n, tmp_idelay_diff => tmp_idelay_diff );
begin

   u_pinpair_iob_HBx: fmc_pinpair_iob 
    generic map (
      g_swap  => tmp_map.iob_swap,
      g_diff => tmp.diff,
      g_in_p => tmp.in_p,
      g_in_n => tmp.in_n,
      g_out_p => tmp.out_p,
      g_out_n => tmp.out_n
      )
    Port map ( 
      fmc_p_io => port_fmc_io.HB_p(I),
      fmc_n_io => port_fmc_io.HB_n(I),

      fmc_p_i => fmc_out_i.HB_p(I),
      fmc_n_i => fmc_out_i.HB_n(I),            
      fmc_p_o => fmc_in_o.HB_p(I),
      fmc_n_o => fmc_in_o.HB_n(I),
      fmc_p_dir => fmc_out_dir_i.HB_p(I),
      fmc_n_dir => fmc_out_dir_i.HB_n(I)
      );
end generate;
end generate GEN_FMC_HPC;
-- FMC i2c


GEN_I2C: if g_use_system_i2c = true generate
u_pinpair_iob_I2Cx: fmc_pinpair_iob 
    generic map (
      g_swap  => '0',
      g_diff => '0',
      g_in_p => '1',
      g_in_n => '1',
      g_out_p => '1',
      g_out_n => '1'
      )
    Port map ( 
      fmc_p_io => port_fmc_io.scl,
      fmc_n_io => port_fmc_io.sda,

      fmc_p_i => fmc_out_i.scl,
      fmc_n_i => fmc_out_i.sda,            
      fmc_p_o => fmc_in_o.scl,
      fmc_n_o => fmc_in_o.sda,
      fmc_p_dir => fmc_out_dir_i.scl,
      fmc_n_dir => fmc_out_dir_i.sda
      );
end generate;

GEN_JTAG: if g_use_jtag= true generate
 cmp_jtag: jtag_adapter_iob
	generic map(
		g_use_inout => true
	)
	port map(
		port_jtag_io => port_fmc_io.jtag,
		jtag_i       => fmc_out_i.jtag,
		jtag_dir     => fmc_out_dir_i.jtag,
		jtag_o       => fmc_in_o.jtag
	);
end generate GEN_JTAG;

end Behavioral;
