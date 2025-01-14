-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.define.all;

-- input ports: stall, flush, new_pc, branch_flag_in, branch_target_address_in, clk, rst;
-- output ports: pc, ce;
entity pc is
    port (stall: in std_logic_vector(5 downto 0);
    flush: in std_logic;

    clk: in std_logic;
    rst: in std_logic;

    branch_flag_i: in std_logic;
    branch_target_address_i: std_logic_vector(15 downto 0);
    -- new_pc_i: in std_logic_vector(15 downto 0);

    -- LED: out std_logic_vector(15 downto 0);
    pc_o: out std_logic_vector(15 downto 0);
    ce_o: out std_logic
    );
end pc;

architecture bhv of pc is
    signal pc: std_logic_vector(15 downto 0) := ZeroWord;
    signal ce: std_logic := Enable;
    begin
        ce_o <= ce;
        pc_o <= pc;
        -- LED <= pc;


        -- TODO ������ת
        PC_PROCESS: process(clk)
        begin
            if(clk'event and clk = Enable) then
                if (ce = Disable) then
                    pc <= Zeroword;
                elsif(stall(0) = NoStop) then
                  if (branch_flag_i = Enable) then
                      pc <= branch_target_address_i;
                  else
                      pc <= pc + 1;
                  end if;
                end if;
            end if;
        end process;

        CE_PROCESS: process(clk)
        begin
            if(clk'event and clk = Enable) then
                if (rst = Enable) then
                    ce <= Disable;
                else
                    ce <= Enable;
                end if;
            end if;
        end process;
    end bhv;
