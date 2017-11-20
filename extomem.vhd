----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:47 11/18/2017 
-- Design Name: 
-- Module Name:    extomem - Behavioral 
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
library IEEE,my_lib;
use IEEE.STD_LOGIC_1164.ALL;
use my_lib.cpu_constant.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity extomem is
	Port (
					rst : in STD_LOGIC;
					clk : in STD_LOGIC;
					stall : in STD_LOGIC_VECTOR(4 downto 0);
					
					answer_ex: in STD_LOGIC_VECTOR(15 downto 0);
					answer_mem: out STD_LOGIC_VECTOR(15 downto 0);
					addr_ex: in STD_LOGIC_VECTOR(15 downto 0);
					addr_mem: out STD_LOGIC_VECTOR(15 downto 0);
					
					op_mem_ex: in std_logic_vector(1 downto 0);
					op_mem_mem: out std_logic_vector(1 downto 0);
					
					need_wb_ex: in STD_LOGIC; 
					need_wb_mem:  out STD_LOGIC;
					wb_addr_ex: in STD_LOGIC_VECTOR(3 downto 0);
					wb_addr_mem: out STD_LOGIC_VECTOR(3 downto 0);
					
					r_data_mem: out STD_LOGIC_VECTOR(15 downto 0);
					r_addr_mem: out STD_LOGIC_VECTOR(3 downto 0);
					r_need_mem: out STD_LOGIC
			  );
begin

end extomem;

architecture Behavioral of extomem is
signal state : integer := 1;
begin
	process(rst,clk)
		begin
			if (rst='0' or (stall(3)=STOP and stall(4)=NOSTOP)) then
			--set nop
				answer_mem <= ZERO16;
				addr_mem <= ZERO16;
				op_mem_mem <= "00";
				need_wb_mem <= '0';
				wb_addr_mem <= "0000";
				r_data_mem <= ZERO16;
				r_addr_mem <= "0000";
				r_need_mem <= '0';
			elsif  stall(3)=STOP then
			
			elsif (clk'event and clk = '1') then
				case state is 
					when 1=>
						state<=2;
					when 2=>
						state<=3;
					when 3=>
						state<=4;
					when 4=>
						answer_mem <= answer_ex;
						addr_mem <= addr_ex;
						op_mem_mem <= op_mem_ex;
						need_wb_mem <= need_wb_ex;
						wb_addr_mem <= wb_addr_ex;
						r_data_mem <= answer_ex;
						r_addr_mem <= addr_ex;--TODO: need change!!!!!
						r_need_mem <= need_wb_ex;
						state<=1;
					when others=>
						state<=1;
				end case;
			end if;
			
		end process;
end Behavioral;

