----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:13 11/18/2017 
-- Design Name: 
-- Module Name:    id - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity id is
	Port (
			 rst : in STD_LOGIC;
			 clk : in STD_LOGIC;
			 
			 inst: in STD_LOGIC_VECTOR(15 downto 0);
			 nextpc: in STD_LOGIC_VECTOR(15 downto 0);
			 
			 correctpc: out STD_LOGIC_VECTOR(15 downto 0);
			 predict: in STD_LOGIC;
			 b_need : out STD_LOGIC;
			 b_pc: out STD_LOGIC_VECTOR(15 downto 0);
			 need_predict: out std_logic_vector(1 downto 0);
			 
			 a: out STD_LOGIC_VECTOR(15 downto 0);
			 a_addr: out STD_LOGIC_VECTOR(3 downto 0);
			 b: out STD_LOGIC_VECTOR(15 downto 0);
			 b_addr: out STD_LOGIC_VECTOR(3 downto 0);
			 imm: out STD_LOGIC_VECTOR(15 downto 0);
			 a_imm: out STD_LOGIC;
			 b_imm: out STD_LOGIC;
			 
			 op_alu: out std_logic_vector(2 downto 0); 
			 op_mem: out std_logic_vector(1 downto 0);
			 need_wb: out STD_LOGIC;
			 wb_addr: out STD_LOGIC_VECTOR(3 downto 0);
			 
			 wb_addr_ex: in STD_LOGIC_VECTOR(3 downto 0);
			 op_mem_ex: in std_logic_vector(1 downto 0);
			 
			 r1_addr: out STD_LOGIC_VECTOR(3 downto 0);
			 r2_addr: out STD_LOGIC_VECTOR(3 downto 0);
			 r1_data: in STD_LOGIC_VECTOR(15 downto 0);
			 r2_data: in STD_LOGIC_VECTOR(15 downto 0);
			 r1_need: out STD_LOGIC;
			 r2_need: out STD_LOGIC;
			 
			 stallreq: out STD_LOGIC
			  );
end id;

architecture Behavioral of id is

begin


end Behavioral;

