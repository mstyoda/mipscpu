--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
package cpu_constant is

constant ALU_ADD : std_logic_vector(2 downto 0):= "000";
constant ALU_AND : std_logic_vector(2 downto 0):= "001";
constant ALU_SUB : std_logic_vector(2 downto 0):= "010";
constant ALU_SLL : std_logic_vector(2 downto 0):= "011";
constant ALU_SRA : std_logic_vector(2 downto 0):= "100";
constant ALU_SRL : std_logic_vector(2 downto 0):= "101";
constant ALU_OR : std_logic_vector(2 downto 0):= "110";
constant ALU_NOP : std_logic_vector(2 downto 0):= "111";


constant MEM_NOP: std_logic_vector(1 downto 0):= "00";
constant MEM_READ: std_logic_vector(1 downto 0):= "01";
constant MEM_WRITE: std_logic_vector(1 downto 0):= "10";


constant PREDICT_NOP: std_logic_vector(1 downto 0):= "00";
constant PREDICT_EZ: std_logic_vector(1 downto 0):= "01";
constant PREDICT_NZ: std_logic_vector(1 downto 0):= "10";
constant PREDICT_JR: std_logic_vector(1 downto 0):= "11";

constant PREDICT_WRONG: std_logic := '0';
constant PREDICT_CORRECT: std_logic := '1';

constant INST_NOP : std_logic_vector(15 downto 0):="0000100000000000";
constant ZERO16 :   std_logic_vector(15 downto 0):="0000000000000000";
constant ONES16 :   std_logic_vector(15 downto 0):="0000000000000001";
constant ZERO8 :   std_logic_vector(7 downto 0):="00000000";

constant OX7FFF :   std_logic_vector(15 downto 0):="0111111111111111";


constant INST_OPT_ADDIU: std_logic_vector(4 downto 0) := "01001";
constant INST_OPT_ADDIU3: std_logic_vector(4 downto 0) := "01000";
constant INST_OPT_ADDSP_BTEQZ_MTSP_BTNEZ: std_logic_vector(4 downto 0) := "01100";
constant INST_OPT_ADDU_SUBU: std_logic_vector(4 downto 0) := "11100";
constant INST_OPT_AND_CMP_JR_MFPC_OR_NEG: std_logic_vector(4 downto 0) := "11101";
constant INST_OPT_B: std_logic_vector(4 downto 0) := "00010";
constant INST_OPT_BEQZ: std_logic_vector(4 downto 0) := "00100";
constant INST_OPT_BNEZ: std_logic_vector(4 downto 0) := "00101";
constant INST_OPT_LI: std_logic_vector(4 downto 0) := "01101";
constant INST_OPT_LW: std_logic_vector(4 downto 0) := "10011";
constant INST_OPT_LW_SP: std_logic_vector(4 downto 0) := "10010";
constant INST_OPT_MFIH_MTIH: std_logic_vector(4 downto 0) := "11110";
constant INST_OPT_NOP: std_logic_vector(4 downto 0) := "00001";
constant INST_OPT_SLL_SRA_SRL: std_logic_vector(4 downto 0) := "00110";
constant INST_OPT_SW: std_logic_vector(4 downto 0) := "11011";
constant INST_OPT_SW_SP: std_logic_vector(4 downto 0) := "11010";
constant INST_OPT_MOVE: std_logic_vector(4 downto 0) := "01111";
constant INST_OPT_ADDSP3: std_logic_vector(4 downto 0) := "00000";



-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end cpu_constant;

package body cpu_constant is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end cpu_constant;
