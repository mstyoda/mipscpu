----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:57:18 11/18/2017 
-- Design Name: 
-- Module Name:    memtowb - Behavioral 
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
use my_lib.cpu_constant.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memtowb is
	Port (
					rst : in STD_LOGIC;
					clk : in STD_LOGIC;
					stall : in STD_LOGIC_VECTOR(4 downto 0);
					
					wb_data_mem: in STD_LOGIC_VECTOR(15 downto 0);
					wb_data_wb: out STD_LOGIC_VECTOR(15 downto 0);
					wb_addr_mem: in STD_LOGIC_VECTOR(3 downto 0);
					wb_addr_wb: out STD_LOGIC_VECTOR(3 downto 0);
					need_wb_mem: in STD_LOGIC;
					need_wb_wb: out STD_LOGIC;
					
					r_data_wb: out STD_LOGIC_VECTOR(15 downto 0);
					r_addr_wb: out STD_LOGIC_VECTOR(3 downto 0);
					r_need_wb: out STD_LOGIC
			  );
end memtowb;

architecture Behavioral of memtowb is
begin
	process(rst,clk)
		begin
			if (rst='0') then
			--set nop
				wb_data_wb <= ZERO16;
				wb_addr_wb <= "0000";
				need_wb_wb <= '0';
				r_data_wb <= ZERO16;
				r_addr_wb <= "0000";
				r_need_wb <= '0';
			elsif  stall(4)=STOP then
			
			elsif (clk'event and clk = '1') then
				case state is 
					when 1=>
						state<=2;
					when 2=>
						state<=3;
					when 3=>
						state<=4;
					when 4=>
						wb_data_wb <= wb_data_mem;
						wb_addr_wb <= wb_addr_mem;
						need_wb_wb <= need_wb_mem;
						r_data_wb <= wb_data_mem;
						r_addr_wb <= wb_addr_mem;
						r_need_wb <= need_wb_mem;
						state<=1;
					when others=>
						state<=1;
				end case;
			end if;
		end process;
end Behavioral;

