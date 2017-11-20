----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:08:20 11/18/2017 
-- Design Name: 
-- Module Name:    mem - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use my_lib.cpu_constant.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem is
	Port (
					rst : in STD_LOGIC;
					clk : in STD_LOGIC;
					
					answer: in STD_LOGIC_VECTOR(15 downto 0);
					addr: in STD_LOGIC_VECTOR(15 downto 0);
					op_mem: in std_logic_vector(1 downto 0);
					
					ram1addr : out  STD_LOGIC_VECTOR (17 downto 0);
					ram1data : inout  STD_LOGIC_VECTOR (15 downto 0);
					ram1oe : out  STD_LOGIC;
					ram1we : out  STD_LOGIC;
					ram1en : out  STD_LOGIC;
					ram2addr : out  STD_LOGIC_VECTOR (17 downto 0);
					ram2data : inout  STD_LOGIC_VECTOR (15 downto 0);
					ram2oe : out  STD_LOGIC;
					ram2we : out  STD_LOGIC;
					ram2en : out  STD_LOGIC;
					data_ready : in  STD_LOGIC;
					rdn : out  STD_LOGIC;
					tbre : in  STD_LOGIC;
					tsre : in  STD_LOGIC;
					wrn : out  STD_LOGIC;
					usemem: out STD_LOGIC;
					
					wb_data: out STD_LOGIC_VECTOR(15 downto 0)
			  );
end mem;

architecture Behavioral of mem is

signal state: integer:=4;
signal useram1: std_logic;
signal useram : std_logic;
signal readen : std_logic;
signal term   : std_logic;

begin
process(rst,clk)
begin
	if (rst='0') then
		usemem<='1';
		ram1oe<='1';
		ram1we<='1';
		ram1en<='1';
		ram1addr<="00" & ZERO16;
		ram1data<=(others => 'Z');
		ram2oe<='1';
		ram2we<='1';
		ram2en<='1';
		ram2addr<="00" & ZERO16;
		ram2data<=(others => 'Z');
		rdn<='1';
		wrn<='1';
		state<=4;
	elsif (clk'event and clk='1') then
		case state is
			when 1 =>
				if (useram = '1') then
					if (useram1 ='1') then
						case addr is --用ram1
							when x"bf00" => 
								if (readen = '1') then
									rdn <= '0'; --ram1读串口，此时dataready为1
								else
									wrn <= '0';
									ram1data <= "00000000" & answer(7 downto 0); --ram1写串口，此时tbre和tsre为0
								end if;
								
							when x"bf01" =>
								wb_data <= "00000000000000" & (data_ready) & (not(tbre or tsre)); --读bf01
								term<='1'; -- wbdata已赋值
							when others =>
					
								if (readen = '1') then
									ram1en<='0';
									ram1oe<='0';
									ram1addr<="00" & addr;
									ram1data<=(others=>'Z');
								else
									ram1en<='0';
									ram1we<='0';
									ram1addr<="00" & addr;
									ram1data<=answer;
								end if;
						end case;
					else
						ram2en<='0'; --涉及到ram2一定是写指令
						ram2we<='0';
						ram2data<=answer;
						ram2addr<="00" & addr;
					end if;
				end if;
				state<=2;
			when 2 =>
				state<=3; -- 等待
			when 3 =>
			
				if (useram='0') then
					wb_data<=answer; --不使用ram，那一定是直接写回
				else
					if (term='0') then
						wb_data<=ram1data; --使用ram，且term为0，若需要写回，那一定是load指令，值一定在ram1中。
					end if;
				end if;
				
				ram1oe<='1';
				ram1we<='1';
				ram1en<='1';
				ram2oe<='1';
				ram2we<='1';
				ram2en<='1';
				rdn<='1';
				wrn<='1';
				state<=4;
			when 4 =>
				term<='0';
				ram1data<=(others=>'Z');
				ram2data<=(others=>'Z'); --初始化ram的data，设置为高阻态
				case op_mem is
					when MEM_READ =>
						readen <='1';
						useram1<='1';
						useram <='1';
						usemem <='0'; --用ram1读内存
					when MEM_WRITE =>
						if (addr >= "1000000000000000") then
							useram1<='1';
							usemem <='0'; --用ram1写数据
						else
							useram1<='0'; --用ram2写指令
							usemem <='1';
						end if;
						useram <='1';
						readen <='0'; 
					when others =>
						useram <='0';
				end case;
				state<=1;
			when others =>
				state<=1;
		end case;
	end if;
end process;

end Behavioral;

