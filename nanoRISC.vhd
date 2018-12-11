--
--
--		  Universidade Federal de Pelotas
--		       Engenharia Eletrônica
--   Autor: Luiz Guilherme Martinho Sampaio Ito
--		    Cadeira: Sistemas Digitais II
--		   contato: llguilherme@hotmail.com
--
--			  Processador RISC single-cycle
--
--  Tentativa NOVEEEEEEE
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;


entity nanoRISC is
------------------------------------------------------------
-- Control inputs and outputs of the nanoRISC microprocessor
------------------------------------------------------------ 
port (
 clk,reset: in std_logic;
 pc_out, alu_result: out std_logic_vector(15 downto 0)
);
end nanoRISC;

architecture Behavioral of nanoRISC is

---------------------------------------------------
---------------------------------------------------
-- Declaration of the blocks in the main description
---------------------------------------------------
---------------------------------------------------
component Instruction_Memory
port (
 pc: in std_logic_vector(15 downto 0);
 instruction: out  std_logic_vector(15 downto 0)
);
end component;


component ALU
port(
 a,b : in std_logic_vector(15 downto 0); -- src1, src2
 alu_control : in std_logic_vector(2 downto 0); -- function select
 alu_result: out std_logic_vector(15 downto 0); -- ALU Output Result
 zero: out std_logic -- Zero Flag
 );
end component;

component ALU_Control
port(
  ALU_Control: out std_logic_vector(2 downto 0);
  ALUOp : in std_logic_vector(1 downto 0);
  ALU_Funct : in std_logic_vector(2 downto 0)
);
end component;

component control_unit
port (
  opcode: in std_logic_vector(2 downto 0);
  reset: in std_logic;
  reg_dst,mem_to_reg,alu_op: out std_logic_vector(1 downto 0);
  jump,branch,mem_read,mem_write,alu_src,reg_write,sign_or_zero: out std_logic
 );
end component;

component Data_Memory
port (
 clk: in std_logic;
 mem_access_addr: in std_logic_Vector(15 downto 0);
 mem_write_data: in std_logic_Vector(15 downto 0);
 mem_write_en,mem_read:in std_logic;
 mem_read_data: out std_logic_Vector(15 downto 0)
);
end component;

component register_nano
port (
 clk,rst: in std_logic;
 reg_write_en: in std_logic;
 reg_write_dest: in std_logic_vector(2 downto 0);
 reg_write_data: in std_logic_vector(15 downto 0);
 reg_read_addr_1: in std_logic_vector(2 downto 0);
 reg_read_data_1: out std_logic_vector(15 downto 0);
 reg_read_addr_2: in std_logic_vector(2 downto 0);
 reg_read_data_2: out std_logic_vector(15 downto 0)
);
end component;
------------------------------------------------------
-- -----------End of declaration of blocks -----------
--------------------------------------------------------



-------------------------------------------------------
------------ Block connection signals -----------------
-------------------------------------------------------
 signal pc_current: std_logic_vector(15 downto 0);
 signal pc_next,pc2: std_logic_vector(15 downto 0);
 signal instr: std_logic_vector(15 downto 0);
 signal reg_dst,mem_to_reg,alu_op: std_logic_vector(1 downto 0);
 signal jump,branch,mem_read,mem_write,alu_src,reg_write: std_logic;
 signal reg_write_dest: std_logic_vector(2 downto 0);
 signal reg_write_data: std_logic_vector(15 downto 0);
 signal reg_read_addr_1: std_logic_vector(2 downto 0);
 signal reg_read_data_1: std_logic_vector(15 downto 0);
 signal reg_read_addr_2: std_logic_vector(2 downto 0);
 signal reg_read_data_2: std_logic_vector(15 downto 0);
 signal sign_ext_im,read_data2,zero_ext_im,imm_ext: std_logic_vector(15 downto 0);
 signal JRControl: std_logic;
 signal ALU_ControlL: std_logic_vector(2 downto 0);
 signal ALU_out: std_logic_vector(15 downto 0);
 signal zero_flag: std_logic;
 signal im_shift_1, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr: std_logic_vector(15 downto 0);
 signal beq_control: std_logic;
 signal jump_shift_1: std_logic_vector(14 downto 0);
 signal mem_read_data: std_logic_vector(15 downto 0);
 signal no_sign_ext: std_logic_vector(15 downto 0);
 signal sign_or_zero: std_logic;
 signal tmp1: std_logic_vector(8 downto 0);
 -------------------------------------------------------
------------ End connection signals -----------------
-------------------------------------------------------
 
begin
----------------------------------
-- PC of the MIPS Processor in VHDL-
--------------------------------------
process(clk,reset)

begin 
 if(reset='1') then
  pc_current <= x"0000";
 elsif(rising_edge(clk)) then
  pc_current <= pc_next;
 end if;
end process;
----------
-- PC + 2 
----------
  pc2 <= pc_current + x"0002";
  
