----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:48 11/18/2017 
-- Design Name: 
-- Module Name:    ctrl - Behavioral 
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

entity ctrl is
	Port (
					rst : in STD_LOGIC;
					stallreq_id: in STD_LOGIC;
					stallreq_ex: in STD_LOGIC;
					stall : out STD_LOGIC_VECTOR(5 downto 0) --modify
			);
end ctrl;

architecture Behavioral of ctrl is

begin
process(rst,stallreq_id,stallreq_ex)
		begin
			if (rst='0') then
				stall	<= "000000";
			elsif (stallreq_id=STOP) then
				stall <= "001111";
			elsif (stallreq_ex=STOP) then
				stall <= "000111";
			else
				stall <= "000000";
			end if;
		end process;

end Behavioral;

