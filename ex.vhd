----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:37 11/18/2017 
-- Design Name: 
-- Module Name:    ex - Behavioral 
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ex is
Port (
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;
        
        a: in STD_LOGIC_VECTOR(15 downto 0);
        a_addr: in STD_LOGIC_VECTOR(3 downto 0);
        b: in STD_LOGIC_VECTOR(15 downto 0);
        b_addr: in STD_LOGIC_VECTOR(3 downto 0);
        imm: in STD_LOGIC_VECTOR(15 downto 0);
        a_imm: in STD_LOGIC;
        b_imm: in STD_LOGIC;
        
        op_alu: in  std_logic_vector(2 downto 0);
        op_mem: in std_logic_vector(1 downto 0);
        
        need_wb: in STD_LOGIC;
        wb_addr: in STD_LOGIC_VECTOR(3 downto 0);
        
        answer: out STD_LOGIC_VECTOR(15 downto 0);
        addr: out  STD_LOGIC_VECTOR(15 downto 0);
        
        r_data_mem: in STD_LOGIC_VECTOR(15 downto 0);
        r_addr_mem: in STD_LOGIC_VECTOR(3 downto 0);
        r_need_mem: in STD_LOGIC;
        
        r_data_wb: in STD_LOGIC_VECTOR(15 downto 0);
        r_addr_wb: in STD_LOGIC_VECTOR(3 downto 0);
        r_need_wb: in STD_LOGIC;
        
        need_predict:  in STD_LOGIC_VECTOR(1 downto 0);
        correctpc_ex: in STD_LOGIC_VECTOR(15 downto 0);
        
        b_need: out STD_LOGIC;
        b_pc: out STD_LOGIC_VECTOR(15 downto 0);
        predict_result: out STD_LOGIC;
        
        stallreq: out STD_LOGIC
	);
end ex;

architecture Behavioral of ex is
signal state : integer := 1;
signal ra : std_logic_vector(15 downto 0);
signal rb : std_logic_vector(15 downto 0);
signal addr_save : STD_LOGIC_VECTOR(15 downto 0);

begin
	process (clk,rst) is
	begin
		if (rst = '0') then
			state <= 1;
		elsif (clk'event and clk = '1') then
			case state  is
				when 1 => 	--get correct ra and rb from last or last last wb data 
							--finish predict (r is in ra) 
							-----if predict wrong condition(NE or ZE) satisfied:
							----------b_need='1', b_pc = correct_pc + immm
					
					--get ra from last wb_data
					if (r_need_wb = '1') and (r_addr_wb = a_addr) then
						ra <= r_data_wb;
						case need_predict is
							when PREDICT_EZ =>
								if (r_data_wb = ZERO16) then
									b_need <= '1';
									b_pc <= correctpc_ex + imm;
								else 
									b_need <= '0';
								end if;
								
							when PREDICT_NZ =>
								if (r_data_wb /= ZERO16) then
									b_need <= '1';
									b_pc <= correctpc_ex + imm;
								else 
									b_need <= '0';
								end if;
							when others=> b_need <= '0';
						end case;

					---get ra from last last wb_data.
					elsif (r_need_mem = '1') and (r_addr_mem = a_addr) then
						ra <= r_data_mem;
						case need_predict is
							when PREDICT_EZ =>
								if (r_data_mem = ZERO16) then
									b_need <= '1';
									b_pc <= correctpc_ex + imm;
									predict_result <= PREDICT_WRONG;
								else 
									b_need <= '0';
									predict_result <= PREDICT_CORRECT;
								end if;
								
							when PREDICT_NZ =>
								if (r_data_mem /= ZERO16) then
									b_need <= '1';
									b_pc <= correctpc_ex + imm;
									predict_result <= PREDICT_WRONG;
								else 
									b_need <= '0';
									predict_result <= PREDICT_CORRECT;
								end if;
							when others=> b_need <= '0';
						end case;
					
					--get ra from a
					else
						ra <= a;
						case need_predict is
							when PREDICT_EZ =>
								if (a = ZERO16) then
									b_need <= '1';
									b_pc <= correctpc_ex + imm;
									predict_result <= PREDICT_WRONG;
								else 
									b_need <= '0';
									predict_result <= PREDICT_CORRECT;
								end if;
								
							when PREDICT_NZ =>
								if (a /= ZERO16) then
									b_need <= '1';
									b_pc <= correctpc_ex + imm;
									predict_result <= PREDICT_WRONG;
								else 
									b_need <= '0';
									predict_result <= PREDICT_CORRECT;
								end if;
							when others=> b_need <= '0';
						end case;
					end if;
					
					--get rb : do same thing like ra

					if ((r_need_wb = '1') and (r_addr_wb = b_addr)) then
						rb <= r_data_wb;
					elsif ((r_need_mem = '1') and (r_addr_mem = b_addr)) then
						rb <= r_data_mem;
					else
						rb <= b;
					end if;
					state <= 2;
					stallreq <= '0';
					
				when 2=> ---calculate answer
						 ---calculate mem addr
					case op_alu is
						when ALU_ADD =>
							if (b_imm = '1') then
								answer <= ra + imm;
							else
								answer <= ra + rb;
							end if;
							
						when ALU_AND =>
							if (b_imm = '1') then
								answer <= ra and imm;
							else 
								answer <= ra and rb;
							end if;
						
						when ALU_SUB =>
							if (b_imm = '1') then
								answer <= ra - imm;
							else
								answer <= ra - rb;
							end if;
						
						when ALU_SLL =>
							if (b_imm = '1') then
								answer <= to_stdlogicvector(to_bitvector(ra) sll conv_integer(imm));
							else
								answer <= to_stdlogicvector(to_bitvector(ra) sll conv_integer(rb));
							end if;
						
						when ALU_SRL =>
							if (b_imm = '1') then
								answer <= to_stdlogicvector(to_bitvector(ra) srl conv_integer(imm));
							else
								answer <= to_stdlogicvector(to_bitvector(ra) srl conv_integer(rb));
							end if;
						
						when ALU_SRA =>
							if (b_imm = '1') then
								answer <= to_stdlogicvector(to_bitvector(ra) sra conv_integer(imm));
							else
								answer <= to_stdlogicvector(to_bitvector(ra) sra conv_integer(rb));
							end if;
						when ALU_OR =>
							if (b_imm = '1') then
								answer <= ra or imm;
							else
								answer <= ra or rb;
							end if;
						when others => answer <= (others => '0');
					end case;
					
					addr_save <= ra + imm;
					stallreq <= '0';
					state <= 3;
				
				when 3 =>
					--set stallreq = '1' when SW is to write 0x4000 to 0x7FFF
					--ͬsend addr

					if ((op_mem = MEM_WRITE) and (addr_save <= Ox7FFF)) then
						stallreq <= '1';
					else
						stallreq <= '0';
					end if;
					addr <= addr_save;
					state <= 4;
					
				when 4 =>
					state <= 1;
				when others => 

			end case;
		end if;
	end process;
end Behavioral;

