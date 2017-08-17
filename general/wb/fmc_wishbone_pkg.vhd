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

use work.fmc_general_pkg.all;
use work.wishbone_pkg.all;
use work.wb_helpers_pkg.all;

package fmc_wishbone_pkg is

-------------------------
-- Wishbone components --
-------------------------

  constant c_xwb_fmc_csr_sdb_f : t_sdb_device := f_sdb_device(
      sdb_component => f_sdb_component(
        addr_size   => 255,  
        product => f_sdb_product (
          vendor_id => C_PEN_GSI,
          device_id => x"dea435352",
          version   => 1,
          date      => x"20170803",
          name      => "FMC CSR"
        ))); 


component xwb_fmc_csr is
            generic (
            g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
            g_address_granularity    : t_wishbone_address_granularity := WORD;  
          
            g_enable_system_i2c   : boolean := true;
            g_enable_pg_m2c       : boolean := false;
            g_enable_pg_c2m       : boolean := false;
            g_enable_prsntl       : boolean := false;
            
            g_fmc_id              : natural := 1
            );
          Port (
            clk_i        : in std_logic;
            rst_n_i      : in std_logic;
            
            --== Wishbone ==--    
            s_wb_m2s     : in  t_wishbone_slave_in;
            s_wb_s2m     : out t_wishbone_slave_out;
            
            
            pg_m2c_i : in std_logic := '1';
            pg_c2m_i : in std_logic  := '1';
            prsntl_i : in std_logic  := '1';
                
                
            fmc_enable_o: out std_logic
            
            
            );
        end component;          

  constant c_xwb_idelay_ctl_sdb : t_sdb_device := (
  abi_class     => x"0000",              -- undocumented device
  abi_ver_major => x"01",
  abi_ver_minor => x"01",
  wbd_endian    => c_sdb_endian_big,
  wbd_width     => x"7",                 -- 8/16/32-bit port granularity
  sdb_component => (
    addr_first  => x"0000000000000000",
    addr_last   => x"0000000000000fff",
    product     => (
      vendor_id => x"000000000000A8DF",  -- GSI PEN
      device_id => x"b00000b5",
      version   => x"00000001",
      date      => x"20170208",
      name      => "IODELAY CTL        ")));

        
        
    component wb_fmc_idelay_ctl is
       generic(
           g_interface_mode         : t_wishbone_interface_mode      := CLASSIC;
           g_address_granularity    : t_wishbone_address_granularity := WORD;
           g_fmc_connector : t_fmc_connector_type := FMC_HPC;
           g_idelay_map    : t_iodelay_map_vector := c_iodelay_map_nullvector
       );
       port (
            clk_sys_i    : in std_logic;
            rst_n_i      : in std_logic;
               -- Master connections (INTERCON is a slave)
           slave_i       : in  t_wishbone_slave_in;
           slave_o       : out t_wishbone_slave_out;
   
           idelay_ctrl_clk_o : out std_logic_vector(fmc_iodelay_group_count(g_idelay_map) - 1 downto 0);
           idelay_ctrl_in_o  : out t_fmc_idelay_in_array(fmc_iodelay_group_count(g_idelay_map) - 1 downto 0);
           idelay_ctrl_out_i : in  t_fmc_idelay_out_array(fmc_iodelay_group_count(g_idelay_map) - 1 downto 0)
           
       );
   end component;       
        
        
   component xwb_decoupler is
     Port (
       enable_i      : in std_logic;
       
       --== Wishbone ==--    
       s_wb_m2s      : in  t_wishbone_slave_in;
       s_wb_s2m      : out t_wishbone_slave_out;
   
       m_wb_m2s       : out t_wishbone_slave_in;
       m_wb_s2m       : in  t_wishbone_slave_out
       
       );
   end component xwb_decoupler;
   
end package fmc_wishbone_pkg;

