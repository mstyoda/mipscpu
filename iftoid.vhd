----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:06:53 11/18/2017 
-- Design Name: 
-- Module Name:    iftoid - Behavioral 
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
use cpu_constant.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity iftoid is
	Port (
				rst : in STD_LOGIC;
				clk : in STD_LOGIC;
				stall : in STD_LOGIC_VECTOR(4 downto 0);
					
				nextpc_if: in STD_LOGIC_VECTOR(15 downto 0);
				nextpc_id: out STD_LOGIC_VECTOR(15 downto 0);
					
				inst_if: in STD_LOGIC_VECTOR(15 downto 0);
				inst_id: out STD_LOGIC_VECTOR(15 downto 0)
			  );
end iftoid;

architecture Behavioral of iftoid is
signal state:integer :=5;
begin

process(rst,clk)
	begin
		if (rst='0') then
			state<=5;
		elsif (clk'event and clk = '1') then
			case state is 
				when 1=>
					state<=2;
				when 2=>
					state<=3;
				when 3=>
					state<=4;
				when 4=>
					if (stall(1)='0') then
						nextpc_id<=nextpc_if;
						inst_id<=inst_if;
					elsif (stall(2)='0') then
						nextpc_id<=ZERO16;
						inst_id<=INST_NOP;
					end if;
					state<=1;
				when 5=>
					nextpc_id<=ZERO16;
					inst_id<=INST_NOP;
					state<=1;
				when others=>
					state<=1;
			end case;
		end if;
		
	end process;
end Behavioral;

