-------------------------------------------------------------------------------
-- Title      : Wishbone decoupling module
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : xwb_decoupler.vhd
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2017-07-21
-- Last update: 2017-07-21
-- Platform   : FPGA-generics
-- Standard   : VHDL
-------------------------------------------------------------------------------
-- Description:
-- 
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2017 Piotr Miedzik
-------------------------------------------------------------------------------

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

use work.wishbone_pkg.all;

entity xwb_fmc_csr is
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
end xwb_fmc_csr;

architecture Behavioral of xwb_fmc_csr is  
 
 constant c_slave_interface_mode : t_wishbone_interface_mode      := PIPELINED;
signal wb_m2s : t_wishbone_slave_in;
signal wb_s2m : t_wishbone_slave_out;

constant C_CSR0_BIT_prsnt   : natural := 0;
constant C_CSR0_BIT_pg_m2c  : natural := 1;
constant C_CSR0_BIT_pg_c2m  : natural := 2;
constant C_CSR0_BIT_sys_i2c : natural := 3;
constant C_CSR0_BIT_enabled : natural := 4;

function f_bool2bit(b: boolean) return std_logic is
begin
  if b = true then
    return '1';
  end if;
  return '0';
end function;

constant c_bit_prsnt_magic  : std_logic_vector(3 downto 0) := "1010";
constant c_bit_prsnt_pg_m2c : std_logic_vector(3 downto 0) := "0011";
constant c_bit_prsnt_pg_c2m : std_logic_vector(3 downto 0) := "1100";

constant c_fmc_slot_id : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(g_fmc_id, 8));

signal r_csr0: std_logic_vector(31 downto 0);

signal r_fmc_enable: std_logic := '0';
signal r_prsnt : std_logic := '0';
signal r_pg_m2c : std_logic := '0';
signal r_pg_c2m : std_logic := '0';

signal s_prsnt : std_logic := '0';
signal s_pg_m2c : std_logic := '0';
signal s_pg_c2m : std_logic := '0';



begin

 fmc_enable_o <= r_fmc_enable;

 s_prsnt <= not prsntl_i when g_enable_prsntl = true else r_prsnt;
 s_pg_m2c <= pg_m2c_i when g_enable_pg_m2c = true else r_pg_m2c;
 s_pg_c2m <= pg_c2m_i when g_enable_pg_c2m = true else r_pg_c2m;
 
  r_csr0 <= ( C_CSR0_BIT_prsnt  => s_prsnt,
              C_CSR0_BIT_pg_m2c => s_pg_m2c,
              C_CSR0_BIT_pg_c2m => s_pg_c2m,
              C_CSR0_BIT_sys_i2c => f_bool2bit(g_enable_system_i2c),
              
              C_CSR0_BIT_enabled => r_fmc_enable,
              
              8 =>  c_fmc_slot_id(0),
              9 =>  c_fmc_slot_id(1),
              10 => c_fmc_slot_id(2),
              11 => c_fmc_slot_id(3),
              12 => c_fmc_slot_id(4),
              13 => c_fmc_slot_id(5),
              14 => c_fmc_slot_id(6),
              15 => c_fmc_slot_id(7),
              
              others => '0' );


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
	  slave_i    => s_wb_m2s,
	  slave_o    => s_wb_s2m
	);

  p_data: process(clk_i)
  begin
    if rising_edge(clk_i) then    
      if rst_n_i = '0' then
        wb_s2m.dat <= (others => '0');
        
        r_fmc_enable <= '0';
        r_prsnt   <= '0';
        r_pg_m2c  <= '0';
        r_pg_c2m  <= '0';
      else                
        wb_s2m.dat <= (others => '0');
        if (wb_m2s.cyc = '1' and wb_m2s.stb = '1' and wb_m2s.we = '0') then
          if wb_m2s.adr(1 downto 0) = "00" then
            wb_s2m.dat <= r_csr0;
          else
            wb_s2m.dat <= (others => '0');
          end if;
        elsif (wb_m2s.cyc = '1' and wb_m2s.stb = '1' and wb_m2s.we = '1') then
          if wb_m2s.adr(1 downto 0) = "00" then
             null;
             
          elsif wb_m2s.adr(1 downto 0) = "01" then -- CSR1
             r_fmc_enable <= wb_m2s.dat(C_CSR0_BIT_enabled);
             
          elsif wb_m2s.adr(1 downto 0) = "10" then -- shadow register
            if wb_m2s.dat(31 downto 28) = c_bit_prsnt_magic then
              r_prsnt <= wb_m2s.dat(C_CSR0_BIT_prsnt);
            end if;
            if wb_m2s.dat(31 downto 28) = c_bit_prsnt_pg_m2c then
              r_pg_m2c <= wb_m2s.dat(C_CSR0_BIT_pg_m2c);
            end if;
            if wb_m2s.dat(31 downto 28) = c_bit_prsnt_pg_c2m then
              r_pg_c2m <= wb_m2s.dat(C_CSR0_BIT_pg_c2m);
            end if;
          elsif wb_m2s.adr(1 downto 0) = "11" then
            null;
          end if;
        end if;  
        
      end if;
    end if;
  end process;  

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
	
  wb_s2m.stall <= '0';
  wb_s2m.err <= '0';
  wb_s2m.rty <= '0';
  wb_s2m.int <= '0';
    
end Behavioral;
