----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:06:20 11/18/2017 
-- Design Name: 
-- Module Name:    ifram - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_arith.all;
USE ieee.std_logic_signed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ifram is
	Port ( 
			 rst : in STD_LOGIC;
			 clk : in STD_LOGIC;
			 pause : in STD_LOGIC;
			 pc_pc: in STD_LOGIC_VECTOR(15 downto 0);
			 b_need_id: in STD_LOGIC;
		 	 b_pc_id: in STD_LOGIC_VECTOR(15 downto 0);
		     b_need_ex: in STD_LOGIC;
			 b_pc_ex: in STD_LOGIC_VECTOR(15 downto 0);
					
			 nextpc: out STD_LOGIC_VECTOR(15 downto 0);
			 inst: out STD_LOGIC_VECTOR(15 downto 0);
					
			 ram2addr : out  STD_LOGIC_VECTOR (17 downto 0);
			 ram2data : inout  STD_LOGIC_VECTOR (15 downto 0);
			 ram2oe : out  STD_LOGIC;
			 ram2we : out  STD_LOGIC;
			 ram2en : out  STD_LOGIC;
			 useif : out STD_LOGIC
		   );
end ifram;

architecture Behavioral of ifram is

signal state:integer :=0;
signal realpc: std_logic_vector(15 downto 0);
begin

process(rst,clk)
begin
	if (rst='0') then
		state<=4;
	elsif (clk'event and clk='1') then
		case state is
			when 1 =>
				if (pause='0') then
					ram2addr<="00"&realpc;
					ram2data<=(others => 'Z');
					ram2oe<='0';
					ram2en<='0';
					useif<='1';
				else
					useif<='0';
				end if;
				state<=2;
			when 2 =>
				state<=3;
			when 3 =>
				if (pause='0') then
					inst<=ram2data;
					nextpc<=realpc;
				end if;
				state<=4;
			when 4 =>
				if (b_need_ex='1') then
					realpc<=b_pc_ex;
				elsif (b_need_id='1') then
					realpc<=b_pc_id;
				else
					realpc<=pc_pc;
				end if;
				state<=1;
			when others =>
				state<=1;
		end case;
	end if;
end process;

end Behavioral;

