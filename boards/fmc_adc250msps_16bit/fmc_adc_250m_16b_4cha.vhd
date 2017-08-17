-------------------------------------------------------------------------------
-- Title      : FMC ADC 250m 16b 4cha HDL module
-- Project    : FMC Cores
-------------------------------------------------------------------------------
-- File       : fmc_adc_250m_16b_4cha.vhd
-- Author     : Piotr Miedzik
-- Company    : GSI
-- Created    : 2016-03-08
-- Last update: 2016-03-08
-- Platform   : FPGA-generics
-- Standard   : VHDL
-------------------------------------------------------------------------------
-- Description:
-- fmc_adc_250m_16b_4cha integrates  ... tbd 
-- 
-------------------------------------------------------------------------------
-- Copyright (c) 2016 Piotr Miedzik
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.fmc_general_pkg.all;
use work.fmc_wishbone_pkg.all;

use work.wishbone_pkg.all;
use work.wb_helpers_pkg.all;
use work.wishbone_gsi_lobi_pkg.all;

use work.fmc_adc_250m_16b_4cha_pkg.all;
use work.fmc_helper_pkg.all;


entity fmc_adc_250m_16b_4cha is
	generic(
		g_fmc_id              : natural                        := 0;
		g_interface_mode      : t_wishbone_interface_mode      := CLASSIC;
		g_address_granularity : t_wishbone_address_granularity := WORD;
		g_use_tristate        : boolean                        := true;

        g_enable_system_i2c   : boolean                        := true;
		g_fmc_map             : t_fmc_pin_map_vector           := c_fmc_pin_nullvector;
		g_master              : boolean                        := true;
		
		g_buggy_transistors   : boolean                        := false
	);

	Port(
		clk_i          : in    STD_LOGIC;
		rst_n_i        : in    STD_LOGIC;
		refclk_i       : in    STD_LOGIC;

		port_fmc_inout : inout t_fmc_signals_bidir;
		port_fmc_in    : in    t_fmc_signals_in;
		port_fmc_out   : out   t_fmc_signals_out;
		
		debug_raw_o    : out   std_logic_vector(4 downto 0);

        adc_clk_i      : in std_logic := '0'; -- slave clock 
		adc_clk_o      : out std_logic; -- master clock
		
		adc0_data      : out std_logic_vector(15 downto 0);
		adc0_tvalid    : OUT STD_LOGIC;
		adc0_tready    : in std_logic;
		adc1_data      : out std_logic_vector(15 downto 0);
		adc1_tvalid    : OUT STD_LOGIC;
        adc1_tready    : in std_logic;
        adc2_data      : out std_logic_vector(15 downto 0);
		adc2_tvalid    : OUT STD_LOGIC;
        adc2_tready    : in std_logic;
        adc3_data      : out std_logic_vector(15 downto 0);      
        adc3_tvalid    : OUT STD_LOGIC;
        adc3_tready    : in std_logic;

        trig_in_o      : OUT STD_LOGIC;
        trig_out_i     : in std_logic := '0' ;
                
		slave_i        : in    t_wishbone_slave_in;
		slave_o        : out   t_wishbone_slave_out
	);

end fmc_adc_250m_16b_4cha;


architecture Behavioral of fmc_adc_250m_16b_4cha is

  signal s_debug_raw_o: std_logic_vector(4 downto 0);
  signal tmp_counter: unsigned(31 downto 0);
  signal tmp_counter_bit: std_logic;
  constant tmp_counter_load: unsigned(31 downto 0) := to_unsigned(0, 32); --to_unsigned(natural(125000) / 2, 32);

--    attribute keep:string;
   component in_fifo_16b is
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
           
           
           
