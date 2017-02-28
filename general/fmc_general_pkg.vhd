------------------------------------------------------------------------------
-- Title      : FMC general package
------------------------------------------------------------------------------
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2016-02-10
-- Platform   : FPGA-generic
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2012 GSI
-- Licensed under GNU Lesser General Public License (LGPL) v3.0
-------------------------------------------------------------------------------

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

package fmc_general_pkg is

	constant c_fmc_LA_pin_count : natural := 34;
	constant c_fmc_HA_pin_count : natural := 24;
	constant c_fmc_HB_pin_count : natural := 22;

	--  type t_diff_port is record
	--    p : std_logic;
	--    n : std_logic;
	--  end record t_diff_port;

	--  type t_diff_port_array is array(natural range <>) of t_diff_port; 
	type t_fmc_pin_type is (LA, HA, HB);
	type t_fmc_iob_type is (DIFF, POS, NEG);
	type t_fmc_dir_type is (DIRIN, DIROUT, DIRIO, DIRNONE);
	type t_fmc_connector_type is (FMC_LPC, FMC_HPC, FMC_PLUS);
	type t_fmc_group_offsets is array (natural range <>) of natural;
	type t_character_array is array (natural range <>) of character;

	type t_fmc_idelay_out is record
		cntvalueout : std_logic_vector(4 downto 0);
		ctl_rdy     : std_logic;
	end record;

	type t_fmc_idelay_in is record
		--c          : std_logic;
		ld         : std_logic;
		ce         : std_logic;
		inc        : std_logic;
		cntvaluein : std_logic_vector(4 downto 0);
		clk_sel    : std_logic;
		data_sel   : std_logic_vector(15 downto 0);
		ctl_reset  : std_logic;
	end record;

	type t_fmc_idelay_out_array is array (natural range <>) of t_fmc_idelay_out;
	type t_fmc_idelay_in_array is array (natural range <>) of t_fmc_idelay_in;

	type t_jtag_port is record
		TCK    : std_logic;
		TDI    : std_logic;
		TDO    : std_logic;
		TMS    : std_logic;
		TRST_L : std_logic;
	end record t_jtag_port;

	--  type t_fmc_signals is record
	--    -- misc    
	--    ga0         : std_logic;
	--    ga1         : std_logic;
	--    scl         : std_logic;
	--    sda         : std_logic;      
	--    pg_c2m      : std_logic;
	--    pg_m2c      : std_logic;
	--    prsnt_m2c_l : std_logic;
	--  
	--  
	--    -- LPC ports
	--    LA : t_diff_port_array(33 downto 0);
	--    
	--    -- HPC ports
	--    HA : t_diff_port_array(33 downto 0);
	--    HB : t_diff_port_array(21 downto 0);
	--  
	--    -- FMC CLocks
	--    CLK_DIR : std_logic;
	--    CLK_M2C  : t_diff_port_array(1 downto 0);
	--    CLK_BIDIR: t_diff_port_array(1 downto 0);
	--    
	--
	--    -- MGT
	--    CLK_MGT: t_diff_port_array(1 downto 0);
	--    DP : t_diff_port_array(9 downto 0);
	--
	--    -- todo: jtaq    
	--    jtag : t_jtag_port;
	--  end record t_fmc_signals;

	type t_fmc_signals_in is record
		-- misc    
		ga0         : std_logic;
		ga1         : std_logic;
		scl         : std_logic;
		sda         : std_logic;
		pg_c2m      : std_logic;
		pg_m2c      : std_logic;
		prsnt_m2c_l : std_logic;

		-- LPC ports
		LA_p : std_logic_vector(c_fmc_LA_pin_count-1 downto 0);
		LA_n : std_logic_vector(c_fmc_LA_pin_count-1 downto 0);

		-- HPC ports
		HA_p : std_logic_vector(c_fmc_HA_pin_count-1 downto 0);
		HA_n : std_logic_vector(c_fmc_HA_pin_count-1 downto 0);
		HB_p : std_logic_vector(c_fmc_HB_pin_count-1 downto 0);
		HB_n : std_logic_vector(c_fmc_HB_pin_count-1 downto 0);

		-- FMC CLocks
		CLK_DIR     : std_logic;
		CLK_M2C_p   : std_logic_vector(1 downto 0);
		CLK_M2C_n   : std_logic_vector(1 downto 0);
		CLK_BIDIR_p : std_logic_vector(1 downto 0);
		CLK_BIDIR_n : std_logic_vector(1 downto 0);

		-- MGT
		CLK_MGT_p : std_logic_vector(1 downto 0);
		CLK_MGT_n : std_logic_vector(1 downto 0);
		DP_p      : std_logic_vector(9 downto 0);
		DP_n      : std_logic_vector(9 downto 0);

		-- todo: jtaq    
		jtag : t_jtag_port;
	end record t_fmc_signals_in;

	subtype t_fmc_signals_out is t_fmc_signals_in;
	subtype t_fmc_signals_bidir is t_fmc_signals_in;



	subtype t_pin_index is integer range -1 to Integer'high;

	type t_iodelay_map is record
	    dir_type : t_fmc_dir_type;
		group_id  : integer;
		index     : t_pin_index;
		iob_type  : t_fmc_pin_type;
		iob_index : t_pin_index;
		iob_diff  : t_fmc_iob_type;
		iob_ddr   : bit; 
		iob_delay : bit;
	end record t_iodelay_map;

	type t_boardpin_map is record
		iob_type  : t_fmc_pin_type;
		iob_index : t_pin_index;
		iob_dir   : t_fmc_dir_type;
		iob_swap  : bit;
		iob_pin   : string(1 to 4);
		iob_pinb  : string(1 to 4);
	end record t_boardpin_map;
	
	type t_fmc_pin_map is record
		fmc_id    : integer;
		iob_type  : t_fmc_pin_type;
		iob_index : t_pin_index;
		iob_dir   : t_fmc_dir_type;
		iob_swap  : bit;
		iob_pin   : string(1 to 4);
		iob_pinb  : string(1 to 4);
	end record t_fmc_pin_map;

	constant pin_unknown: string(1 to 4) := "xxxx";
	
	type t_boardpin_map_vector is array (natural range <>) of t_boardpin_map;
	type t_iodelay_map_vector is array (natural range <>) of t_iodelay_map;
	type t_fmc_pin_map_vector is array (natural range <>) of t_fmc_pin_map;

	constant c_iodelay_map_empty : t_iodelay_map := (
		dir_type => DIRNONE,
		group_id  => -1,
		index     => 0,
		iob_type  => LA,
		iob_index => 5,
		iob_diff  => DIFF,
		iob_ddr => '0',
		iob_delay => '0'
	);

	constant c_iodelay_map_empty1 : t_iodelay_map := (
		dir_type => DIRNONE,
		group_id  => 0,
		index     => 0,
		iob_type  => LA,
		iob_index => 5,
		iob_diff  => DIFF,
		iob_ddr => '0',
		iob_delay => '0'
	);
	constant c_iodelay_map_empty2 : t_iodelay_map := (
		dir_type => DIRNONE,
		group_id  => 1,
		index     => 1,
		iob_type  => HB,
		iob_index => 4,
		iob_diff  => DIFF,
		iob_ddr => '0',
		iob_delay => '0'
	);
	constant c_iodelay_map_empty3 : t_iodelay_map := (
		dir_type => DIRNONE,
		group_id  => 0,
		index     => 16,
		iob_type  => HA,
		iob_index => 4,
		iob_diff  => DIFF,
		iob_ddr => '0',
		iob_delay => '0'
	);
	
	
	constant c_boardpin_empty : t_boardpin_map := (
		iob_type  => LA,
		iob_index => -1,
		iob_dir   => DIRIO,
		iob_swap  => '0',
		iob_pin   => pin_unknown,
		iob_pinb  => pin_unknown
	);
	
	constant c_fmc_pin_empty : t_fmc_pin_map := (
		fmc_id => -1,
		iob_type  => LA,
		iob_index => -1,
		iob_dir   => DIRIO,
		iob_swap  => '0',
		iob_pin   => pin_unknown,
		iob_pinb  => pin_unknown
	);
	constant c_iodelay_map_nullvector : t_iodelay_map_vector(0 downto 0) := (0 => c_iodelay_map_empty);
	constant c_fmc_pin_nullvector : t_fmc_pin_map_vector(0 downto 0) := (0 => c_fmc_pin_empty);


    function fmc_get_group_offsets(constant iodelay_map : in t_iodelay_map_vector; constant count_per_group: natural) return t_fmc_group_offsets;
	function fmc_iodelay_group_count(constant iodelay_map : in t_iodelay_map_vector) return natural;
	function fmc_iodelay_len_by_group(constant group_id : in natural; constant iodelay_map : in t_iodelay_map_vector) return natural;
	function fmc_iodelay_len_by_type(constant pin_type : in t_fmc_pin_type; constant iodelay_map : in t_iodelay_map_vector) return natural;
	function fmc_iodelay_extract_group(constant group_id : in natural; constant iodelay_map : in t_iodelay_map_vector) return t_iodelay_map_vector;
	function fmc_extract_by_direction(constant dir_type: in t_fmc_dir_type;  constant idelay_map : in t_iodelay_map_vector) return t_iodelay_map_vector;	
	function fmc_iodelay_extract_type(constant pin_type : in t_fmc_pin_type; constant iodelay_map : in t_iodelay_map_vector) return t_iodelay_map_vector;
		
		
	function fmc_boardpin_map_to_bitvector(constant pin_type: in t_fmc_pin_type; constant boardpin_map: in t_boardpin_map_vector) return bit_vector;
	function fmc_pin_map_to_inv_vector(constant fmc_id: in integer; constant pin_type : in t_fmc_pin_type; constant fmc_pin_map : in t_fmc_pin_map_vector) return bit_vector;
		
	function fmc_iodelay_extract_fmc_pin(
		constant pin_type : in t_fmc_pin_type; 
		constant pin_index : in t_pin_index;
		constant pin_diff : in t_fmc_iob_type;
		constant iodelay_map : in t_iodelay_map_vector
	) return t_iodelay_map;

	function fmc_pin_map_extract_fmc_pin(constant fmc_id: in integer; constant pin_type : in t_fmc_pin_type; constant pin_index:in integer; constant fmc_pin_map : in t_fmc_pin_map_vector) return t_fmc_pin_map;
	
	function fmc_use_iodelay_vector(constant fmc_pin_index : in integer; constant fmc_pin_type : in t_fmc_pin_type; constant iodelay_map : in t_iodelay_map_vector) return boolean;


	function fmc_pin_type_to_str(fmc_pin_type: t_fmc_pin_type) return string;
	function fmc_dir_type_to_str(fmc_dir_type: t_fmc_dir_type) return string;


	
	
	constant C_FMC_DIR_OUT : std_logic := '0';
	constant C_FMC_DIR_IN  : std_logic := '1';
	
   component fmc_adapter_iob
   	generic(g_connector      : t_fmc_connector_type := FMC_PLUS;
   		    g_use_jtag       : boolean              := false;
   		    g_use_inout      : boolean              := true;
   		    g_fmc_id         : natural              := 1;
   		    g_fmc_map        : t_fmc_pin_map_vector := c_fmc_pin_nullvector;
   		    g_fmc_idelay_map : t_iodelay_map_vector := c_iodelay_map_nullvector);
   	port(port_fmc_io    : inout t_fmc_signals_bidir;
   		 port_fmc_in_i  : in    t_fmc_signals_in;
   		 port_fmc_out_o : out   t_fmc_signals_out;
   		 fmc_in_o       : out   t_fmc_signals_in;
   		 fmc_out_i      : in    t_fmc_signals_out;
   		 fmc_out_dir_i  : in    t_fmc_signals_out);
   end component fmc_adapter_iob;
   
   component fmc_adapter_idelay
   	generic(g_idelay_map : t_iodelay_map_vector := c_iodelay_map_nullvector);
   	port(fmc_in     : in  t_fmc_signals_in;
   		 fmc_out    : out t_fmc_signals_in;
   		 
   		 refclk_i          : in std_logic;
   		 
   		 idelay_ctrl_clk_i : in  std_logic_vector(fmc_iodelay_group_count(g_idelay_map) - 1 downto 0);
   		 idelay_ctrl_in_i  : in  t_fmc_idelay_in_array(fmc_iodelay_group_count(g_idelay_map) - 1 downto 0);
   		 idelay_ctrl_out_o : out t_fmc_idelay_out_array(fmc_iodelay_group_count(g_idelay_map) - 1 downto 0));
   end component fmc_adapter_idelay;

	component fmc_adapter
		generic(
			g_pin_count : natural                        := 34;
			g_diff      : std_logic_vector(200 downto 0) := (others => 'X');
			g_fmc_inv   : std_logic_vector(200 downto 0) := (others => '0');
			g_dir_out   : bit                            := '0'
		);
		Port(
			fmc_p_i : in  std_logic_vector(g_pin_count - 1 downto 0) := (others => '0');
			fmc_n_i : in  std_logic_vector(g_pin_count - 1 downto 0) := (others => '1');

			fmc_p_o : out std_logic_vector(g_pin_count - 1 downto 0);
			fmc_n_o : out std_logic_vector(g_pin_count - 1 downto 0)
		);
	end component;

	component fmc_adapter_io
		generic(
			g_pin_count : natural                        := 2;
			g_swap      : bit_vector(63 downto 0)        := (others => '0');
			g_diff      : t_character_array(63 downto 0) := (others => 'X');
			g_out_p     : bit_vector(63 downto 0)        := (others => '0');
			g_inout_p   : bit_vector(63 downto 0)        := (others => '0');
			g_out_n     : bit_vector(63 downto 0)        := (others => '0');
			g_inout_n   : bit_vector(63 downto 0)        := (others => '0')
		);
		Port(
			port_io_p  : inout STD_LOGIC_VECTOR(g_pin_count - 1 downto 0);
			port_io_n  : inout STD_LOGIC_VECTOR(g_pin_count - 1 downto 0);

			output_i_p : in    STD_LOGIC_VECTOR(g_pin_count - 1 downto 0);
			output_i_n : in    STD_LOGIC_VECTOR(g_pin_count - 1 downto 0);
			dir_i_p    : in    STD_LOGIC_VECTOR(g_pin_count - 1 downto 0) := (others => '0');
			dir_i_n    : in    STD_LOGIC_VECTOR(g_pin_count - 1 downto 0) := (others => '0');
			input_o_p  : out   STD_LOGIC_VECTOR(g_pin_count - 1 downto 0) := (others => '0');
			input_o_n  : out   STD_LOGIC_VECTOR(g_pin_count - 1 downto 0) := (others => '0')
		);
	end component;
	
	
	component fmc_adapter_iddr
		generic(g_fmc_id         : natural              := 1;
			    g_fmc_map        : t_fmc_pin_map_vector := c_fmc_pin_nullvector;
			    g_fmc_idelay_map : t_iodelay_map_vector := c_iodelay_map_nullvector);
		port(fmc_in     : in  t_fmc_signals_in;
			 fmc_out_q1 : out t_fmc_signals_in;
			 
			 ddr_clk    : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0);
             q1         : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) * 8 - 1 downto 0);
             q2         : out std_logic_vector(fmc_iodelay_group_count(g_fmc_idelay_map) * 8 - 1 downto 0)
          );
	end component fmc_adapter_iddr;

  	component idelay_general
  		generic(g_use_iob : boolean := true;
  			    g_is_clk  : boolean := false;
  			    g_index   : natural := 0);
  		port(idata_in      : in  std_logic;
  			 idata_out     : out std_logic;
  			 idelay_clk_i  : in  std_logic;
  			 idelay_ctrl_i : in  t_fmc_idelay_in;
  			 idelay_ctrl_o : out t_fmc_idelay_out);
  	end component idelay_general;

   component fmc_adapter_extractor
   	generic(
            g_count_per_group: natural              := 8;
            g_fmc_id         : natural              := 1;
   		    g_fmc_connector  : t_fmc_connector_type := FMC_HPC;
   		    g_fmc_map        : t_fmc_pin_map_vector := c_fmc_pin_nullvector;
   		    g_fmc_idelay_map : t_iodelay_map_vector := c_iodelay_map_nullvector
    );
   	port(fmc_in_i     : in  t_fmc_signals_in;
   		 fmc_in_o     : out t_fmc_signals_in;
   		 fmc_groups_o : out std_logic_vector(g_count_per_group * fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0));
   end component fmc_adapter_extractor;
   
   
   component fmc_adapter_injector
   	generic(
            g_count_per_group: natural              := 8;
            g_fmc_id         : natural              := 1;
   		    g_fmc_connector  : t_fmc_connector_type := FMC_HPC;
   		    g_fmc_map        : t_fmc_pin_map_vector := c_fmc_pin_nullvector;
   		    g_fmc_idelay_map : t_iodelay_map_vector := c_iodelay_map_nullvector
    );
   	port(fmc_out_i    : in  t_fmc_signals_out;
   		 fmc_dir_i    : in  t_fmc_signals_out;
   		 fmc_out_o    : out t_fmc_signals_out;
   		 groups_i     : in  std_logic_vector(g_count_per_group * fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0);
   		 groups_dir_i : in  std_logic_vector(g_count_per_group * fmc_iodelay_group_count(g_fmc_idelay_map) - 1 downto 0));
   end component fmc_adapter_injector;

