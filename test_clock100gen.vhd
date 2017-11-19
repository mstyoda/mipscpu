--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:02:40 11/19/2017
-- Design Name:   
-- Module Name:   F:/isep/mipscpu/test_clock100gen.vhd
-- Project Name:  mipscpu
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clock100gen
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_clock100gen IS
END test_clock100gen;
 
ARCHITECTURE behavior OF test_clock100gen IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock100gen
    PORT(
         clk50 : IN  std_logic;
         clk100 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk50 : std_logic := '0';

 	--Outputs
   signal clk100 : std_logic;

   -- Clock period definitions
   constant clk50_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clock100gen PORT MAP (
          clk50 => clk50,
          clk100 => clk100
        );

   -- Clock process definitions
   clk50_process :process
   begin
		clk50 <= '0';
		wait for clk50_period/2;
		clk50 <= '1';
		wait for clk50_period/2;
   end process;


END;
