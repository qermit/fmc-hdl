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

use work.afc_pkg.all;
use work.fmc_adc_250m_16b_4cha_pkg.all;

entity jtag_adapter_iob is
	generic(
		g_use_inout : boolean := true
	);
	Port(
		port_jtag_io : inout t_jtag_port;
		jtag_i       : in    t_jtag_port;
		jtag_dir     : in    t_jtag_port;
		jtag_o       : out   t_jtag_port
	);
end jtag_adapter_iob;

architecture RTL of jtag_adapter_iob is
	
begin
	-- JTAG (bidir)
jtag_o.TCK    <= port_jtag_io.TCK;
jtag_o.TDI    <= port_jtag_io.TDI;
jtag_o.TDO    <= port_jtag_io.TDO;
jtag_o.TMS    <= port_jtag_io.TMS;
jtag_o.TRST_L <= port_jtag_io.TRST_L;

-- JTAG (bidir)
port_jtag_io.TCK    <= jtag_i.TCK when jtag_dir.TCK = '1' else 'Z';
port_jtag_io.TDI    <= jtag_i.TDI when jtag_dir.TCK = '1' else 'Z';
port_jtag_io.TDO    <= jtag_i.TDO when jtag_dir.TCK = '1' else 'Z';
port_jtag_io.TMS    <= jtag_i.TMS when jtag_dir.TCK = '1' else 'Z';
port_jtag_io.TRST_L <= jtag_i.TRST_L when jtag_dir.TCK = '1' else 'Z';
	
end architecture RTL;
