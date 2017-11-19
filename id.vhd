----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:13 11/18/2017 
-- Design Name: 
-- Module Name:    id - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use my_lib.cpu_constant.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity id is
	Port (
			 rst : in STD_LOGIC;
			 clk : in STD_LOGIC;
			 
			 inst: in STD_LOGIC_VECTOR(15 downto 0);
			 nextpc: in STD_LOGIC_VECTOR(15 downto 0);

			 correctpc: out STD_LOGIC_VECTOR(15 downto 0);
			 last_predict: in STD_LOGIC;
			 b_need : out STD_LOGIC;
			 b_pc: out STD_LOGIC_VECTOR(15 downto 0);
			 need_predict: out std_logic_vector(1 downto 0);

			 a: out STD_LOGIC_VECTOR(15 downto 0);
			 a_addr: out STD_LOGIC_VECTOR(3 downto 0);
			 b: out STD_LOGIC_VECTOR(15 downto 0);
			 b_addr: out STD_LOGIC_VECTOR(3 downto 0);
			 imm: out STD_LOGIC_VECTOR(15 downto 0);
			 a_imm: out STD_LOGIC;
			 b_imm: out STD_LOGIC;
			 
			 op_alu: out std_logic_vector(2 downto 0); 
			 op_mem: out std_logic_vector(1 downto 0);
			 need_wb: out STD_LOGIC;
			 wb_addr: out STD_LOGIC_VECTOR(3 downto 0);
			 
			 wb_addr_ex: in STD_LOGIC_VECTOR(3 downto 0);
			 need_wb_ex: in std_logic;
			 op_mem_ex: in std_logic_vector(1 downto 0);
			 
			 r1_addr: out STD_LOGIC_VECTOR(3 downto 0); --connect to regs
			 r2_addr: out STD_LOGIC_VECTOR(3 downto 0); --connect to regs
			 r1_data: in STD_LOGIC_VECTOR(15 downto 0); --connect to regs
			 r2_data: in STD_LOGIC_VECTOR(15 downto 0); --connect to regs
			 r1_need: out STD_LOGIC;
			 r2_need: out STD_LOGIC--
			 
			 --stallreq: out STD_LOGIC
			  );
end id;

architecture Behavioral of id is

signal state : integer := 1;
signal save_a : std_logic_vector(15 downto 0);
signal save_b : std_logic_vector(15 downto 0);
signal save_a_addr: std_logic_vector(3 downto 0);
signal save_b_addr: std_logic_vector(3 downto 0);
signal save_a_imm: STD_LOGIC;
signal save_imm : STD_LOGIC_VECTOR(15 downto 0);
signal save_b_imm: STD_LOGIC;
signal save_op_alu: STD_LOGIC_VECTOR(2 downto 0);
signal save_op_mem: STD_LOGIC_VECTOR(1 downto 0);
signal save_r1_need: STD_LOGIC;
signal save_r2_need: STD_LOGIC;
signal save_wb_addr: STD_LOGIC_VECTOR(3 downto 0);
signal save_need_wb: STD_LOGIC;
signal save_is_jump: STD_LOGIC := '1';
signal isNOP: STD_LOGIC;

