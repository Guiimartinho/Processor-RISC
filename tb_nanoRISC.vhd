--
--
--		Universidade Federal de Pelotas
--		      Engenharia Eletrônica
--   Autor: Luiz Guilherme Martinho Sampaio Ito
--		   Processador RISC single-cycle
--		  Cadeira: Sistemas Digitais II
--		 contato: llguilherme@hotmail.com
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_nanoRISC IS
END tb_nanoRISC;
 
ARCHITECTURE behavior OF tb_nanoRISC IS 
    -- Component Declaration for the single-cycle MIPS Processor in VHDL
    COMPONENT nanoRISC
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         pc_out : OUT  std_logic_vector(15 downto 0);
         alu_result : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   --Outputs
   signal pc_out : std_logic_vector(15 downto 0);
   signal alu_result : std_logic_vector(15 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
BEGIN
 -- Instantiate the for the single-cycle MIPS Processor in VHDL
   uut: nanoRISC PORT MAP (
          clk => clk,
          reset => reset,
          pc_out => pc_out,
          alu_result => alu_result
        );

   -- Clock process definitions
   clk_process :process
   begin
  clk <= '0';
  wait for clk_period/2;
  clk <= '1';
  wait for clk_period/2;
   end process;
   -- Stimulus process
   stim_proc: process
   begin  
      reset <= '1';
      wait for clk_period*10;
  reset <= '0';
      -- insert stimulus here 
      wait;
   end process;

END;