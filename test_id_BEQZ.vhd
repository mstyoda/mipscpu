--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:52:06 11/20/2017
-- Design Name:   
-- Module Name:   E:/ShuDianShiYan/mipscpu/test_id_BEQZ.vhd
-- Project Name:  mipscpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: id
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
USE ieee.std_logic_1164.ALL;
use my_lib.cpu_constant.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_id_BEQZ IS
END test_id_BEQZ;
 
ARCHITECTURE behavior OF test_id_BEQZ IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT id
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         inst : IN  std_logic_vector(15 downto 0);
         nextpc : IN  std_logic_vector(15 downto 0);
         correctpc : OUT  std_logic_vector(15 downto 0);
         last_predict : IN  std_logic;
         b_need : OUT  std_logic;
         b_pc : OUT  std_logic_vector(15 downto 0);
         need_predict : OUT  std_logic_vector(1 downto 0);
         a : OUT  std_logic_vector(15 downto 0);
         a_addr : OUT  std_logic_vector(3 downto 0);
         b : OUT  std_logic_vector(15 downto 0);
         b_addr : OUT  std_logic_vector(3 downto 0);
         imm : OUT  std_logic_vector(15 downto 0);
         a_imm : OUT  std_logic;
         b_imm : OUT  std_logic;
         op_alu : OUT  std_logic_vector(2 downto 0);
         op_mem : OUT  std_logic_vector(1 downto 0);
         need_wb : OUT  std_logic;
         wb_addr : OUT  std_logic_vector(3 downto 0);
         wb_addr_ex : IN  std_logic_vector(3 downto 0);
         need_wb_ex : IN  std_logic;
         op_mem_ex : IN  std_logic_vector(1 downto 0);
         r1_addr : OUT  std_logic_vector(3 downto 0);
         r2_addr : OUT  std_logic_vector(3 downto 0);
         r1_data : IN  std_logic_vector(15 downto 0);
         r2_data : IN  std_logic_vector(15 downto 0);
         r1_need : OUT  std_logic;
         r2_need : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '1';
   signal clk : std_logic := '0';
   signal inst : std_logic_vector(15 downto 0) := (others => '0');
   signal nextpc : std_logic_vector(15 downto 0) := (others => '0');
   signal last_predict : std_logic := PREDICT_CORRECT;
   signal wb_addr_ex : std_logic_vector(3 downto 0) := (others => '0');
   signal need_wb_ex : std_logic := '0';
   signal op_mem_ex : std_logic_vector(1 downto 0) := (others => '0');
   signal r1_data : std_logic_vector(15 downto 0) := (others => '0');
   signal r2_data : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal correctpc : std_logic_vector(15 downto 0);
   signal b_need : std_logic;
   signal b_pc : std_logic_vector(15 downto 0);
   signal need_predict : std_logic_vector(1 downto 0);
   signal a : std_logic_vector(15 downto 0);
   signal a_addr : std_logic_vector(3 downto 0);
   signal b : std_logic_vector(15 downto 0);
   signal b_addr : std_logic_vector(3 downto 0);
   signal imm : std_logic_vector(15 downto 0);
   signal a_imm : std_logic;
   signal b_imm : std_logic;
   signal op_alu : std_logic_vector(2 downto 0);
   signal op_mem : std_logic_vector(1 downto 0);
   signal need_wb : std_logic;
   signal wb_addr : std_logic_vector(3 downto 0);
   signal r1_addr : std_logic_vector(3 downto 0);
   signal r2_addr : std_logic_vector(3 downto 0);
   signal r1_need : std_logic;
   signal r2_need : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut1: id PORT MAP (
          rst => rst,
          clk => clk,
          inst => inst,
          nextpc => nextpc,
          correctpc => correctpc,
          last_predict => last_predict,
          b_need => b_need,
          b_pc => b_pc,
          need_predict => need_predict,
          a => a,
          a_addr => a_addr,
          b => b,
          b_addr => b_addr,
          imm => imm,
          a_imm => a_imm,
          b_imm => b_imm,
          op_alu => op_alu,
          op_mem => op_mem,
          need_wb => need_wb,
          wb_addr => wb_addr,
          wb_addr_ex => wb_addr_ex,
          need_wb_ex => need_wb_ex,
          op_mem_ex => op_mem_ex,
          r1_addr => r1_addr,
          r2_addr => r2_addr,
          r1_data => r1_data,
          r2_data => r2_data,
          r1_need => r1_need,
          r2_need => r2_need
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
      
      -- insert stimulus here 
         inst <= "0010011111111110"; --BEQZ rx(111) imm(-2)
         nextpc <= "0100000000000000"; --pc = 0x4000, jump pc = 0x3fff
         last_predict  <= '1';
         wb_addr_ex <= "0001"; -- last wb = r1
         need_wb_ex <= '1'; --last need wb = '1'
         op_mem_ex <= MEM_NOP;
			r1_data <= "0000111111111110";
         r2_data <= (others => '0');
      wait;
   end process;

END;
