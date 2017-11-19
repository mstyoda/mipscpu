----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:39 11/18/2017 
-- Design Name: 
-- Module Name:    reg - Behavioral 
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

entity reg is
	Port (
				rst : in STD_LOGIC;
				clk : in STD_LOGIC;
					
				need_wb: in STD_LOGIC;
				wb_addr: in STD_LOGIC_VECTOR(3 downto 0);
				wb_data: in STD_LOGIC_VECTOR(15 downto 0);
					
				r1_need: in STD_LOGIC;
				r2_need: in STD_LOGIC;
				r1_addr: in STD_LOGIC_VECTOR(3 downto 0);
				r2_addr: in STD_LOGIC_VECTOR(3 downto 0);
				r1_data: out STD_LOGIC_VECTOR(15 downto 0);
				r2_data: out STD_LOGIC_VECTOR(15 downto 0)
			  );
end reg;

architecture Behavioral of reg is
signal r0 : std_logic_vector(15 downto 0);
signal r1 : std_logic_vector(15 downto 0);
signal r2 : std_logic_vector(15 downto 0);
signal r3 : std_logic_vector(15 downto 0);
signal r4 : std_logic_vector(15 downto 0);
signal r5 : std_logic_vector(15 downto 0);
signal r6 : std_logic_vector(15 downto 0);
signal r7 : std_logic_vector(15 downto 0);
signal T  : std_logic_vector(15 downto 0);
signal SP : std_logic_vector(15 downto 0);
signal IH : std_logic_vector(15 downto 0);

begin
	process(r2_need,r2_addr,need_wb,wb_addr,wb_data)
	begin
		if (r2_need='0') then 
			r2_data<=ZERO16;
		else
			if (r2_addr=wb_addr and need_wb='1') then
				r2_data<=wb_data;
			else
				case r2_addr is
					when "0000" => r2_data<=r0;
					when "0001" => r2_data<=r1;
					when "0010" => r2_data<=r2;
					when "0011" => r2_data<=r3;
					when "0100" => r2_data<=r4;
					when "0101" => r2_data<=r5;
					when "0110" => r2_data<=r6;
					when "0111" => r2_data<=r7;
					when "1000" => r2_data<=T;
					when "1001" => r2_data<=SP;
					when "1010" => r2_data<=IH;
					when others => r2_data<=ZERO16;
				end case;
			end if;
		end if;
	end process;
	
	process(r1_need,r1_addr,need_wb,wb_addr,wb_data)
	begin
		if (r1_need='1') then -- 1 means no!
			r1_data<=ZERO16;
		else
			if (r1_addr=wb_addr and need_wb='1') then
				r1_data<=wb_data;
			else
				case r1_addr is
					when "0000" => r1_data<=r0;
					when "0001" => r1_data<=r1;
					when "0010" => r1_data<=r2;
					when "0011" => r1_data<=r3;
					when "0100" => r1_data<=r4;
					when "0101" => r1_data<=r5;
					when "0110" => r1_data<=r6;
					when "0111" => r1_data<=r7;
					when "1000" => r1_data<=T;
					when "1001" => r1_data<=SP;
					when "1010" => r1_data<=IH;
					when others => r1_data<=ZERO16;
				end case;
			end if;
		end if;
	end process;
	
	process(rst,clk)
	begin
		if (rst='0') then
			r0<=ZERO16;
			r1<=ZERO16;
			r2<=ZERO16;
			r3<=ZERO16;
			r4<=ZERO16;
			r5<=ZERO16;
			r6<=ZERO16;
			r7<=ZERO16;
			T <=ZERO16;
			SP<=ZERO16;
			IH<=ZERO16;
			state<=4;
		elsif (clk'event and clk='1') then
			case state is
				when 1 =>
					state<=2;
				when 2 =>
					state<=3;
				when 3 =>
					state<=4;
				when 4 =>
					if (need_wb='1') then
						case wb_addr is
							when "0000" => r0<=wb_data;
							when "0001" => r1<=wb_data;
							when "0010" => r2<=wb_data;
							when "0011" => r3<=wb_data;
							when "0100" => r4<=wb_data;
							when "0101" => r5<=wb_data;
							when "0110" => r6<=wb_data;
							when "0111" => r7<=wb_data;
							when "1000" => T <=wb_data;
							when "1001" => SP<=wb_data;
							when "1010" => IH<=wb_data;
							when others => 
						end case;
					end if;
					state<=1;
				when others =>
					state<=1;
			end case;
		end if;
	end process;

end Behavioral;

