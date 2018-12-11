# Processor-RISC
Design of a microprocessor of RISC architecture for the discipline of Digital Systems II


After EIGHT attempts at description, at the second time additions, it worked.

Language and machine code allocated in ROM memory: 

Language Machine:

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

Binary Code:

   "0010000100001000",
   "1100000100000001",
   "0010001001010000",
   "0011001100010010",
   "0100010000010010", 
   "0101010100110001",
   "0110011000110001",
   "0111011100110001",
   "1101100001010000",
   "1110100101010000", 
   "0001100000000000",
   "0001011100000001",
   "0001011000000010", 
   "0000101000000001",
   "1001000000110100", 
   "1010000000010010",
 	"1000000000010001"