begin

	process (rst,clk) is
	begin
		if (rst = '0') then
			state <= 1;
		elsif (clk'event and clk = '1') then 
			case state is
				when 1 =>
					--If LAST instruction is LW, and its wb_addr = ra or rb
					-------Decode this inst to B PC (set b_need, b_pc = this_pc)
					--ELSE prepare ra rb from REG
					case inst(15 downto 11) is
						when INST_OPT_ADDIU =>
							--ADDIU rx(10~8) immediate(7~0)
							--rx = rx + imm
							if ((need_wb_ex = '1') and (wb_addr_ex = ("0" & inst(10 downto 8))) and (op_mem_ex = MEM_READ)) then
							----is LW,and wb_addr has conflict
								b_need <='1';
								b_pc <= nextpc;
								isNOP <= '1';
								need_predict <= PREDICT_NOP;
							else
								----ask register for r1
								save_r1_need <= '1'; r1_need <= '1';
								r1_addr <= '0' & inst(10 downto 8);
								save_a_addr <= '0' & inst(10 downto 8);
								save_r2_need <= '0'; r2_need <= '0';
								save_b_imm <= '1';
								save_imm <= SXT(inst(7 downto 0), save_imm'length); --sign_extend
								save_op_alu <= ALU_ADD;
								save_op_mem <= MEM_NOP;
								save_need_wb <= '1';
								save_wb_addr <= '0' & inst(10 downto 8);
								isNOP <= '0';
								need_predict <= PREDICT_NOP;
							end if;
						
						when INST_OPT_ADDIU3 =>
							--ADDIU3 rx(10~8),ry(7~5),imm(3~0)
							--ry = rx + imm
							if ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) then
								b_need <= '1';
								b_pc <= nextpc;
								isNOP <= '1';
								need_predict <= PREDICT_NOP;
							else
								----ask register for r1
								save_r1_need <= '1'; r1_need <= '1';
								r1_addr <= '0' & inst(10 downto 8);
								save_a_addr <= '0' & inst(10 downto 8);
								save_r2_need <= '0'; r2_need <= '0';
								save_b_imm <= '1';
								save_imm <= SXT(inst(7 downto 0), 16); --sign_extend
								save_op_alu <= ALU_ADD;
								save_op_mem <= MEM_NOP;
								save_need_wb <= '1';
								save_wb_addr <= '0' & inst(7 downto 5);
								isNOP <= '0';
								need_predict <= PREDICT_NOP;
							end if;

						when INST_OPT_ADDSP_BTEQZ_MTSP_BTNEZ =>
							--check (10 downto 8)
							case inst(10 downto 8) is
								when "011" => --ADDSP
									--ADDSP imm(7 downto 0)
									--SP = SP + imm
									if ((need_wb_ex = '1') and (wb_addr_ex = "1001") and (op_mem_ex = MEM_READ)) then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else
										----ask register for SP
										save_r1_need <= '1'; r1_need <= '1';
										r1_addr <= "1001";
										save_a_addr <= "1001";
										save_r2_need <= '0'; r2_need <= '0';
										save_b_imm <= '1';
										save_imm <= SXT(inst(7 downto 0),16); --sign_extend
										save_op_alu <= ALU_ADD;
										save_op_mem <= MEM_NOP;
										save_need_wb <= '1';
										save_wb_addr <= "1001";
										isNOP <= '0';
										need_predict <= PREDICT_NOP;
									end if;

								when "000" => --BTEQZ
									--BTEQZ imm(7 downto 0)
									--if (T==0) then PC = PC + sign_extend(imm)
									--****fen zhi yu ce***
									--****do same predict as last_jump****
									if (save_is_jump = '1') then--jump
										b_need <= '1';
										b_pc <= nextpc + ONES16 + SXT(inst(7 downto 0),16);
										need_predict <= PREDICT_NZ;--predict wrong condition
										correctpc <= nextpc;---to do
									else--not jump
										b_need <= '0';
										need_predict <= PREDICT_EZ;--predict wrong condition
										correctpc <= nextpc + ONES16 + SXT(inst(7 downto 0),16);
									end if;
									save_r1_need <= '1'; r1_need <= '1';
									r1_addr <= "1000";--T
									save_a_addr <= "1000";--T
									save_r2_need <= '0'; r2_need <= '0';
									save_imm <= ZERO16;
									save_b_imm <= '1';
									save_op_alu <= ALU_ADD;--use T + 0 to get T 
									save_op_mem <= MEM_NOP;
									save_need_wb <= '0';
									isNOP <= '0';

								when "100" => --MTSP
									--MTSP rx(7~5)
									--SP = R[x]
									if ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)) then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else
										----ask register for r1
										save_r1_need <= '1'; r1_need <= '1';
										r1_addr <= '0' & inst(7 downto 5); --rx
										save_a_addr <= '0' & inst(7 downto 5); --rx
										save_r2_need <= '0'; r2_need <= '0';
										save_b_imm <= '1';
										save_imm <= ZERO16;
										save_op_alu <= ALU_ADD; -- use r1 + 0 to get r1
										save_op_mem <= MEM_NOP;
										save_need_wb <= '1';
										save_wb_addr <= "1001";--sp
										isNOP <= '0';
										need_predict <= PREDICT_NOP;
									end if;

								when "001" => --BTNEZ
									--BTNEZ imm(7 ~ 0)
									--if (T != 0) then PC = PC + sign_extend(imm)
									--****fen zhi yu ce***
									--****do same predict as last_jump****
									if (save_is_jump = '1') then--jump
										b_need <= '1';
										b_pc <= nextpc + ONES16 + SXT(inst(7 downto 0),16);
										need_predict <= PREDICT_EZ;--predict wrong condition
										correctpc <= nextpc;---to do
									else--not jump
										b_need <= '0';
										need_predict <= PREDICT_NZ;--predict wrong condition
										correctpc <= nextpc + ONES16 + SXT(inst(7 downto 0),16);
									end if;
									save_r1_need <= '1'; r1_need <= '1';
									r1_addr <= "1000";--T
									save_a_addr <= "1000";--T
									save_r2_need <= '0'; r2_need <= '0';
									save_imm <= ZERO16;
									save_b_imm <= '1';
									save_op_alu <= ALU_ADD;--use T + 0 to get T 
									save_op_mem <= MEM_NOP;
									save_need_wb <= '0';
									isNOP <= '0';
								when others=> 
							end case;
						
						when INST_OPT_ADDU_SUBU =>
							case inst(1 downto 0) is
								when "01" => --ADDU TODO
									--ADDU rx(10-8) ry(7-5) rz(4-2)
									--R[z] = R[x] + R[y]
									if (((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) 
									   or ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)))
									then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else
										----ask register for r1,r2
										save_r1_need <= '1'; r1_need <= '1';
										r1_addr <= '0' & inst(10 downto 8); --rx
										save_a_addr <= '0' & inst(10 downto 8); --rx
										
										save_r2_need <= '1'; r2_need <= '1';
										r2_addr <= '0' & inst(7 downto 5); --ry
										save_b_addr <= '0' & inst(7 downto 5);
										
										save_b_imm <= '0';
										save_op_alu <= ALU_ADD; -- use rx + ry
										save_op_mem <= MEM_NOP;
										save_need_wb <= '1';
										save_wb_addr <= '0' & inst(4 downto 2); --rz
										isNOP <= '0';
										need_predict <= PREDICT_NOP;
									end if;

								when "11" => --SUBU TODO
									--SUBU rx(10-8) ry(7-5) rz(4-2)
									--R[z] = R[x] - R[y]
									if (((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) 
									   or ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)))
									then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else
										----ask register for r1,r2
										save_r1_need <= '1'; r1_need <= '1';
										r1_addr <= '0' & inst(10 downto 8); --rx
										save_a_addr <= '0' & inst(10 downto 8); --rx
										
										save_r2_need <= '1'; r2_need <= '1';
										r2_addr <= '0' & inst(7 downto 5); --ry
										save_b_addr <= '0' & inst(7 downto 5);
										
										save_b_imm <= '0';
										save_op_alu <= ALU_SUB; -- use rx - ry
										save_op_mem <= MEM_NOP;
										save_need_wb <= '1';
										save_wb_addr <= '0' & inst(4 downto 2); --rz
										isNOP <= '0';
										need_predict <= PREDICT_NOP;
									end if;
								when others=> 
							end case;

						when INST_OPT_AND_CMP_JR_MFPC_OR_NEG =>
							case inst(4 downto 0) is
								when "01100" => --AND TODO
									--AND rx(10-8) ry(7-5)
									--R[x] = R[x] and R[y]
									if (((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) 
									   or ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)))
									then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else
										----ask register for r1,r2
										save_r1_need <= '1'; r1_need <= '1';
										r1_addr <= '0' & inst(10 downto 8); --rx
										save_a_addr <= '0' & inst(10 downto 8); --rx
										
										save_r2_need <= '1'; r2_need <= '1';
										r2_addr <= '0' & inst(7 downto 5); --ry
										save_b_addr <= '0' & inst(7 downto 5);
										
										save_b_imm <= '0';
										save_op_alu <= ALU_AND; -- use rx & ry
										save_op_mem <= MEM_NOP;
										save_need_wb <= '1';
										save_wb_addr <= '0' & inst(10 downto 8); --rx
										isNOP <= '0';
										need_predict <= PREDICT_NOP;
									end if;

								when "01010" => --CMP TODO
									--CMP rx(10-8) ry(7-5)
									--if R[x] =  R[y] then T = 0
									--if R[x] != R[y] then T = 1
									if (((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) 
									   or ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)))
									then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else
										----ask register for r1,r2
										save_r1_need <= '1'; r1_need <= '1';
										r1_addr <= '0' & inst(10 downto 8); --rx
										save_a_addr <= '0' & inst(10 downto 8); --rx
										
										save_r2_need <= '1'; r2_need <= '1';
										r2_addr <= '0' & inst(7 downto 5); --ry
										save_b_addr <= '0' & inst(7 downto 5);
										
										save_b_imm <= '0';
										save_op_alu <= ALU_SUB; -- use rx & ry
										save_op_mem <= MEM_NOP;
										save_need_wb <= '1';
										save_wb_addr <= "1000"; --T
										isNOP <= '0';
										need_predict <= PREDICT_NOP;
									end if;

								when "00000" => --JR,MFPC
									case inst(7 downto 5) is
										when "000" => --JR TODO
											--JR rx(10-8)
											--PC = R[x]
											need_predict <= PREDICT_JR; --set jump condition = EZ
											save_r1_need <= '1';  r1_need <= '1';
											r1_addr <= '0' & inst(10 downto 8); --rx
											save_a_addr <= '0' & inst(10 downto 8); --rx

											save_r2_need <= '0'; r2_need <= '0';
											save_b_imm <= '0';
											save_op_alu <= ALU_NOP;
											save_op_mem <= MEM_NOP;
											save_need_wb <= '0';
											isNOP <= '0';

										when "010" => --MFPC TODO
											--MFPC rx(10-8)
											--R[x] = PC
											save_r1_need <= '1'; r1_need <= '1'; --set r1 = 0
											r1_addr <= "1111"; save_a_addr <= "1111";

											save_r2_need <= '0'; r2_need <= '0'; --no need r2

											save_b_imm <= '1';
											save_imm <= nextpc + ONES16;
											save_op_alu <= ALU_ADD; --use r1( = 0) + imm to get PC + 1
											save_op_mem <= MEM_NOP;
											save_need_wb <= '1';
											save_wb_addr <= '0' & inst(10 downto 8);
											isNOP <= '0';

										when others=> 
									end case;
								when "01101" => --OR TODO
									--OR rx(10-8) ry(7-5)
									--R[x] = R[x] or R[y]
									if (((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) 
									   or ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)))
									then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else
										----ask register for r1,r2
										save_r1_need <= '1'; r1_need <= '1';
										r1_addr <= '0' & inst(10 downto 8); --rx
										save_a_addr <= '0' & inst(10 downto 8); --rx
										
										save_r2_need <= '1'; r2_need <= '1';
										r2_addr <= '0' & inst(7 downto 5); --ry
										save_b_addr <= '0' & inst(7 downto 5);
										
										save_b_imm <= '0';
										save_op_alu <= ALU_OR; -- use rx | ry
										save_op_mem <= MEM_NOP;
										save_need_wb <= '1';
										save_wb_addr <= '0' & inst(10 downto 8); --rx
										isNOP <= '0';
										need_predict <= PREDICT_NOP;
									end if;

								when "01011" => --NEG TODO
									--NEG rx(10-8) ry(7-5)
									--R[x] = 0 - R[y]
									if ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)) then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else	
										----ask register for r2
										save_r1_need <= '1'; r1_need <= '1'; --set rx = 0
										save_a_addr<="1111"; r1_addr <= "1111";
										
										save_r2_need <= '1'; r2_need <= '1';
										r2_addr <= '0' & inst(7 downto 5); --ry
										save_b_addr <= '0' & inst(7 downto 5);
										
										save_b_imm <= '0';
										save_op_alu <= ALU_SUB; -- use rx( = 0) -  ry
										save_op_mem <= MEM_NOP;
										save_need_wb <= '1';
										save_wb_addr <= '0' & inst(10 downto 8); --rx
										isNOP <= '0';
										need_predict <= PREDICT_NOP;
									end if;

								when others=> 
							end case;

						when INST_OPT_B => --B TODO
							--B imm (10-0)
							--PC = PC + Sign_extend(imm)
							b_need <= '1';
							b_pc <= nextpc + ONES16 + SXT(inst(10 downto 0),16);
							isNOP <= '1';

						when INST_OPT_BEQZ => --BEQZ TODO
							--BEQZ rx(10-8) imm(7-0)
							--if R[x] = 0 then PC = PC + sign_extend(imm)
							if ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) then
								b_need <= '1';
								b_pc <= nextpc;
								isNOP <= '1';
								need_predict <= PREDICT_NOP;
							else	
								if (save_is_jump = '1') then--jump
									b_need <= '1';
									b_pc <= nextpc + ONES16 + SXT(inst(7 downto 0),16);
									need_predict <= PREDICT_NZ;--predict wrong condition
									correctpc <= nextpc;---to do
								else--not jump
									b_need <= '0';
									need_predict <= PREDICT_EZ;--predict wrong condition
									correctpc <= nextpc + ONES16 + SXT(inst(7 downto 0),16);
								end if;

								save_r1_need <= '1'; r1_need <= '1';
								r1_addr <= '0' & inst(10 downto 8); --rx
								save_a_addr <= '0' & inst(10 downto 8); --rx
								save_r2_need <= '0'; r2_need <= '0';
								save_imm <= ZERO16;
								save_b_imm <= '1';
								save_op_alu <= ALU_ADD;--use rx + 0 to get rx 
								save_op_mem <= MEM_NOP;
								save_need_wb <= '0';
								isNOP <= '0';
							end if;

						when INST_OPT_BNEZ => --BNEZ TODO
							--BNEZ rx(10-8) imm(7-0)
							--if R[x] != 0 then PC = PC + sign_extend(imm)
							if ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) then
								b_need <= '1';
								b_pc <= nextpc;
								isNOP <= '1';
								need_predict <= PREDICT_NOP;
							else	
								if (save_is_jump = '1') then--jump
									b_need <= '1';
									b_pc <= nextpc + ONES16 + SXT(inst(7 downto 0),16);
									need_predict <= PREDICT_EZ;--predict wrong condition
									correctpc <= nextpc;---to do
								else--not jump
									b_need <= '0';
									need_predict <= PREDICT_NZ;--predict wrong condition
									correctpc <= nextpc + ONES16 + SXT(inst(7 downto 0),16);
								end if;

								save_r1_need <= '1'; r1_need <= '1';
								r1_addr <= '0' & inst(10 downto 8); --rx
								save_a_addr <= '0' & inst(10 downto 8); --rx
								save_r2_need <= '0'; r2_need <= '0';
								save_imm <= ZERO16;
								save_b_imm <= '1';
								save_op_alu <= ALU_ADD;--use rx + 0 to get rx 
								save_op_mem <= MEM_NOP;
								save_need_wb <= '0';
								isNOP <= '0';
							end if;
						when INST_OPT_LI => --LI TODO
							--LI rx(10-8) imm(7-0)
							--R[x] = Zero_Extend(imm)
							save_r1_need <= '1'; r1_need <= '1';
							save_a_addr <="1111"; r1_addr <= "1111"; --set rx = 0
							
							save_r2_need <= '0'; r2_need <= '0';
							save_b_imm <= '1';
							save_imm <= ZERO8 & inst(7 downto 0);

							save_op_alu <= ALU_ADD; --set rx(=0) + imm to get rx
							save_op_mem <= MEM_NOP;
							save_need_wb <= '0';
							isNOP <= '0';

						when INST_OPT_LW => --LW TODO
							--LW rx(10-8) ry(7-5) imm(4-0)
							--R[y] = MEM[R[x] + sign_extend(imm)]
							if ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) then
								b_need <= '1';
								b_pc <= nextpc;
								isNOP <= '1';
								need_predict <= PREDICT_NOP;
							else
								save_r1_need <= '1'; r1_need <= '1';
								save_a_addr <= '0' & inst(10 downto 8); r1_addr <= '0' & inst(10 downto 8); --get rx

								save_r2_need <= '0'; r2_need <= '0';
								save_b_imm <= '1';
								save_imm <= SXT(inst(4 downto 0),16);

								save_op_alu <= ALU_ADD;
								save_op_mem <= MEM_READ;
								save_need_wb <= '1';
								save_wb_addr <= '0' & inst(7 downto 5);
								isNOP <= '0';
							end if;


						when INST_OPT_LW_SP => --LW_SP TODO
							--LW_SP rx(10-8) imm(7-0)
							--R[x] = MEM[SP + sign_extend(imm)]
							save_r1_need <= '1'; r1_need <= '1';
							save_a_addr <= "1001"; r1_addr <= '0' & inst(10 downto 8); --get SP

							save_r2_need <= '0'; r2_need <= '0';
							save_b_imm <= '1';
							save_imm <= SXT(inst(7 downto 0),16);

							save_op_alu <= ALU_ADD;
							save_op_mem <= MEM_READ;
							save_need_wb <= '1';
							save_wb_addr <= '0' & inst(10 downto 8);
							isNOP <= '0';
						
						when INST_OPT_NOP => --NOP TODO
							isNOP <= '1';

						when INST_OPT_SLL_SRA_SRL =>
							case inst(1 downto 0) is
								when "00" => --SLL TODO
									--SLL rx(10-8) ry(7-5) imm(4-2)
									--if (imm = 0) R[x] = R[y] << 8
									--if (imm != 0) R[x] = R[y] << imm;
									if ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)) then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else
										save_r1_need <= '1'; r1_need <= '1';
										save_a_addr <= '0' & inst(7 downto 5); r1_addr <= '0' & inst(7 downto 5); --get ry

										save_r2_need <= '0'; r2_need <= '0';
										save_b_imm <= '1';
										if (inst(4 downto 2) = "000") then
											save_imm <= "0000000000001000";--8
										else
											save_imm <= "0000000000000" & inst(4 downto 2);
										end if;
										save_op_alu <= ALU_SLL;
										save_op_mem <= MEM_READ;
										save_need_wb <= '1';
										save_wb_addr <= '0' & inst(10 downto 8);
										isNOP <= '0';
									end if;
								when "11" => --SRA TODO
									--SRA rx(10-8) ry(7-5) imm(4-2)
									--if (imm = 0) R[x] = R[y] >> 8 (arithmatic)
									--if (imm != 0) R[x] = R[y] >> imm (arithmatic)
									if ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)) then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else
										save_r1_need <= '1'; r1_need <= '1';
										save_a_addr <= '0' & inst(7 downto 5); r1_addr <= '0' & inst(7 downto 5); --get ry

										save_r2_need <= '0'; r2_need <= '0';
										save_b_imm <= '1';
										if (inst(4 downto 2) = "000") then
											save_imm <= "0000000000001000";--8
										else
											save_imm <= "0000000000000" & inst(4 downto 2);
										end if;
										save_op_alu <= ALU_SRA;
										save_op_mem <= MEM_READ;
										save_need_wb <= '1';
										save_wb_addr <= '0' & inst(10 downto 8);
										isNOP <= '0';
									end if;
								when "10" => --SRL TODO
									--SRL rx(10-8) ry(7-5) imm(4-2)
									--if (imm = 0) R[x] = R[y] << 8 (logical)
									--if (imm != 0) R[x] = R[y] << imm; (logical)
									if ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)) then
										b_need <= '1';
										b_pc <= nextpc;
										isNOP <= '1';
										need_predict <= PREDICT_NOP;
									else
										save_r1_need <= '1'; r1_need <= '1';
										save_a_addr <= '0' & inst(7 downto 5); r1_addr <= '0' & inst(7 downto 5); --get ry

										save_r2_need <= '0'; r2_need <= '0';
										save_b_imm <= '1';
										if (inst(4 downto 2) = "000") then
											save_imm <= "0000000000001000";--8
										else
											save_imm <= "0000000000000" & inst(4 downto 2);
										end if;
										save_op_alu <= ALU_SRL;
										save_op_mem <= MEM_READ;
										save_need_wb <= '1';
										save_wb_addr <= '0' & inst(10 downto 8);
										isNOP <= '0';
									end if;
								when others =>
							end case;
						when INST_OPT_SW => --SW TODO
							--SW rx(10-8) ry(7-5) imm(4-0)
							--MEM[R[x] + sign_extend(imm)] = R[y]
							if (((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) or
								((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ)))
							then
								b_need <= '1';
								b_pc <= nextpc;
								isNOP <= '1';
								need_predict <= PREDICT_NOP;
							else
								save_r1_need <= '1'; r1_need <= '1';
								save_a_addr <= '0' & inst(10 downto 8); r1_addr <= '0' & inst(10 downto 8); --get rx

								save_r2_need <= '1'; r2_need <= '1';
								save_b_addr <= '0' & inst(7 downto 5); r2_addr <= '0' & inst(7 downto 5); --get ry
								save_b_imm <= '1';
								save_imm <= SXT(inst(4 downto 0),16);

								save_op_alu <= ALU_NOP;--use ry
								save_op_mem <= MEM_WRITE;
								save_need_wb <= '0';
								isNOP <= '0';
							end if;

						when INST_OPT_SW_SP => --SW_SP TODO
							--SW_SP rx(10-8) imm(7-0)
							--MEM[SP + sign_extend(imm)] = R[x]
							if (((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(10 downto 8)) and (op_mem_ex = MEM_READ)) or 
								((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ))) 
							then
								b_need <= '1';
								b_pc <= nextpc;
								isNOP <= '1';
								need_predict <= PREDICT_NOP;
							else
								save_r1_need <= '1'; r1_need <= '1';
								save_a_addr <= "1001"; r1_addr <= "1001"; --get SP

								save_r2_need <= '1'; r2_need <= '1';
								save_b_addr <= '0' & inst(10 downto 8); r2_addr <= '0' & inst(10 downto 8);--get rx
								save_b_imm <= '1';
								save_imm <= SXT(inst(7 downto 0),16);

								save_op_alu <= ALU_NOP;-- use ry
								save_op_mem <= MEM_WRITE;
								save_need_wb <= '0';
								isNOP <= '0';
							end if;

						when INST_OPT_MOVE => --MOVE TODO
							--MOVE rx(10-8) ry(7-5)
							--R[x] = R[y]
							if ((need_wb_ex = '1') and (wb_addr_ex = '0' & inst(7 downto 5)) and (op_mem_ex = MEM_READ))then
								b_need <= '1';
								b_pc <= nextpc;
								isNOP <= '1';
								need_predict <= PREDICT_NOP;
							else
								save_r1_need <= '0'; r1_need <='0';
								save_r2_need <= '1'; r2_need <='1';
								save_b_addr <= '0' & inst (7 downto 5); r2_addr <= '0' & inst(7 downto 5); --get ry
								save_b_imm <= '0';

								save_op_alu <= ALU_NOP; --use ry
								save_op_mem <= MEM_NOP;
								isNOP <= '0';
							end if;
						when INST_OPT_ADDSP3 => --ADDSP3 TODO
							--ADDSP3 rx(10-8) imm(7-0)
							--R[x] = SP + sign_extend(imm)
							if ((need_wb_ex = '1') and (wb_addr_ex = "1001") and (op_mem_ex = MEM_READ))then
								b_need <= '1';
								b_pc <= nextpc;
								isNOP <= '1';
								need_predict <= PREDICT_NOP;
							else
								save_r1_need <= '1'; r1_need <='1';
								save_a_addr <= "1001"; r1_addr <= "1001";

								save_r2_need <= '0'; r2_need <='0';
								save_b_imm <= '1';
								save_imm <= SXT(inst(7 downto 0),16); --sgn extend

								save_op_alu <= ALU_ADD; --use rx + imm
								save_op_mem <= MEM_NOP;
								
								save_need_wb <= '1';
								save_wb_addr <= '0' & inst(10 downto 8);
								isNOP <= '0';
							end if;
						when others =>
						end case;
					state <= 2;
				when 2 =>
					if (isNOP = '0') then
						a <= r1_data;
						b <= r2_data;
						imm <= save_imm;
						a_imm <= save_a_imm;
						b_imm <= save_b_imm;

						a_addr <= save_a_addr;
						b_addr <= save_b_addr;
						need_wb <= save_need_wb;
						wb_addr <= save_wb_addr;
						op_mem <= save_op_mem;
						op_alu <= save_op_alu;
						if (last_predict = PREDICT_WRONG) then
							save_is_jump <= not save_is_jump;
						end if;
					else
						a <= ZERO16;
						b <= ZERO16;
						imm <= ZERO16;
						a_imm <= '0';
						b_imm <= '0';

						a_addr <= "0000";
						b_addr <= "0000";
						need_wb <= '0';
						op_mem <= MEM_NOP;
						op_alu <= ALU_NOP;
					end if;
					state <= 3;
				when 3=>
					state <= 4;
				when 4=>
					state <= 1;
				when others =>  state <= 1;
			end case;
		end if;
	end process;

end Behavioral;

