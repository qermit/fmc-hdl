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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

use work.fmc_general_pkg.all;

entity fmc_pinpair  is
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
end fmc_pinpair;

architecture rtl of fmc_pinpair is	
	signal s_raw_p: std_logic;
	--signal s_raw_n: std_logic;
begin
		

	GEN_SINGLE: if g_diff = '0' generate
		fmc_p_o <= fmc_n_i when g_fmc_inv = '1' else fmc_p_i;
		fmc_n_o <= fmc_p_i when g_fmc_inv = '1' else fmc_n_i;
	end generate GEN_SINGLE;
	
	
	

		
GEN_DIFF: if g_diff = '1' generate
   GEN_DIFF_IN: if g_dir_out = '0' generate 
   cmp_ibuf : IBUFDS
			generic map(
				IOSTANDARD => "DEFAULT"
			)
			port map(
				I  => fmc_p_i,
				IB => fmc_n_i,
				O  => s_raw_p
			);
			fmc_p_o <= s_raw_p xor g_fmc_inv;
			fmc_n_o <= '0';
	 end generate GEN_DIFF_IN;
	
   GEN_DIFF_OUT: if g_dir_out = '1' generate 
      s_raw_p <= fmc_p_i xor g_fmc_inv;
    cmp_obuf : OBUFDS
	generic map(
				IOSTANDARD => "DEFAULT"
			)
			port map(
				O  => fmc_p_o,
				OB => fmc_n_o,
				I  => s_raw_p
	);
	 end generate GEN_DIFF_OUT;
		
	 
end generate GEN_DIFF;

end rtl;