end package fmc_general_pkg;

package body fmc_general_pkg is
	function fmc_use_iodelay_vector(constant fmc_pin_index : in integer; constant fmc_pin_type : in t_fmc_pin_type; constant iodelay_map : in t_iodelay_map_vector) return boolean is
	begin
		for i in iodelay_map'range loop
			report "The value of 'a' is " & integer'image(i) severity warning;
			if fmc_pin_type = iodelay_map(i).iob_type then --and iob_index = iodelay_map(i).iob_index then
				if fmc_pin_index = iodelay_map(i).iob_index then
					return true;
				end if;
			end if;
		end loop;
		return false;
	end fmc_use_iodelay_vector;

	function fmc_iodelay_group_count(constant iodelay_map : in t_iodelay_map_vector) return natural is
		variable group_id_max : integer;
	begin
		group_id_max := -1;
		for i in iodelay_map'range loop
			if iodelay_map(i).group_id >= 0 and iodelay_map(i).group_id > group_id_max then
				group_id_max := iodelay_map(i).group_id;
			end if;
		end loop;
		return group_id_max + 1;
	end fmc_iodelay_group_count;

	function fmc_iodelay_len_by_group(constant group_id : in natural; constant iodelay_map : in t_iodelay_map_vector) return natural is
		variable idelay_count : natural;
	begin
		idelay_count := 0;
		for i in iodelay_map'range loop
			if iodelay_map(i).group_id = group_id then
				idelay_count := idelay_count + 1;
			end if;
		end loop;
		return idelay_count;
	end fmc_iodelay_len_by_group;

	function fmc_iodelay_len_by_type(constant pin_type : in t_fmc_pin_type; constant iodelay_map : in t_iodelay_map_vector) return natural is
		variable idelay_count : natural;
	begin
		idelay_count := 0;
		for i in iodelay_map'range loop
			if iodelay_map(i).iob_type = pin_type then
				idelay_count := idelay_count + 1;
			end if;
		end loop;
		return idelay_count;
	end fmc_iodelay_len_by_type;

	function fmc_iodelay_extract_type(constant pin_type : in t_fmc_pin_type; constant iodelay_map : in t_iodelay_map_vector) return t_iodelay_map_vector is
		variable tmp_idelay_map : t_iodelay_map_vector(fmc_iodelay_len_by_type(pin_type => pin_type, iodelay_map => iodelay_map) - 1 downto 0);
		variable idelay_count   : natural;
	begin
		idelay_count := 0;
		for i in iodelay_map'range loop
			if iodelay_map(i).iob_type = pin_type then
				tmp_idelay_map(idelay_count) := iodelay_map(i);
				idelay_count                 := idelay_count + 1;
			end if;
		end loop;
		return tmp_idelay_map;
	end fmc_iodelay_extract_type;

	function fmc_iodelay_extract_group(constant group_id : in natural; constant iodelay_map : in t_iodelay_map_vector) return t_iodelay_map_vector is
		variable tmp_idelay_map : t_iodelay_map_vector(fmc_iodelay_len_by_group(group_id => group_id, iodelay_map => iodelay_map) - 1 downto 0);
		variable j              : natural;
	begin
		j := 0;
		for i in iodelay_map'range loop
			if iodelay_map(i).group_id = group_id then
				tmp_idelay_map(j) := iodelay_map(i);
				j                 := j + 1;
			end if;

		end loop;
		return tmp_idelay_map;
	end fmc_iodelay_extract_group;
	
	function fmc_iodelay_extract_fmc_pin(
		constant pin_type : in t_fmc_pin_type; 
		constant pin_index : in t_pin_index;
		constant pin_diff : in t_fmc_iob_type;
		constant iodelay_map : in t_iodelay_map_vector
	) return t_iodelay_map is
	
	begin
		for i in iodelay_map'range loop
			if 	iodelay_map(i).iob_index = pin_index and 
			    iodelay_map(i).iob_type = pin_type and
			    iodelay_map(i).iob_diff = pin_diff then
				return iodelay_map(i);
			end if;
		end loop;
		return c_iodelay_map_empty;
	end fmc_iodelay_extract_fmc_pin;
		
	function fmc_group_pin_count(constant pin_type: in t_fmc_pin_type) return natural is
		variable pin_count : natural := 0;
	begin
		case pin_type is
		when LA => pin_count := c_fmc_LA_pin_count;
		when HA => pin_count := c_fmc_HA_pin_count;
		when HB => pin_count := c_fmc_HB_pin_count;
			
		when others => null;
		end case;
		return pin_count;
		