-----------------------------------------------------
-- instruction memory of the MIPS Processor in VHDL
-----------------------------------------------------
Intruction: Instruction_Memory 
        port map 
       (
		  pc => pc_current,
        instruction => instr
        );

		  
----------------------
-- jump shift left 1--
-----------------------
 jump_shift_1 <= instr(13 downto 0) & '0';
 
 
----------------------------------------------- 
-- control unit of the MIPS Processor in VHDL
-----------------------------------------------
control: control_unit
   port map
   (reset => reset,
    opcode => instr(15 downto 13),
    reg_dst => reg_dst,
    mem_to_reg => mem_to_reg,
    alu_op => alu_op,
    jump => jump,
    branch => branch,
    mem_read => mem_read,
    mem_write => mem_write,
    alu_src => alu_src,
    reg_write => reg_write,
    sign_or_zero => sign_or_zero
    );
	 

-----------------------	 
-- multiplexer regdest-
-----------------------
  reg_write_dest <= "111" when  reg_dst= "10" else
        instr(6 downto 4) when  reg_dst= "01" else
        instr(9 downto 7);
		  

--------------------------------------------------------------		  
-- register file instantiation of the MIPS Processor in VHDL
---------------------------------------------------------------
 reg_read_addr_1 <= instr(12 downto 10);
 reg_read_addr_2 <= instr(9 downto 7);
register_nano_sig: register_nano
 port map
 (
 clk => clk,
 rst => reset,
 reg_write_en => reg_write,
 reg_write_dest => reg_write_dest,
 reg_write_data => reg_write_data,
 reg_read_addr_1 => reg_read_addr_1,
 reg_read_data_1 => reg_read_data_1,
 reg_read_addr_2 => reg_read_addr_2,
 reg_read_data_2 => reg_read_data_2
 );
 

--------------- 
-- sign extend
---------------
 tmp1 <= (others => instr(6));
 sign_ext_im <=  tmp1 & instr(6 downto 0); 
 zero_ext_im <= "000000000"& instr(6 downto 0); 
 imm_ext <= sign_ext_im when sign_or_zero='1' else zero_ext_im;
 
--------------------------------------------------- 
-- JR control unit of the MIPS Processor in VHDL
----------------------------------------------------
 JRControl <= '1' when ((alu_op="00") and (instr(3 downto 0)="1000")) else '0';
 

-------------------------------------------------- 
-- ALU control unit of the MIPS Processor in VHDL-
---------------------------------------------------
ALU_Control_sig: ALU_Control 
	port map
  (
   ALUOp => alu_op,
   ALU_Funct => instr(2 downto 0),
   ALU_Control => ALU_ControlL
   );
	
-----------------------	
-- multiplexer alu_src
-----------------------
 read_data2 <= imm_ext when alu_src='1' else reg_read_data_2;
 
-------------------------------------------- 
-- ALU unit of the MIPS Processor in VHDL
---------------------------------------------
alu_sig: ALU
	port map
  (
   a => reg_read_data_1,
   b => read_data2,
   alu_control => ALU_ControlL,
   alu_result => ALU_out,
   zero => zero_flag
   );
	
---------------------	
-- immediate shift 1
---------------------
 im_shift_1 <= imm_ext(14 downto 0) & '0';
 no_sign_ext <= (not im_shift_1) + x"0001";
 
------------- 
-- PC beq add
----------------
 PC_beq <= (pc2 - no_sign_ext) when im_shift_1(15) = '1' else (pc2 +im_shift_1);
 
----------------- 
-- beq control
---------------
   beq_control <= branch and zero_flag;
	
---------	
-- PC_beq
---------
   PC_4beq <= PC_beq when beq_control='1' else pc2;

-------	
-- PC_j
-------
 PC_j <= pc2(15) & jump_shift_1;

----------- 
-- PC_4beqj
-------------
 PC_4beqj <= PC_j when jump = '1' else  PC_4beq;
 
----------- 
-- PC_jr
----------
 PC_jr <= reg_read_data_1;
 
----------- 
-- PC_next
----------
 pc_next <= PC_jr when (JRControl='1') else PC_4beqj;
 
--------------------------------------------- 
-- data memory of the MIPS Processor in VHDL-
-----------------------------------------------
data_memory_sig: Data_Memory 
	port map
  (
  clk => clk,
  mem_access_addr => ALU_out,
  mem_write_data => reg_read_data_2,
  mem_write_en => mem_write,
  mem_read => mem_read,
  mem_read_data => mem_read_data
  );
  
-------------------------------------------- 
-- write back of the MIPS Processor in VHDL
----------------------------------------------
 reg_write_data <= pc2 when (mem_to_reg = "10") else
       mem_read_data when (mem_to_reg = "01") else ALU_out;
		 
----------		 
-- output-
----------
 pc_out <= pc_current;
 alu_result <= ALU_out;

end Behavioral;