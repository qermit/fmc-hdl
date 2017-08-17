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
  
  subtype T_SLV_32  is STD_LOGIC_VECTOR(31 downto 0);
  type    T_SLVV_32 is array(NATURAL range <>) of T_SLV_32;
  signal s_tmp_dat_o: T_SLVV_32(3 downto 0);
  signal r_dat: T_SLVV_32(3 downto 0);
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



  
  GEN_TMP_DAT_O: for i in s_tmp_dat_o'range generate
     signal r_dat_tmp: std_logic_vector(31 downto 0);
     --signal tmp_ctl_rdy: std_logic_vector(0 downto 0);
  begin
  --  31 - 16 15 14 - 12 11 10  9  8  7  6  5  4 - 0
  --     |     |    |     |  |  |  |  |  |  |  \\|//         
  --     |     |    R     |  |  |  |  |  |  |   \|/  
  --     |     |    E     |  |  |  |  |  |  |    |  
  --     |     |    S     |  |  |  |  |  |  |    +---------- ctrl_value_out/ctrl_value_in 
  --     |     |    E     |  |  |  |  |  |  |   
  --     |     |    R     |  |  |  |  |  |  +--------------- IDELAY_CTL_RDY (RO) 
  --     |     |    V     |  |  |  |  |  +------------------ IDELAY_CTL_RESET
  --     |     |    E     |  |  |  |  +--------------------- LD
  --     |     |    D     |  |  |  +------------------------ CE
  --     |     |    |     |  |  +--------------------------- INC
  --     |     |          |  +------------------------------ LDPIPEEN ( used only in pipelined mode )
  --     |     |          +--------------------------------- REGRST ( used only in pipelined mode )
  --     |     |  
  --     |     +-------------------------------------- CLK LINE SELECT
  --     +-------------------------------------------- DATA LINE SELECT  
  
  
     r_dat_tmp <= r_dat(i);
     --s_tmp_dat_o(i) <= r_dat(31 downto 16) & r_dat(15) & "000" & r_dat(11 downto 6) & idelay_ctrl_out_i(i).ctl_rdy & idelay_ctrl_out_i(i).cntvalueout;
     s_tmp_dat_o(i) <= r_dat_tmp(31 downto 16) & r_dat_tmp(15) & "000" & r_dat_tmp(11 downto 6) & idelay_ctrl_out_i(i).ctl_rdy & idelay_ctrl_out_i(i).cntvalueout;
     
     idelay_ctrl_in_o(i).cntvaluein  <= r_dat_tmp(4 downto 0);
     idelay_ctrl_in_o(i).ctl_reset   <= r_dat_tmp(6) or (not rst_n_i);
     idelay_ctrl_in_o(i).ld          <= r_dat_tmp(7);
     idelay_ctrl_in_o(i).ce          <= r_dat_tmp(8);
     idelay_ctrl_in_o(i).inc         <= r_dat_tmp(9);
     idelay_ctrl_in_o(i).ld_pipeen   <= r_dat_tmp(10);
     idelay_ctrl_in_o(i).reg_reset   <= r_dat_tmp(11);
     
     idelay_ctrl_in_o(i).clk_sel     <= r_dat_tmp(15); -- todo remove
     idelay_ctrl_in_o(i).data_sel    <= r_dat_tmp(31 downto 16);
       
     
  end generate;

	
  p_data: process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      -- clear all data after one cycle
      for i in 0 to c_group_count - 1 loop
        r_dat(i)(11 downto 7) <= "00000";
      end loop;
      
      if rst_n_i = '0' then
        wb_s2m.dat <= (others => '0');   
        for i in 0 to c_group_count - 1 loop
         r_dat(i) <= x"00000000";
        end loop;
      else
        for i in 0 to c_group_count - 1 loop
        
          if s_cyc(i) = '1' and wb_m2s.we = '1' then
            r_dat(i) <= wb_m2s.dat;
          end if;
          
          if s_cyc(i) = '1' and wb_m2s.we = '0' then
            wb_s2m.dat <= s_tmp_dat_o(i);
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
