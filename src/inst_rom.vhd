library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- input ports: addr, ce;
-- output ports: inst;
entity inst_rom is
  port(addr_i: in std_logic_vector(15 downto 0); -- 要取指令的地址
       ce_i: in std_logic; -- 芯片使能

       inst_o: out std_logic_vector(15 downto 0)); -- 所取指令
end inst_rom;

architecture bhv of inst_rom is
type InstructionArray is array(0 to 1000) of std_logic_vector(15 downto 0);
signal insts: InstructionArray := (
     -- 写一些可供测试的指令
     "0110100101010101",
     others => NopInst
    );
 begin
    READ_INST: process(ce_i, addr_i)
    begin
        if(ce_i = Enable) then
            inst_o <= insts(addr_i);
        else
            inst_o <= NopInst;
        end if;
    end process;

end bhv;