end component;


          
	constant c_adc_iodelaymap : t_iodelay_map_vector(adc_250m_pin_map'range) := adc_250m_pin_map;
	constant c_test_bool :boolean := write_xdc("fmc"& integer'image(g_fmc_id) &"_loc.xdc", g_fmc_id , g_fmc_map, adc_250m_pin_map);
	

	signal s_fmc_in1  : t_fmc_signals_in;
	signal s_fmc_out1 : t_fmc_signals_out;
	signal s_fmc_dir1 : t_fmc_signals_out;

	signal s_fmc_idelay2iddr : t_fmc_signals_in;

	signal s_fmc_in_q1 : t_fmc_signals_in;

    constant c_iodelay_group_count : natural := fmc_iodelay_group_count(c_adc_iodelaymap);
	signal s_idelay_ctrl_in  : t_fmc_idelay_in_array(c_iodelay_group_count - 1 downto 0);
	signal s_idelay_ctrl_out : t_fmc_idelay_out_array(c_iodelay_group_count - 1 downto 0);
	signal s_idelay_ctrl_clk : std_logic_vector(c_iodelay_group_count - 1 downto 0);

    signal s_ddr_clk: std_logic_vector(3 downto 0);
    
    attribute keep : string;
    
    signal s_adc_q1: std_logic_vector(8*4-1 downto 0) := (others => '0');
    signal s_adc_q2: std_logic_vector(8*4-1 downto 0) := (others => '0');
    signal s_adc0_data: std_logic_vector(15 downto 0) := (others => '0');
    signal s_adc1_data: std_logic_vector(15 downto 0) := (others => '0');
    signal s_adc2_data: std_logic_vector(15 downto 0) := (others => '0');
    signal s_adc3_data: std_logic_vector(15 downto 0) := (others => '0');
    
    attribute keep of s_adc0_data   : signal is "true";
    attribute keep of s_adc1_data   : signal is "true";
    attribute keep of s_adc2_data   : signal is "true";
    attribute keep of s_adc3_data   : signal is "true";
 
    signal r_adc0_data      :  std_logic_vector(15 downto 0);
    signal r_adc0_tvalid    :  STD_LOGIC;
    signal r_adc0_tready    :  std_logic;
    signal r_adc1_data      :  std_logic_vector(15 downto 0);
    signal r_adc1_tvalid    :  STD_LOGIC;
    signal r_adc1_tready    :  std_logic;
    signal r_adc2_data      :  std_logic_vector(15 downto 0);
    signal r_adc2_tvalid    :  STD_LOGIC;
    signal r_adc2_tready    :  std_logic;
    signal r_adc3_data      :  std_logic_vector(15 downto 0);      
    signal r_adc3_tvalid    :  STD_LOGIC;
    signal r_adc3_tready    :  std_logic;
    
    --- ctl
    
      --== Internal Wishbone Crossbar configuration ==--
    -- Number of master port(s) on the wishbone crossbar
    constant c_WB_MASTER_SYSTEM : natural := 0;  -- Mezzanine system I2C interface (EEPROM)
  
    -- Number of slave port(s) on the wishbone crossbar
    constant c_NUM_WB_UPSTREAM : integer := 1;

    constant c_NUM_WB_DEVICES : integer := 8;
      
    constant c_WB_SLAVE_FMC_CSR      : natural := 0;
    constant c_WB_SLAVE_FMC_SYS_I2C  : natural := 1;  -- Mezzanine system I2C interface (EEPROM)
    
    constant c_WB_SLAVE_FMC_I2C_VCXO : natural := 2;  -- Mezzanine LED and trigger
    constant c_WB_SLAVE_FMC_SPI_PLL  : natural := 3;  -- Mezzanine LED and trigger
    constant c_WB_SLAVE_FMC_SPI_ADC  : natural := 4;  -- Mezzanine LED and trigger
    constant c_WB_SLAVE_FMC_SPI_MON  : natural := 5;  -- Mezzanine Monitor SPI
    constant c_WB_SLAVE_FMC_GPIO     : natural := 6;  -- Mezzanine LED and trigger
    constant c_WB_SLAVE_FMC_IDELAY   : natural := 7;  -- IDELAY wb slave 
        
      -- @todo: export sdb layouts to pkg files  
    -- Wishbone crossbar layout
    constant c_INTERCONNECT_LAYOUT_req : t_sdb_record_array(c_NUM_WB_DEVICES-1 downto 0) :=
      (
        c_WB_SLAVE_FMC_CSR      => f_sdb_auto_device(c_xwb_fmc_csr_sdb_f, true),
        c_WB_SLAVE_FMC_SYS_I2C  => f_sdb_auto_device(c_xwb_i2c_master_sdb, g_enable_system_i2c),
        c_WB_SLAVE_FMC_I2C_VCXO => f_sdb_auto_device(c_xwb_i2c_master_sdb, true, "I2C.Si57x"),
        c_WB_SLAVE_FMC_SPI_PLL  => f_sdb_auto_device(c_xwb_spi_sdb, true,"SPI.AD9510"),
        c_WB_SLAVE_FMC_SPI_ADC  => f_sdb_auto_device(c_xwb_spi_sdb, true,"SPI.ISLA216P"),
        c_WB_SLAVE_FMC_SPI_MON  => f_sdb_auto_device(c_xwb_spi_sdb, true,"SPI.AMC7823"),
        c_WB_SLAVE_FMC_GPIO     => f_sdb_auto_device(c_xwb_gpio_raw_sdb, true),
        c_WB_SLAVE_FMC_IDELAY   => f_sdb_auto_device(c_xwb_idelay_ctl_sdb, true)
        );
   
    

        
  -- sdb header address
    constant c_INTERCONNECT_LAYOUT : t_sdb_record_array(c_INTERCONNECT_LAYOUT_req'range) := f_sdb_auto_layout(c_INTERCONNECT_LAYOUT_req);
     -- Self Describing Bus ROM Address. It will be an addressed slave as well.
    constant c_SDB_ADDRESS                    : t_wishbone_address := f_sdb_auto_sdb(c_INTERCONNECT_LAYOUT_req);
    constant tmp2: boolean := sdb_dump_to_file("fmc"& integer'image(g_fmc_id) &"_adc250M_SDB.txt", c_INTERCONNECT_LAYOUT, c_SDB_ADDRESS);
     
      -- Wishbone buse(s) from crossbar master port(s)
    signal m_wishbone_m2s : t_wishbone_master_out_array(c_NUM_WB_DEVICES-1 downto 0);
    signal m_wishbone_s2m  : t_wishbone_master_in_array(c_NUM_WB_DEVICES-1 downto 0);
  
    -- Wishbone buse(s) to crossbar slave port(s)
    signal cnx_slave_out : t_wishbone_slave_out_array(c_NUM_WB_UPSTREAM-1 downto 0);
    signal cnx_slave_in  : t_wishbone_slave_in_array(c_NUM_WB_UPSTREAM-1 downto 0);

    
  --== Wishbone I2C master ==--
    signal sys_scl_in : std_logic;
    signal sys_scl_out: std_logic;
    signal sys_scl_oe_n: std_logic;
    signal sys_sda_in: std_logic;
    signal sys_sda_out: std_logic;
    signal sys_sda_oe_n: std_logic;    
  --== Wishbone I2C master ==--
    signal vcxo_scl_in : std_logic;
    signal vcxo_scl_out: std_logic;
    signal vcxo_scl_oe_n: std_logic;
    signal vcxo_sda_in: std_logic;
    signal vcxo_sda_out: std_logic;
    signal vcxo_sda_oe_n: std_logic;
    
   signal pll_cs_o   : std_logic_vector(0 downto 0);
   signal pll_sclk_o : std_logic;
   signal pll_mosi_o : std_logic;
   signal pll_miso_i : std_logic;

   signal adc_cs_o   : std_logic_vector(3 downto 0);
   signal adc_sclk_o : std_logic;
   signal adc_mosi_o : std_logic;
   signal adc_miso_i : std_logic;
    
   signal mon_cs_o   : std_logic_vector(0 downto 0);
   signal mon_sclk_o : std_logic;
   signal mon_mosi_o : std_logic;
   signal mon_miso_i : std_logic;
   
   constant c_gpio_pin_num : natural := 14;
   signal gpio_output : std_logic_vector(c_gpio_pin_num - 1 downto 0);
   signal gpio_input  : std_logic_vector(c_gpio_pin_num - 1 downto 0);
   signal gpio_dir_oe : std_logic_vector(c_gpio_pin_num - 1 downto 0);
   signal gpio_dir_oen: std_logic_vector(c_gpio_pin_num - 1 downto 0);
   signal gpio_term   : std_logic_vector(c_gpio_pin_num - 1 downto 0);
   signal gpio_raw_o  : std_logic_vector(c_gpio_pin_num - 1 downto 0);
   signal gpio_raw_i  : std_logic_vector(c_gpio_pin_num - 1 downto 0);
   --  31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
   --                                                         |  |  |  |  |  |  |  |  |  |  |  |  |  +- LED 1 (RED)
   --                                                         |  |  |  |  |  |  |  |  |  |  |  |  +---- LED 2 (GREEN)
   --                                                         |  |  |  |  |  |  |  |  |  |  |  +------- LED 3 (BLUE)
   --                                                         |  |  |  |  |  |  |  |  |  |  +---------- TRIG (DIR, TERM, VAL)
   --                                                         |  |  |  |  |  |  |  |  |  +------------- PLL STATUS
   --                                                         |  |  |  |  |  |  |  |  +---------------- PLL Function
   --                                                         |  |  |  |  |  |  |  +------------------- PL RF out EN
   --                                                         |  |  |  |  |  |  +---------------------- PLL PDn
   --                                                         |  |  |  |  |  +------------------------- PLL CLK SEL
   --                                                         |  |  |  |  +---------------------------- ADC SLEEP
   --                                                         |  |  |  +------------------------------- ADC RESET
   --                                                         |  |  +---------------------------------- ADC CLKDIVRST
   --                                                         |  +--------------------------------------MON DAVn
   --                                                         +---------------------------------------- VCXO_PD_L
                                                                                            

    
   
   signal s_fmc_enable: std_logic;
   
begin

  debug_raw_o <= s_debug_raw_o; 



	cmp_fmc_adapter_iob : fmc_adapter_iob
		generic map(
			g_connector      => FMC_HPC,
			g_use_jtag       => false,
			g_use_system_i2c => g_enable_system_i2c,
			g_use_inout      => true,
			g_fmc_id         => g_fmc_id,
			g_fmc_map        => g_fmc_map,
			g_fmc_idelay_map => c_adc_iodelaymap
		)
		port map(
			port_fmc_io    => port_fmc_inout,
			port_fmc_in_i  => port_fmc_in,
			port_fmc_out_o => port_fmc_out,
			fmc_in_o       => s_fmc_in1,
			fmc_out_i      => s_fmc_out1,
			fmc_out_dir_i  => s_fmc_dir1
		);

	cmp_fmc_idelay : fmc_adapter_idelay
		generic map(
		    g_fmc_id => g_fmc_id,
			g_idelay_map => c_adc_iodelaymap
		)
		port map(
			fmc_in            => s_fmc_in1,
			fmc_out           => s_fmc_idelay2iddr,
			
			refclk_i          => refclk_i,
			
			idelay_ctrl_clk_i => s_idelay_ctrl_clk,
			idelay_ctrl_in_i  => s_idelay_ctrl_in,
			idelay_ctrl_out_o => s_idelay_ctrl_out
		);

	cmp_fmc_iddr : fmc_adapter_iddr
		generic map(
			g_fmc_id         => g_fmc_id,
			g_fmc_map        => g_fmc_map,
			g_fmc_idelay_map => c_adc_iodelaymap
		)
		port map(
			fmc_in     => s_fmc_idelay2iddr,
			sdr_q => s_fmc_in_q1,
			
			ddr_clk => s_ddr_clk,
			ddr_q1 => s_adc_q1,
			ddr_q2 => s_adc_q2
		);



GEN_DDR2SADC: for i in 0 to 7 generate
      s_adc0_data(2*i+0)  <= s_adc_q2(i);
      s_adc0_data(2*i+1)  <= s_adc_q1(i);
      
      s_adc1_data(2*i+0)  <= s_adc_q2(1*8+i);
      s_adc1_data(2*i+1)  <= s_adc_q1(1*8+i);

      s_adc2_data(2*i+0)  <= s_adc_q2(2*8+i);
      s_adc2_data(2*i+1)  <= s_adc_q1(2*8+i);

      s_adc3_data(2*i+0)  <= s_adc_q2(3*8+i);
      s_adc3_data(2*i+1)  <= s_adc_q1(3*8+i);
end generate;
            
     adc_clk_o <= s_ddr_clk(1);
      

    U_fifo_adc0: in_fifo_16b 
    Port map
      ( 
        fifo_wrclk => s_ddr_clk(0),
        fifo_reset => '0',
        fifo_D     => s_adc0_data,
        fifo_wren  => '1',
        fifo_full  => open,
        fifo_almost_empty => open,
        fifo_almost_full  => open,
        
        axis_aclk   => adc_clk_i,
        axis_tdata  => r_adc0_data,
        axis_tvalid => r_adc0_tvalid,
        axis_tready => r_adc0_tready
        );


    adc0_data <= r_adc0_data;
    adc0_tvalid <= r_adc0_tvalid;
    r_adc0_tready <= adc0_tready;
    
    U_fifo_adc1: in_fifo_16b 
    Port map
       ( 
            fifo_wrclk => s_ddr_clk(1),
            fifo_reset => '0',
            fifo_D     => s_adc1_data,
            fifo_wren  => '1',
            fifo_full  => open,
            fifo_almost_empty => open,
            fifo_almost_full  => open,
            
            axis_aclk   => adc_clk_i,
            axis_tdata  => r_adc1_data,
            axis_tvalid => r_adc1_tvalid,
            axis_tready => r_adc1_tready
            );

    adc1_data <= r_adc1_data;
    adc1_tvalid <= r_adc1_tvalid;
    r_adc1_tready <= adc1_tready;

    U_fifo_adc2: in_fifo_16b 
    Port map
      ( 
        fifo_wrclk => s_ddr_clk(2),
        fifo_reset => '0',
        fifo_D     => s_adc2_data,
        fifo_wren  => '1',
        fifo_full  => open,
        fifo_almost_empty => open,
        fifo_almost_full  => open,
        
        axis_aclk   => adc_clk_i,
        axis_tdata  => r_adc2_data,
        axis_tvalid => r_adc2_tvalid,
        axis_tready => r_adc2_tready
        );

    adc2_data <= r_adc2_data;
    adc2_tvalid <= r_adc2_tvalid;
    r_adc2_tready <= adc2_tready;


    U_fifo_adc3: in_fifo_16b 
    Port map
      ( 
        fifo_wrclk => s_ddr_clk(3),
        fifo_reset => '0',
        fifo_D     => s_adc3_data,
        fifo_wren  => '1',
        fifo_full  => open,
        fifo_almost_empty => open,
        fifo_almost_full  => open,
        
        axis_aclk   => adc_clk_i,
        axis_tdata  => r_adc3_data,
        axis_tvalid => r_adc3_tvalid,
        axis_tready => r_adc3_tready
        );

    adc3_data <= r_adc3_data;
    adc3_tvalid <= r_adc3_tvalid;
    r_adc3_tready <= adc3_tready;


        

  cnx_slave_in(c_WB_MASTER_SYSTEM) <= slave_i;
  slave_o <= cnx_slave_out(c_WB_MASTER_SYSTEM);

  U_sdb_crossbar : xwb_sdb_crossbar
    generic map (
      g_num_masters => c_NUM_WB_UPSTREAM,
      g_num_slaves  => c_NUM_WB_DEVICES,
      g_registered  => true,
      g_wraparound  => true,
      g_layout      => c_INTERCONNECT_LAYOUT,
      g_sdb_addr    => c_SDB_ADDRESS,
      g_sdb_name    => "fmc-adc-250m-16b")
    port map (
      clk_sys_i => clk_i,
      rst_n_i   => rst_n_i,
      slave_i   => cnx_slave_in,
      slave_o   => cnx_slave_out,
      master_i  => m_wishbone_s2m,
      master_o  => m_wishbone_m2s
      );


cmp_fmc_csr: xwb_fmc_csr
    generic  map (
    g_interface_mode         => g_interface_mode,
    g_address_granularity    => g_address_granularity,  
  
    g_enable_system_i2c   => g_enable_system_i2c,
    g_enable_pg_m2c       => false,
    g_enable_pg_c2m       => false,
    g_enable_prsntl       => false,
    
    g_fmc_id              => g_fmc_id
    )
  Port map  (
    clk_i        => clk_i,
    rst_n_i      => rst_n_i,
	
	--== Wishbone ==--	
	s_wb_m2s     => m_wishbone_m2s(c_WB_SLAVE_FMC_CSR),
    s_wb_s2m     => m_wishbone_s2m(c_WB_SLAVE_FMC_CSR),
    
    
    pg_m2c_i => '0',
    pg_c2m_i => '0',
    prsntl_i => '1',
    fmc_enable_o => s_fmc_enable
    );

    GEN_ILA_WB_CROSSBAR: if false generate
       signal ila_user : std_logic_vector(31 downto 0);
       constant c_mon_cs_num : natural := 1;
       constant c_adc_cs_num : natural := 4;
       constant c_pll_cs_num : natural := 1;
       
       begin
         
         
      U_ila_wb: xwb_ila_wishbone 
             Port map( 
             
             clk => clk_i,
             -- slave wishbone port
             s_wb_m2s => cnx_slave_in(c_WB_MASTER_SYSTEM),
             s_wb_s2m => cnx_slave_out(c_WB_MASTER_SYSTEM),
             s_user => ila_user
             );
         
         
         ila_user(0) <= mon_sclk_o;
         ila_user(1) <= mon_mosi_o;
         ila_user(2) <= mon_miso_i;
         ila_user(3) <= '0';

         ila_user(4 downto 4) <= mon_cs_o;
         ila_user(7 downto 5) <= (others => '1'); -- emulate chip select

         ila_user(8) <= pll_sclk_o;
         ila_user(9) <= pll_mosi_o;
         ila_user(10) <= pll_miso_i;
         ila_user(11) <= '0';
         ila_user(12 downto 12) <= pll_cs_o;
         ila_user(15 downto 13) <= (others => '1');

         ila_user(16) <= adc_sclk_o;
         ila_user(17) <= adc_mosi_o;
         ila_user(18) <= adc_miso_i;
         ila_user(19) <= gpio_output(10); -- check reset
         ila_user(23 downto 20) <= adc_cs_o;
         

         ila_user(24) <= vcxo_scl_in;
         ila_user(25) <= vcxo_sda_in;

         
         ila_user(30 downto 26) <= (others => '0');
         
         ila_user(31) <= rst_n_i;
    end generate;  


      
    GEN_I2C: if g_enable_system_i2c = true generate
        ------------------------------------------------------------------------------
        -- Mezzanine system managment I2C master
        --    Access to mezzanine EEPROM
        ------------------------------------------------------------------------------
        U_fmc_sys_i2c : xwb_i2c_master
          generic map(
            g_interface_mode      => g_interface_mode,
            g_address_granularity => g_address_granularity
            )
          port map (
            clk_sys_i => clk_i,
            rst_n_i   => rst_n_i,
      
            slave_i => m_wishbone_m2s(c_WB_SLAVE_FMC_SYS_I2C),
            slave_o => m_wishbone_s2m(c_WB_SLAVE_FMC_SYS_I2C),
            desc_o  => open,
      
            scl_pad_i(0)    => sys_scl_in,
            scl_pad_o(0)    => sys_scl_out,
            scl_padoen_o(0) => sys_scl_oe_n,
            sda_pad_i(0)    => sys_sda_in,
            sda_pad_o(0)    => sys_sda_out,
            sda_padoen_o(0) => sys_sda_oe_n
            );
      end generate;
      
      
    
        ------------------------------------------------------------------------------
        -- Mezzanine system managment I2C master
        --    Access to mezzanine EEPROM
        ------------------------------------------------------------------------------
        
BLK_vcxo_i2c: if true generate 
 signal local_wb_m2s       : t_wishbone_slave_in;
 signal local_wb_s2m       : t_wishbone_slave_out;
begin
        
          cmp_xwb_decoupler: xwb_decoupler 
          Port map (
            enable_i      => s_fmc_enable,
            
            --== Wishbone ==--    
            s_wb_m2s      => m_wishbone_m2s(c_WB_SLAVE_FMC_I2C_VCXO),
            s_wb_s2m      => m_wishbone_s2m(c_WB_SLAVE_FMC_I2C_VCXO),
        
            m_wb_m2s      => local_wb_m2s,
            m_wb_s2m      => local_wb_s2m
            
            );
                    
        U_fmc_vcxo_i2c : xwb_i2c_master
          generic map(
            g_interface_mode      => g_interface_mode,
            g_address_granularity => g_address_granularity
            )
          port map (
            clk_sys_i => clk_i,
            rst_n_i   => rst_n_i,
      
            slave_i => local_wb_m2s,
            slave_o => local_wb_s2m,
            desc_o  => open,
      
            scl_pad_i(0)    => vcxo_scl_in,
            scl_pad_o(0)    => vcxo_scl_out,
            scl_padoen_o(0) => vcxo_scl_oe_n,
            sda_pad_i(0)    => vcxo_sda_in,
            sda_pad_o(0)    => vcxo_sda_out,
            sda_padoen_o(0) => vcxo_sda_oe_n
            );

end generate;  

  s_fmc_out1.LA_p(6) <= vcxo_scl_out;
  s_fmc_dir1.LA_P(6) <= vcxo_scl_oe_n;
  vcxo_scl_in <= s_fmc_in_q1.LA_p(6);
     
  s_fmc_out1.LA_n(6) <= vcxo_sda_out;
  s_fmc_dir1.LA_n(6) <= vcxo_sda_oe_n;
  vcxo_sda_in <= s_fmc_in_q1.LA_n(6);
  
     
BLK_pll_spi: if true generate 
 signal local_wb_m2s       : t_wishbone_slave_in;
 signal local_wb_s2m       : t_wishbone_slave_out;
begin
        
          cmp_xwb_decoupler: xwb_decoupler 
          Port map (
            enable_i      => s_fmc_enable,
            
            --== Wishbone ==--    
            s_wb_m2s      => m_wishbone_m2s(c_WB_SLAVE_FMC_SPI_PLL),
            s_wb_s2m      => m_wishbone_s2m(c_WB_SLAVE_FMC_SPI_PLL),
        
            m_wb_m2s      => local_wb_m2s,
            m_wb_s2m      => local_wb_s2m
            
            );
            
      U_fmc_pll_spi: xwb_spi
              generic map(
                g_interface_mode      => g_interface_mode,
                g_address_granularity => g_address_granularity,
                g_divider_len         => 16,
                g_max_char_len        => 128,
                g_num_slaves          => 1)
              port map(
                clk_sys_i  => clk_i,
                rst_n_i    => rst_n_i,
                
                slave_i    => local_wb_m2s,
                slave_o    => local_wb_s2m,
                desc_o     => open,
                
                pad_cs_o   => pll_cs_o,
                pad_sclk_o => pll_sclk_o,
                pad_mosi_o => pll_mosi_o,
                pad_miso_i => pll_miso_i
              );
end generate;

     s_fmc_out1.HA_p(21) <= pll_cs_o(0);
     s_fmc_out1.HA_p(22) <= pll_sclk_o;
     s_fmc_out1.HA_n(21) <= pll_mosi_o;
     pll_miso_i <= s_fmc_in_q1.HA_p(23);

BLK_adc_spi: if true generate 
 signal local_wb_m2s       : t_wishbone_slave_in;
 signal local_wb_s2m       : t_wishbone_slave_out;
begin
        
          cmp_xwb_decoupler: xwb_decoupler 
          Port map (
            enable_i      => s_fmc_enable,
            
            --== Wishbone ==--    
            s_wb_m2s      => m_wishbone_m2s(c_WB_SLAVE_FMC_SPI_ADC),
            s_wb_s2m      => m_wishbone_s2m(c_WB_SLAVE_FMC_SPI_ADC),
        
            m_wb_m2s      => local_wb_m2s,
            m_wb_s2m      => local_wb_s2m
            
            );
                 
      U_fmc_adc_spi: xwb_spi
              generic map(
                g_interface_mode      => g_interface_mode,
                g_address_granularity => g_address_granularity,
                g_divider_len         => 16,
                g_max_char_len        => 128,
                g_num_slaves          => 4)
              port map(
                clk_sys_i  => clk_i,
                rst_n_i    => rst_n_i,
                
                slave_i    => local_wb_m2s,
                slave_o    => local_wb_s2m,
                desc_o     => open,
                
                pad_cs_o   => adc_cs_o,
                pad_sclk_o => adc_sclk_o,
                pad_mosi_o => adc_mosi_o,
                pad_miso_i => adc_miso_i
              );
end generate;             
              
      s_fmc_out1.LA_n(10) <= adc_cs_o(0);
      s_fmc_out1.LA_n( 9) <= adc_cs_o(1);
      s_fmc_out1.LA_p(10) <= adc_cs_o(2);
      s_fmc_out1.LA_p( 9) <= adc_cs_o(3);
      s_fmc_out1.LA_p(14) <= adc_sclk_o;
      s_fmc_out1.LA_n(14) <= adc_mosi_o;
      adc_miso_i <= s_fmc_in_q1.LA_n( 5);

     s_debug_raw_o(0) <= adc_cs_o(0);
     s_debug_raw_o(1) <= adc_cs_o(1);
     s_debug_raw_o(2) <= adc_sclk_o;
     s_debug_raw_o(3) <= adc_mosi_o;
     s_debug_raw_o(4) <= adc_miso_i;
    
BLK_mon_spi: if true generate 
 signal local_wb_m2s       : t_wishbone_slave_in;
 signal local_wb_s2m       : t_wishbone_slave_out;
begin
        
          cmp_xwb_decoupler: xwb_decoupler 
          Port map (
            enable_i      => s_fmc_enable,
            
            --== Wishbone ==--    
            s_wb_m2s      => m_wishbone_m2s(c_WB_SLAVE_FMC_SPI_MON),
            s_wb_s2m      => m_wishbone_s2m(c_WB_SLAVE_FMC_SPI_MON),
        
            m_wb_m2s      => local_wb_m2s,
            m_wb_s2m      => local_wb_s2m
            
            );
                 
      U_fmc_mon_spi: xwb_spi
              generic map(
                g_interface_mode      => g_interface_mode,
                g_address_granularity => g_address_granularity,
                g_divider_len         => 16,
                g_max_char_len        => 128,
                g_num_slaves          => 1)
              port map(
                clk_sys_i  => clk_i,
                rst_n_i    => rst_n_i,
                
                slave_i    => local_wb_m2s,
                slave_o    => local_wb_s2m,
                desc_o     => open,
                
                pad_cs_o   => mon_cs_o,
                pad_sclk_o => mon_sclk_o,
                pad_mosi_o => mon_mosi_o,
                pad_miso_i => mon_miso_i
              );
end generate;             

     s_fmc_out1.LA_n(30) <= mon_cs_o(0);
     s_fmc_out1.LA_p(31) <= mon_sclk_o;
     s_fmc_out1.LA_n(31) <= mon_mosi_o;
     mon_miso_i <= s_fmc_in_q1.LA_p(30);

              
BLK_GPIO: if true generate 
 signal local_wb_m2s       : t_wishbone_slave_in;
 signal local_wb_s2m       : t_wishbone_slave_out;
begin
        
          cmp_xwb_decoupler: xwb_decoupler 
          Port map (
            enable_i      => s_fmc_enable,
            
            --== Wishbone ==--    
            s_wb_m2s      => m_wishbone_m2s(c_WB_SLAVE_FMC_GPIO),
            s_wb_s2m      => m_wishbone_s2m(c_WB_SLAVE_FMC_GPIO),
        
            m_wb_m2s      => local_wb_m2s,
            m_wb_s2m      => local_wb_s2m
            
            );
                       
     U_fmc_GPIO : xwb_gpio_raw
       generic map(
         g_interface_mode                        => g_interface_mode,
         g_address_granularity                   => g_address_granularity,
         g_num_pins                              => c_gpio_pin_num,
         g_with_builtin_tristates                => false,
         g_debug                                 => false
         )
       port map(
         clk_sys_i                               => clk_i,
         rst_n_i                                 => rst_n_i,
   
         -- Wishbone
         slave_i                                 => local_wb_m2s,
         slave_o                                 => local_wb_s2m,
        
         desc_o                                  => open,    -- Not implemented
   
         --gpio_b : inout std_logic_vector(g_num_pins-1 downto 0);
         gpio_out_o                              => gpio_output,
         gpio_in_i                               => gpio_input,
         gpio_oe_o                               => gpio_dir_oe,
         gpio_term_o                             => gpio_term,
   
         -- AltF raw interface    
         raw_o => gpio_raw_o,
         raw_i => gpio_raw_i
         );
end generate;             
  
  gpio_dir_oen <= not gpio_dir_oe;

GEN_BUG: if g_buggy_transistors = true generate

  -- RED 
  s_fmc_out1.LA_p(29) <= gpio_output(0);
  s_fmc_dir1.LA_p(29) <= C_FMC_DIR_OUT;
  -- Green
  s_fmc_out1.LA_n(27) <= gpio_output(1);
  s_fmc_dir1.LA_n(27) <= C_FMC_DIR_OUT;
  -- Blue  
  s_fmc_out1.LA_n(24) <= gpio_output(2);
  s_fmc_dir1.LA_n(24) <= C_FMC_DIR_OUT;
  
  s_fmc_dir1.LA_p(33) <= gpio_dir_oen(3);
  s_fmc_out1.LA_p(33) <= gpio_output(3);
  gpio_input(3)       <= s_fmc_in_q1.LA_p(33);
  s_fmc_dir1.LA_p(27) <= C_FMC_DIR_OUT;
  s_fmc_out1.LA_p(27) <= gpio_dir_oen(3); -- trig dir

  s_fmc_dir1.LA_p(24) <= C_FMC_DIR_OUT;
  s_fmc_out1.LA_p(24) <= gpio_term(3);


end generate;

GEN_NOBUG: if g_buggy_transistors = false generate

  -- RED 
  s_fmc_out1.LA_n(24) <= gpio_output(0);
  s_fmc_dir1.LA_n(24) <= C_FMC_DIR_OUT;
  -- Green
  s_fmc_out1.LA_p(24) <= gpio_output(1);
  s_fmc_dir1.LA_p(24) <= C_FMC_DIR_OUT;
  -- Blue  
  s_fmc_out1.LA_p(29) <= gpio_output(2);
  s_fmc_dir1.LA_p(29) <= C_FMC_DIR_OUT;
  
  s_fmc_dir1.LA_p(33) <= gpio_dir_oen(3);
  s_fmc_out1.LA_p(33) <= gpio_output(3);
  gpio_input(3)       <= s_fmc_in_q1.LA_p(33);
  s_fmc_dir1.LA_p(27) <= C_FMC_DIR_OUT;
  s_fmc_out1.LA_p(27) <= gpio_dir_oen(3); -- trig dir
  s_fmc_dir1.LA_n(27) <= C_FMC_DIR_OUT;
  s_fmc_out1.LA_n(27) <= gpio_term(3);


end generate;

  
  
  gpio_input(4)       <= s_fmc_in_q1.HA_p(18); -- PLL Status
  s_fmc_out1.HA_n(18) <= gpio_output(5);       -- PLL Function
  s_fmc_dir1.HA_n(18) <= gpio_dir_oen(5);      -- PLL Function
  
  s_fmc_out1.HA_n(23) <= gpio_output(7);       -- PLL PDn
  s_fmc_dir1.HA_n(23) <= C_FMC_DIR_OUT;        -- PLL PDn
  s_fmc_out1.HA_n(22) <= gpio_output(8);       -- PLL CLK SEL
  s_fmc_dir1.HA_n(22) <= gpio_dir_oen(8);      -- PLL CLK SEL
  
  s_fmc_out1.HA_n(12) <= gpio_output(9);       -- ADC SLEEP
  s_fmc_dir1.HA_n(12) <= gpio_dir_oen(9);      -- ADC SLEEP
  s_fmc_out1.HA_p(13) <= gpio_output(10);      -- ADC RESET
  s_fmc_dir1.HA_p(13) <= gpio_dir_oen(10);     -- ADC RESET
  s_fmc_out1.LA_p(32) <= gpio_output(11);      -- ADC CLKDIVRST
  s_fmc_dir1.LA_p(32) <= gpio_dir_oen(11);     -- ADC CLKDIVRST
  
  gpio_input(12)      <= s_fmc_in_q1.LA_n(28); -- MON DAVn
  
  s_fmc_out1.LA_p( 5) <= gpio_output(13);      -- VCXO PD L
  s_fmc_dir1.LA_p( 5) <= gpio_dir_oen(13);     -- VCXO PD L
  

  process(clk_i)
  begin
    if rising_edge(clk_i) then
      if rst_n_i = '0' then
        tmp_counter <= tmp_counter_load;
        tmp_counter_bit <= '0';
      elsif tmp_counter = 0 then
        tmp_counter <= tmp_counter_load;
        tmp_counter_bit <= not tmp_counter_bit;
      else
        tmp_counter <= tmp_counter - 1;
      end if;
    end if;
  end process;
        
        
  gpio_raw_i(3) <= trig_out_i;
  trig_in_o <= gpio_raw_o(3);


BLK_IODELAY: block
  signal local_wb_m2s       : t_wishbone_slave_in;
  signal local_wb_s2m       : t_wishbone_slave_out;
begin

  cmp_xwb_decoupler: xwb_decoupler 
  Port map (
    enable_i      => s_fmc_enable,
	
	--== Wishbone ==--	
	s_wb_m2s      => m_wishbone_m2s(c_WB_SLAVE_FMC_IDELAY),
    s_wb_s2m      => m_wishbone_s2m(c_WB_SLAVE_FMC_IDELAY),

	m_wb_m2s      => local_wb_m2s,
    m_wb_s2m      => local_wb_s2m
    
    );

    U_idelay_ctl : wb_fmc_idelay_ctl
       generic map(
           g_interface_mode         => g_interface_mode,
           g_address_granularity    => g_address_granularity,
           g_fmc_connector          => FMC_HPC,
           g_idelay_map             => c_adc_iodelaymap
       )
       port map(
            clk_sys_i    => clk_i,
            rst_n_i      => rst_n_i,
               -- Master connections (INTERCON is a slave)
           slave_i       => local_wb_m2s,
           slave_o       => local_wb_s2m,
   
           idelay_ctrl_clk_o => s_idelay_ctrl_clk,
           idelay_ctrl_in_o  => s_idelay_ctrl_in,
           idelay_ctrl_out_i => s_idelay_ctrl_out
           
       );
    
end block;  

                 

end Behavioral;