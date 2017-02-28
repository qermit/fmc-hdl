-------------------------------------------------------------------------------
-- Title      : FMC DIO 5ch TTL a HDL module
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : fmc_dio5chttl.vhd
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2015-09-11
-- Last update: 2016-02-10
-- Platform   : FPGA-generics
-- Standard   : VHDL
-------------------------------------------------------------------------------
-- Description:
-- fmc_dio5chttl integrates I2C Master, 1-Wire Master and GPIO-RAW
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2016 Piotr Miedzik
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.fmc_general_pkg.all;
use work.wishbone_pkg.all;

use work.fmc_emptyboard_pkg.all;
use work.fmc_helper_pkg.all;


entity fmc_emptyboard is

  generic (
  	g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
    g_address_granularity    : t_wishbone_address_granularity := WORD;
  
    g_use_tristate           : boolean := true;
    g_enable_fmc_eeprom      : boolean := true;
    g_fmc_id              : natural                        := 1;
	g_fmc_map             : t_fmc_pin_map_vector           := c_fmc_pin_nullvector
    );

  Port (
    --== Standard clk and reset ==--
    clk_i        : in std_logic;
	rst_n_i      : in std_logic;
	
	--== Wishbone ==--	
	slave_i       : in  t_wishbone_slave_in;
    slave_o       : out t_wishbone_slave_out;

	--== FMC abstraction layer ==--
	port_fmc_in_i: in t_fmc_signals_in;
    port_fmc_out_o: out t_fmc_signals_out;
    port_fmc_io: inout t_fmc_signals_bidir
    );

end fmc_emptyboard;

architecture Behavioral of fmc_emptyboard is

  --== FMC abstraction layer ==--
  constant c_iodelaymap : t_iodelay_map_vector(fmc_emptyboard_pin_map'range) := fmc_emptyboard_pin_map;
  constant c_test_bool :boolean := write_xdc("fmc"& integer'image(g_fmc_id) &"_loc.xdc", g_fmc_id , g_fmc_map, c_iodelaymap);
  
  signal s_fmc_in1: t_fmc_signals_in;
  signal s_fmc_out1: t_fmc_signals_out;
  signal s_fmc_dir1: t_fmc_signals_out;  

  --== Wishbone ==--
  constant c_slave_interface_mode : t_wishbone_interface_mode := PIPELINED;
  signal wb_s2m : t_wishbone_slave_out;
  signal wb_m2s : t_wishbone_slave_in;

  
begin

 cmp_fmc_adapter_iob: fmc_adapter_iob
 	generic map(
 		g_connector      => FMC_HPC,
 		g_use_jtag       => false,
 		g_use_inout      => true,
 		g_fmc_id         => g_fmc_id,
 		g_fmc_map        => g_fmc_map,
 		g_fmc_idelay_map => c_iodelaymap
 	)
 	port map(
 		port_fmc_io    => port_fmc_io,
 		port_fmc_in_i  => port_fmc_in_i,
 		port_fmc_out_o => port_fmc_out_o,
 		fmc_in_o       => s_fmc_in1,
 		fmc_out_i      => s_fmc_out1,
 		fmc_out_dir_i  => s_fmc_dir1
 	);

   port_fmc_out_o <= s_fmc_in1;

   U_Adapter : wb_slave_adapter
    generic map (
      g_master_use_struct  => true,
      g_master_mode        => c_slave_interface_mode,
      g_master_granularity => WORD,
      g_slave_use_struct   => true,
      g_slave_mode         => g_interface_mode,
      g_slave_granularity  => g_address_granularity)
    port map (
      clk_sys_i  => clk_i,
      rst_n_i    => rst_n_i,
      master_i   => wb_s2m,
      master_o   => wb_m2s,
	  slave_i    => slave_i,
	  slave_o    => slave_o
	);


wb_s2m.dat <= (others => '0');

   
   p_ack: process(clk_i)
    begin
      if(rising_edge(clk_i)) then
        if(rst_n_i = '0') then
          wb_s2m.ack <= '0';
        else
          if(wb_s2m.ack = '1' and c_slave_interface_mode = CLASSIC) then
            wb_s2m.ack <= '0';
          else
            wb_s2m.ack <= wb_m2s.cyc and wb_m2s.stb;
          end if;
        end if;
      end if;
    end process;	
	
	slave_o.err <= '0';
	slave_o.rty <= '0';
	slave_o.int <= '0';
	
   
 
end Behavioral;
