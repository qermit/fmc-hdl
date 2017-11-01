----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2017 09:04:53 AM
-- Design Name: 
-- Module Name: in_fifo_16b - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
Library UNISIM;
use UNISIM.vcomponents.all;

entity in_fifo_16b is
    Port ( fifo_wrclk : in STD_LOGIC;
           fifo_reset : in STD_LOGIC;
           fifo_D : in STD_LOGIC_VECTOR (15 downto 0);
           fifo_wren : in STD_LOGIC;
           fifo_full : out STD_LOGIC;
           fifo_almost_empty : out STD_LOGIC;
           fifo_almost_full : out STD_LOGIC;
           axis_aclk : in STD_LOGIC;
           axis_tdata : out STD_LOGIC_VECTOR (15 downto 0);
           axis_tvalid : out STD_LOGIC;
           axis_tready : in STD_LOGIC);
end in_fifo_16b;

architecture Behavioral of in_fifo_16b is
  signal fifo_empty: std_logic;
  
  signal D : std_logic_vector(12*4-1 downto 0);
  signal Q : std_logic_vector(12*4-1 downto 0);
  
  signal Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9: std_logic_vector(7 downto 0);
  signal D0, D1, D2, D3, D4, D7, D8, D9: std_logic_vector(3 downto 0) := x"A";
  signal D5, D6: std_logic_vector(7 downto 0) := x"BB";
begin

  axis_tvalid <= not fifo_empty;

  D0 <= D( 1*4 - 1 downto  0*4);
  D1 <= D( 2*4 - 1 downto  1*4);
  D2 <= D( 3*4 - 1 downto  2*4);
  D3 <= D( 4*4 - 1 downto  3*4);
  D4 <= D( 5*4 - 1 downto  4*4);
  D5 <= D(11*4 - 1 downto 10*4) & D( 6*4 - 1 downto 5*4);
  D6 <= D(12*4 - 1 downto 11*4) & D( 7*4 - 1 downto 6*4);
  D7 <= D( 8*4 - 1 downto  7*4);
  D8 <= D( 9*4 - 1 downto  8*4);
  D9 <= D(10*4 - 1 downto  9*4);
  
  Q <= Q6(7 downto 4) & Q5(7 downto 4) & Q9(3 downto 0) & Q8(3 downto 0) &
       Q7(3 downto 0) & Q6(3 downto 0) & Q5(3 downto 0) & Q4(3 downto 0) &
       Q3(3 downto 0) & Q2(3 downto 0) & Q1(3 downto 0) & Q0(3 downto 0);

  D(fifo_D'left downto 0) <= fifo_D;
  D(D'left downto fifo_D'left+1) <= (others => '0'); 
  axis_tdata <= Q(axis_tdata'left downto 0);
  
   U_fifo : IN_FIFO
   generic map (
      ALMOST_EMPTY_VALUE => 1,          -- Almost empty offset (1-2)
      ALMOST_FULL_VALUE => 1,           -- Almost full offset (1-2)
      ARRAY_MODE => "ARRAY_MODE_4_X_4", -- ARRAY_MODE_4_X_8, ARRAY_MODE_4_X_4
      SYNCHRONOUS_MODE => "FALSE"       -- Clock synchronous (FALSE)
   )
   port map (
      -- FIFO Status Flags: 1-bit (each) output: Flags and other FIFO status outputs
      ALMOSTEMPTY => fifo_almost_empty, -- 1-bit output: Almost empty
      ALMOSTFULL => fifo_almost_full,   -- 1-bit output: Almost full
      EMPTY => fifo_empty,             -- 1-bit output: Empty
      FULL => fifo_full,               -- 1-bit output: Full
      -- Q0-Q9: 8-bit (each) output: FIFO Outputs
      Q0 => Q0,                   -- 8-bit output: Channel 0
      Q1 => Q1,                   -- 8-bit output: Channel 1
      Q2 => Q2,                   -- 8-bit output: Channel 2
      Q3 => Q3,                   -- 8-bit output: Channel 3
      Q4 => Q4,                   -- 8-bit output: Channel 4
      Q5 => Q5,                   -- 8-bit output: Channel 5
      Q6 => Q6,                   -- 8-bit output: Channel 6
      Q7 => Q7,                   -- 8-bit output: Channel 7
      Q8 => Q8,                   -- 8-bit output: Channel 8
      Q9 => Q9,                   -- 8-bit output: Channel 9
      -- D0-D9: 4-bit (each) input: FIFO inputs
      D0 => D0,                   -- 4-bit input: Channel 0
      D1 => D1,                   -- 4-bit input: Channel 1
      D2 => D2,                   -- 4-bit input: Channel 2
      D3 => D3,                   -- 4-bit input: Channel 3
      D4 => D4,                   -- 4-bit input: Channel 4
      D5 => D5,                   -- 8-bit input: Channel 5
      D6 => D6,                   -- 8-bit input: Channel 6
      D7 => D7,                   -- 4-bit input: Channel 7
      D8 => D8,                   -- 4-bit input: Channel 8
      D9 => D9,                   -- 4-bit input: Channel 9
      -- FIFO Control Signals: 1-bit (each) input: Clocks, Resets and Enables
      RDCLK => axis_aclk,             -- 1-bit input: Read clock
      RDEN  => axis_tready,               -- 1-bit input: Read enable
      RESET => fifo_reset,             -- 1-bit input: Reset
      WRCLK => fifo_wrclk,             -- 1-bit input: Write clock
      WREN  => fifo_wren                -- 1-bit input: Write enable
   );


end Behavioral;
