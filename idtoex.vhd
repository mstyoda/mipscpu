----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:25 11/18/2017 
-- Design Name: 
-- Module Name:    idtoex - Behavioral 
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

entity idtoex is
	Port (
					rst : in STD_LOGIC;
					clk : in STD_LOGIC;
					stall : in STD_LOGIC_VECTOR(4 downto 0);
					
					op_alu_id: in std_logic_vector(2 downto 0);
					op_alu_ex: out std_logic_vector(2 downto 0);
					a_id: in STD_LOGIC_VECTOR(15 downto 0);
					a_ex: out STD_LOGIC_VECTOR(15 downto 0);
					a_addr_id: in STD_LOGIC_VECTOR(3 downto 0);
					a_addr_ex: out STD_LOGIC_VECTOR(3 downto 0);
					b_id: in STD_LOGIC_VECTOR(15 downto 0);
					b_ex: out STD_LOGIC_VECTOR(15 downto 0);
					b_addr_id: in STD_LOGIC_VECTOR(3 downto 0);
					b_addr_ex: out STD_LOGIC_VECTOR(3 downto 0);
					imm_id: in STD_LOGIC_VECTOR(15 downto 0);
					imm_ex: out STD_LOGIC_VECTOR(15 downto 0);
					a_imm_id: in STD_LOGIC;
					a_imm_ex: out STD_LOGIC;
					b_imm_id: in STD_LOGIC;
					b_imm_ex: out STD_LOGIC;
					
					op_mem_id: in std_logic_vector(1 downto 0);
					op_mem_ex: out std_logic_vector(1 downto 0);
					need_wb_id: in STD_LOGIC;
					need_wb_ex: out STD_LOGIC;
					wb_addr_id: in STD_LOGIC;
					wb_addr_ex: out STD_LOGIC;
					
					correctpc_id: in STD_LOGIC_VECTOR(15 downto 0);
					correctpc_ex: out STD_LOGIC_VECTOR(15 downto 0);
					need_predict_id: in std_logic_vector(1 downto 0);
					need_predict_ex: out std_logic_vector(1 downto 0); --modify
					
					nop_last_ex: in STD_LOGIC
			  );
end idtoex;

architecture Behavioral of idtoex is

begin
	process(rst,clk)
	begin
		if (rst='0' or nop_last_ex='1' or (stall(2)=STOP and stall(3)=NOSTOP)) then
		-- rst£¬²åÆøÅÝÊ±£¬ÖÃÎªnop
			op_alu_ex <= ALU_NOP;
			a_ex <= ZERO16 ;
			a_addr_ex <= "0000";
			b_ex <= ZERO16 ;
			b_addr_ex <= "0000";
			imm_ex <= ZERO16 ;
			a_imm_ex <= '0';
			b_imm_ex <= '0';
			op_mem_ex <= "00";
			need_wb_ex <= '0';
			wb_addr_ex <= '0';
			correctpc_ex <= ZERO16 ;
			need_predict_ex <= "00";
		elsif (stall(2)=STOP) then
			
		elsif (clk'event and clk='1') then
			case state is
				when 1 =>
					state<=2;
				when 2 =>
					state<=3;
				when 3 =>
					state<=4;
				when 4 =>
					op_alu_ex <= op_alu_id;
					a_ex <= a_id;
					a_addr_ex <= a_addr_id;
					b_ex <= b_id;
					b_addr_ex <= b_addr_id;
					imm_ex <= imm_id;
					a_imm_ex <= a_imm_id;
					b_imm_ex <= b_imm_id;
					op_mem_ex <= op_mem_id;
					need_wb_ex <= need_wb_id;
					wb_addr_ex <= wb_addr_id;
					correctpc_ex <= correctpc_id;
					need_predict_ex <= need_predict_id;
					state<=1;
				when others =>
					state<=1;
			end case;
		end if;
	end process;

end Behavioral;

