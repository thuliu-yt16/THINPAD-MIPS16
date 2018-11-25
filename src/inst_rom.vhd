library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- input ports: addr, ce;
-- output ports: inst;
entity inst_rom is
  port(addr_i: in std_logic_vector(15 downto 0); -- Ҫȡָ��ĵ�ַ
       ce_i: in std_logic; -- оƬʹ��

       inst_o: out std_logic_vector(15 downto 0)); -- ��ȡָ��
end inst_rom;

architecture bhv of inst_rom is
type InstructionArray is array(0 to 1000) of std_logic_vector(15 downto 0);
signal insts: InstructionArray := (
     -- дһЩ�ɹ����Ե�ָ��
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
