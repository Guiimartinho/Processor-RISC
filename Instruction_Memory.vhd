--
--
--		Universidade Federal de Pelotas
--		      Engenharia Eletrônica
--   Autor: Luiz Guilherme Martinho Sampaio Ito
--		   Processador RISC single-cycle
--		  Cadeira: Sistemas Digitais II
--		 contato: llguilherme@hotmail.com
--
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  
entity Instruction_Memory is
port (
 pc: in std_logic_vector(15 downto 0);
 instruction: out  std_logic_vector(15 downto 0)
);
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
signal rom_addr: std_logic_vector(3 downto 0);
 -- LI R1, 8
 -- LUI R1, 1
 -- LI R2, 80
 -- ADD R3, R1, R2
 -- SUB R4, R1, R2
 -- ABD R5, R3, R1
 -- OR R6, R3, R1
 -- XOR R7, R3, R1
 -- SHR R8, R5
 -- SHL R9, R5
 -- SW R8, R0(0)
 -- SW R7, R0(1)
 -- SW R6, R0(2)
 -- LW R10, R0(1)
 -- JE R0, R3, R4
 -- JL, R0, R1, R2
 -- JMP 17
 type ROM_type is array (0 to 16 ) of std_logic_vector(15 downto 0);
 constant rom_data: ROM_type:=(
   "0010000100001000",
   "1100000100000001",
   "0010001001010000",
   "0011001100010010",
   "0100010000010010", -- 5º linha
   "0101010100110001",
   "0110011000110001",
   "0111011100110001",
   "1101100001010000",
   "1110100101010000", -- 10º linha
   "0001100000000000",
   "0001011100000001",
   "0001011000000010", -- 13º linha
   "0000101000000001",
   "1001000000110100", -- 15º linha
   "1010000000010010",
	"1000000000010001"
  );
begin

 rom_addr <= pc(4 downto 1);
  instruction <= rom_data(to_integer(unsigned(rom_addr))) when pc < x"0020" else x"0000";

end Behavioral;