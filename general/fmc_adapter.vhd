----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:35 02/08/2016 
-- Design Name: 
-- Module Name:    fmc_adapter_in - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fmc_adapter is
generic (
  g_pin_count : natural := 34;
  g_diff      : std_logic_vector(200 downto 0) := (others => 'X');
  g_fmc_inv   : std_logic_vector(200 downto 0) := (others => '0');
  g_dir_out   : bit := '0'
);
    Port ( 
        fmc_p_i :  in std_logic_vector(g_pin_count-1 downto 0) := (others => '0') ;
        fmc_n_i :  in std_logic_vector(g_pin_count-1 downto 0) := (others => '1') ;
	        
        fmc_p_o : out std_logic_vector(g_pin_count-1 downto 0);
        fmc_n_o : out std_logic_vector(g_pin_count-1 downto 0)
	);
	
end fmc_adapter;

architecture rtl of fmc_adapter is
attribute keep: boolean;

	 
component fmc_pinpair
    generic (
			g_diff: std_logic:='X';
			g_fmc_inv : std_logic := '0';
			g_dir_out: bit := '0'
	 );
    Port ( 
		fmc_p_i: in std_logic;
		fmc_n_i: in std_logic;
	    fmc_p_o :out std_logic;		  
	    fmc_n_o :out std_logic
	);
end component;
begin
		
GEN_PINPAIR: for I in 0 to g_pin_count-1 generate

   GEN_PINPAIR2: if g_diff(I) = '0' or g_diff(I) = '1' generate
	
	   u_fmc_pinpair_X: fmc_pinpair
		  generic map (
		    g_diff => g_diff(I),
			 g_fmc_inv => g_fmc_inv(I),
			 g_dir_out => g_dir_out
		  )
        Port map ( 
            fmc_p_i => fmc_p_i(I),
				fmc_n_i => fmc_n_i(I),
            fmc_p_o => fmc_p_o(I),
				fmc_n_o => fmc_n_o(I)
      );
	end generate GEN_PINPAIR2;
	
end generate GEN_PINPAIR;

end rtl;