--		if pin_type = LA then
--			pin_count := c_fmc_LA_pin_count;
--		elsif pin_type = HA then
--			pin_count := c_fmc_HA_pin_count;
--		elsif 
	end fmc_group_pin_count;

	function fmc_pin_map_to_inv_vector(constant fmc_id: in integer; constant pin_type : in t_fmc_pin_type; constant fmc_pin_map : in t_fmc_pin_map_vector) return bit_vector is
		variable tmp_swap_vector : bit_vector(fmc_group_pin_count(pin_type => pin_type) - 1 downto 0) := (others => '0');
		begin
		for i in fmc_pin_map'range loop
			if  fmc_pin_map(i).iob_type = pin_type and fmc_pin_map(i).fmc_id = fmc_id then
				tmp_swap_vector(fmc_pin_map(i).iob_index) := fmc_pin_map(i).iob_swap;
			end if;
		end loop;
		return tmp_swap_vector;
	end fmc_pin_map_to_inv_vector;
	
	
		
	function fmc_pin_map_extract_fmc_pin(constant fmc_id: in integer; constant pin_type : in t_fmc_pin_type; constant pin_index:in integer; constant fmc_pin_map : in t_fmc_pin_map_vector) return t_fmc_pin_map is
		begin
		for i in fmc_pin_map'range loop
			if fmc_pin_map(i).iob_type = pin_type and fmc_pin_map(i).fmc_id = fmc_id and fmc_pin_map(i).iob_index = pin_index then
				return fmc_pin_map(i);
			end if;
		end loop;
		return c_fmc_pin_empty;
	end fmc_pin_map_extract_fmc_pin;

	function fmc_boardpin_map_to_bitvector(constant pin_type : in t_fmc_pin_type; constant boardpin_map : in t_boardpin_map_vector) return bit_vector is
		variable tmp_swap_vector : bit_vector(fmc_group_pin_count(pin_type => pin_type) - 1 downto 0) := (others => '0');
		begin
		for i in boardpin_map'range loop
			if boardpin_map(i).iob_type = pin_type then
				tmp_swap_vector(boardpin_map(i).iob_index) := boardpin_map(i).iob_swap;
			end if;
		end loop;
		return tmp_swap_vector;
	end fmc_boardpin_map_to_bitvector;
	
	
	function fmc_extract_by_direction(constant dir_type: in t_fmc_dir_type;  constant idelay_map : in t_iodelay_map_vector) return t_iodelay_map_vector is
		variable new_idelay_map:t_iodelay_map_vector(idelay_map'range);
		variable count: natural := 0; 
		begin
		for i in idelay_map'range loop
			if idelay_map(i).dir_type = dir_type or idelay_map(i).dir_type = DIRIO then
				new_idelay_map(count) := idelay_map(i);
				--new_idelay_map(count).dir_type := dir_type;
				count := count + 1;
			end if;
		end loop;
		if count = 0 then
			new_idelay_map(count) := c_iodelay_map_empty;
			count := count +1;
		end if;
		return new_idelay_map(count-1 downto 0);
	end fmc_extract_by_direction;

--	function fmc_boardpin_map_to_bitvector(constant pin_type : in t_fmc_pin_type; constant boardpin_map : in t_boardpin_map_vector) return bit_vector is
--		variable tmp_swap_vector : bit_vector(fmc_group_pin_count(pin_type => pin_type) - 1 downto 0) := (others => '0');
--		begin
--		for i in boardpin_map'range loop
--			if boardpin_map(i).iob_type = pin_type then
--				tmp_swap_vector(boardpin_map(i).iob_index) := boardpin_map(i).iob_swap;
--			end if;
--		end loop;
--		return tmp_swap_vector;
--	end fmc_boardpin_map_to_bitvector;
	

    
    function fmc_get_group_offsets(constant iodelay_map : in t_iodelay_map_vector; constant count_per_group: natural) return t_fmc_group_offsets is
      variable groups : natural := fmc_iodelay_group_count(iodelay_map);
      variable offsets : t_fmc_group_offsets(groups-1 downto 0) := (others => -1 );
    begin
      for i in offsets'range loop
        offsets(i) := i*count_per_group ;
      end loop;
      return offsets;
    end function;

    
    

	
	function fmc_pin_type_to_str(fmc_pin_type: t_fmc_pin_type) return string is
	begin
	  if fmc_pin_type = LA then return "LA"; 
	  elsif fmc_pin_type = HA then return "HA";
	  elsif fmc_pin_type = HB then return "HB";
	  else return "UNKNOWN";
	  end if;
	end function;
	
	function fmc_dir_type_to_str(fmc_dir_type: t_fmc_dir_type) return string is
	begin
	  if    fmc_dir_type = DIRIN   then return "DIRIN"; 
      elsif fmc_dir_type = DIROUT  then return "DIROUT";
      elsif fmc_dir_type = DIRIO   then return "DIRIO";
      elsif fmc_dir_type = DIRNONE then return "DIRNONE";
      else return "UNKNOWN";
      end if;
	end function;
	
end fmc_general_pkg;
