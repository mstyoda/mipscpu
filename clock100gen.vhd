----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:59:26 11/19/2017 
-- Design Name: 
-- Module Name:    clock100gen - Behavioral 
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

entity clock100gen is
    Port ( clk50 : in  STD_LOGIC;
           clk100 : out STD_LOGIC
			 );
end clock100gen;

architecture Behavioral of clock100gen is
component dcm is
   port ( CLKIN_IN        : in    std_logic; 
          RST_IN          : in    std_logic; 
          CLKIN_IBUFG_OUT : out   std_logic; 
          CLK0_OUT        : out   std_logic; 
          CLK2X_OUT       : out   std_logic; 
          LOCKED_OUT      : out   std_logic);
end COMPONENT;

signal clk0: std_logic;
signal clk100out: std_logic;
signal locked :std_logic;
signal clkbff: std_logic;
signal rstin: std_logic := '0';

begin
	dfs: dcm port map(
		CLKIN_IN => clk50,
		RST_IN => rstin,
      CLKIN_IBUFG_OUT => clkbff, 
      CLK0_OUT=>clk0, 
      CLK2X_OUT=>clk100out, 
      LOCKED_OUT=>locked
	);
	clk100 <= locked and clk100out;
end Behavioral;
