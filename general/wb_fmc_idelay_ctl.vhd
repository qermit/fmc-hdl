library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.fmc_general_pkg.all;
use work.wishbone_pkg.all;

entity wb_fmc_idelay_ctl is
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
end wb_fmc_idelay_ctl;		

architecture behavioral of wb_fmc_idelay_ctl is
  constant c_group_count : natural := fmc_iodelay_group_count(g_idelay_map);
  constant c_slave_interface_mode : t_wishbone_interface_mode := PIPELINED;
  
  signal wb_s2m : t_wishbone_slave_out;
  signal wb_m2s : t_wishbone_slave_in;
  
  --  31 - 16 15 14 - 10  9  8  7  6  5  4 - 0
  --     |     |    |     |  |  |  |  |  \\|//         
  --     |     |    R     |  |  |  |  |   \|/  
  --     |     |    E     |  |  |  |  |    |  
  --     |     |    S     |  |  |  |  |    +---------- ctrl_value_out/ctrl_value_in 
  --     |     |    E     |  |  |  |  |   
  --     |     |    R     |  |  |  |  +--------------- LD
  --     |     |    V     |  |  |  +------------------ CE
  --     |     |    E     |  |  +--------------------- INC
  --     |     |    D     |  +------------------------ REGRST ( used only in pipelined mode )
  --     |     |    |     +--------------------------- LDPIPEEN ( used only in pipelined mode )
  --     |     |  
  --     |     +-------------------------------------- CLK LINE SELECT
  --     +-------------------------------------------- DATA LINE SELECT
  
  
  signal address_to_decode: std_logic_vector(1 downto 0);
  signal s_cyc: std_logic_vector(c_group_count-1 downto 0);
begin
  

  U_Adapter : wb_slave_adapter
    generic map (
      g_master_use_struct  => true,
      g_master_mode        => PIPELINED,
      g_master_granularity => WORD,
      g_slave_use_struct   => true,
      g_slave_mode         => g_interface_mode,
      g_slave_granularity  => g_address_granularity)
    port map (
      clk_sys_i  => clk_sys_i,
      rst_n_i    => rst_n_i,
      master_i   => wb_s2m,
      master_o   => wb_m2s,
	  slave_i    => slave_i,
	  slave_o    => slave_o
	);


  proc_clk : process(clk_sys_i)
  begin
    for i in 0 to c_group_count - 1 loop
      idelay_ctrl_clk_o(i) <= clk_sys_i;
    end loop;
  end process;
  
  
  address_to_decode <= wb_m2s.adr(address_to_decode'left downto address_to_decode'right);
  process(address_to_decode, wb_m2s.cyc, wb_m2s.stb)
  begin
     s_cyc <= (others => '0');
     case address_to_decode is
       when "00" => s_cyc(0) <= wb_m2s.cyc and wb_m2s.stb;
       when "01" => s_cyc(1) <= wb_m2s.cyc and wb_m2s.stb;
       when "10" => s_cyc(2) <= wb_m2s.cyc and wb_m2s.stb;
       when "11" => s_cyc(3) <= wb_m2s.cyc and wb_m2s.stb;
       when others => s_cyc <= (others => '0');
     end case;
  end process;

	
  p_data: process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      for i in 0 to c_group_count - 1 loop
        idelay_ctrl_in_o(i).inc         <= '0';
        idelay_ctrl_in_o(i).ce          <= '0';
        idelay_ctrl_in_o(i).ld          <= '0';
      end loop;
      
      
      if rst_n_i = '0' then
        wb_s2m.dat <= (others => '0');   
        for i in 0 to c_group_count - 1 loop
         idelay_ctrl_in_o(i).cntvaluein  <= (others => '0');
         idelay_ctrl_in_o(i).clk_sel     <= '0';
         idelay_ctrl_in_o(i).data_sel    <= (others => '0');
        end loop;
      else
        for i in 0 to c_group_count - 1 loop
          if s_cyc(i) = '1' and wb_m2s.we = '1' then
            idelay_ctrl_in_o(i).inc         <= wb_m2s.dat(7);
            idelay_ctrl_in_o(i).ce          <= wb_m2s.dat(6);
            idelay_ctrl_in_o(i).ld          <= wb_m2s.dat(5);
            idelay_ctrl_in_o(i).cntvaluein  <= wb_m2s.dat(4 downto 0);
            idelay_ctrl_in_o(i).clk_sel     <= wb_m2s.dat(15);
            idelay_ctrl_in_o(i).data_sel    <= wb_m2s.dat(31 downto 16);
          end if;
          if s_cyc(i) = '1' and wb_m2s.we = '0' then
            --wb_s2m.dat(31 downto 16) <=
            wb_s2m.dat(4 downto 0) <= idelay_ctrl_out_i(i).cntvalueout;
          end if;
        end loop;
      end if;
    end if;
  end process;
	
  p_ack: process(clk_sys_i)
    begin
      if(rising_edge(clk_sys_i)) then
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
    	
end behavioral;
