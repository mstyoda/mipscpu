--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:36:28 11/19/2017
-- Design Name:   
-- Module Name:   E:/ShuDianShiYan/mipscpu/test_ex.vhd
-- Project Name:  mipscpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ex
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee,my_lib;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use my_lib.cpu_constant.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_ex IS
END test_ex;
 
ARCHITECTURE behavior OF test_ex IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ex
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         a : IN  std_logic_vector(15 downto 0);
         a_addr : IN  std_logic_vector(3 downto 0);
         b : IN  std_logic_vector(15 downto 0);
         b_addr : IN  std_logic_vector(3 downto 0);
         imm : IN  std_logic_vector(15 downto 0);
         a_imm : IN  std_logic;
         b_imm : IN  std_logic;
         op_alu : IN  std_logic_vector(2 downto 0);
         op_mem : IN  std_logic_vector(1 downto 0);
         wb_addr : IN  std_logic_vector(3 downto 0);
         answer : OUT  std_logic_vector(15 downto 0);
         addr : OUT  std_logic_vector(15 downto 0);
         r_data_mem : IN  std_logic_vector(15 downto 0);
         r_addr_mem : IN  std_logic_vector(3 downto 0);
         r_need_mem : IN  std_logic;
         r_data_wb : IN  std_logic_vector(15 downto 0);
         r_addr_wb : IN  std_logic_vector(3 downto 0);
         r_need_wb : IN  std_logic;
         need_predict : IN  std_logic_vector(1 downto 0);
         correctpc_ex : IN  std_logic_vector(15 downto 0);
         b_need : OUT  std_logic;
         b_pc : OUT  std_logic_vector(15 downto 0);
         predict_result : OUT  std_logic;
         stallreq : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '1';
   signal clk : std_logic := '0';
   signal a : std_logic_vector(15 downto 0) := (others => '0');
   signal a_addr : std_logic_vector(3 downto 0) := (others => '0');
   signal b : std_logic_vector(15 downto 0) := (others => '0');
   signal b_addr : std_logic_vector(3 downto 0) := (others => '0');
   signal imm : std_logic_vector(15 downto 0) := (others => '0');
   signal a_imm : std_logic := '0';
   signal b_imm : std_logic := '0';
   signal op_alu : std_logic_vector(2 downto 0) := (others => '0');
   signal op_mem : std_logic_vector(1 downto 0) := (others => '0');
   signal need_wb : std_logic := '0';
   signal wb_addr : std_logic_vector(3 downto 0) := (others => '0');
   signal r_data_mem : std_logic_vector(15 downto 0) := (others => '0');
   signal r_addr_mem : std_logic_vector(3 downto 0) := (others => '0');
   signal r_need_mem : std_logic := '0';
   signal r_data_wb : std_logic_vector(15 downto 0) := (others => '0');
   signal r_addr_wb : std_logic_vector(3 downto 0) := (others => '0');
   signal r_need_wb : std_logic := '0';
   signal need_predict : std_logic_vector(1 downto 0) := (others => '0');
   signal correctpc_ex : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal answer : std_logic_vector(15 downto 0);
   signal addr : std_logic_vector(15 downto 0);
   signal b_need : std_logic;
   signal b_pc : std_logic_vector(15 downto 0);
   signal predict_result : std_logic;
   signal stallreq : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   exuut: ex PORT MAP (
          rst => rst,
          clk => clk,
          a => a,
          a_addr => a_addr,
          b => b,
          b_addr => b_addr,
          imm => imm,
          a_imm => a_imm,
          b_imm => b_imm,
          op_alu => op_alu,
          op_mem => op_mem,
          wb_addr => wb_addr,
          answer => answer,
          addr => addr,
          r_data_mem => r_data_mem,
          r_addr_mem => r_addr_mem,
          r_need_mem => r_need_mem,
          r_data_wb => r_data_wb,
          r_addr_wb => r_addr_wb,
          r_need_wb => r_need_wb,
          need_predict => need_predict,
          correctpc_ex => correctpc_ex,
          b_need => b_need,
          b_pc => b_pc,
          predict_result => predict_result,
          stallreq => stallreq
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 20 ns;	

      wait for clk_period;

      -- insert stimulus here 
		a <= "0000000000000011";
		a_addr <= "0000";
		b <= "0000000000000001";
		b_addr <= "0001";
		imm <= "0000000000000100";
		a_imm <= '0';
		b_imm <= '0';
		op_alu <= ALU_ADD;
		op_mem <= MEM_NOP;
		need_wb <= '1';
		wb_addr <= "0001";
		r_data_mem <= "1000000000000000";
		r_addr_mem <= "0000";
		r_need_mem <= '1';
		
		r_data_wb  <= "0100000000000000";
		r_addr_wb  <= "0000";
		r_need_wb  <= '1';
		
		need_predict <= PREDICT_NZ;
		correctpc_ex <= (others => '0');
      wait;
   end process;

END;
