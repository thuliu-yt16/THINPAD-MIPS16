library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.define.all;

-- input ports: addr, ce;
-- output ports: inst;
entity inst_rom is
  port(addr_i: in std_logic_vector(15 downto 0); -- Ҫȡָ���ĵ�ַ
       ce_i: in std_logic; -- оƬʹ��

       inst_o: out std_logic_vector(15 downto 0)); -- ��ȡָ��
end inst_rom;
architecture bhv of inst_rom is
type InstructionArray is array(0 to 1000) of std_logic_vector(15 downto 0);
signal insts: InstructionArray := (
     -- "0100100010000000", -- ADDIU R0 10000000, r0 = r0 - 10000000
     -- "0100000000101000", -- ADDIU3 R0 R1 1000, r1 = r0 - 1000
     -- "0000001000000110", -- ADDSP3 R2 110, r2 = sp + 110
     -- "0110001100000111", -- ADDSP 111, sp += 111
     -- "1110100000101100", -- AND R0 R1, R0 &= R1   1111111110000000 & 11111111101111000
     -- "1110100000101010", -- CMP R0 R1, R0 == R1 ? T = 0 : T = 1
     -- "1110101101000000", -- MFPC R3, R3 = PC
     -- "0111110001100000", -- MOVE R4 R3, R4 = R3
     -- "0100100001000000", -- ADDIU R0 1000000
     -- "0100100100010000", -- ADDIU R1 10000
     -- "1110000000101011", -- R2 = R0 - R1
     -- "0011000100001011", -- R1 = R0 >> 2
     "0100100000000111", -- ADDIU R0 111
     "1101100100000001", -- SW R1 R0 1; MEM[R1 + 1] <- R0; MEM[1] <- 00111
     "0100100000000001", -- ADDIU R0 1
     "1101100100000010", -- SW R1 R0 2; MEM[R1 + 2] <- R0; MEM[2] <- 01000
     "1001100101000001", -- LW R1 R2 1
     others => NopInst
    );
 begin
    READ_INST: process(ce_i, addr_i)
    begin
        if(ce_i = Enable) then
            inst_o <= insts(conv_integer(addr_i));
        else
            inst_o <= NopInst;
        end if;
    end process;

end bhv;
