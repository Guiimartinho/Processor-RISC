--
--
--		Universidade Federal de Pelotas
--		      Engenharia Eletrônica
--   Autor: Luiz Guilherme Martinho Sampaio Ito
--		   Processador RISC single-cycle
--		  Cadeira: Sistemas Digitais II
--		 contato: llguilherme@hotmail.com
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_signed.all;




entity ALU is
port(
 a,b : in std_logic_vector(15 downto 0); -- src1, src2
 alu_control : in std_logic_vector(2 downto 0); -- function select
 alu_result: out std_logic_vector(15 downto 0); -- ALU Output Result
 zero: out std_logic -- Zero Flag
 );
end ALU;

architecture Behavioral of ALU is
signal result: std_logic_vector(15 downto 0);
begin
process(alu_control,a,b)
begin
 case alu_control is
 when "000" =>
  result <= a + b; -- add
 when "001" =>
  result <= a - b; -- sub
 when "010" => 
  result <= a and b; -- and
 when "011" =>
  result <= a or b; -- or
 when "100" =>
  if (a<b) then
   result <= x"0001";
  else 
   result <= x"0000";
  end if;
 when others => result <= a + b; -- add
 end case;
end process;
  zero <= '1' when result=x"0000" else '0';
  alu_result <= result;
end Behavioral;