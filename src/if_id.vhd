-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;

entity if_id is
    port(clk: in std_logic;
    rst: in std_logic;

    stall: in std_logic_vector(5 downto 0);
    flush: in std_logic;

    if_pc_i: in std_logic_vector(15 downto 0);
    if_inst_i: in std_logic_vector(15 downto 0);

    id_pc_o: out std_logic_vector(15 downto 0);
    id_inst_o: out std_logic_vector(15 downto 0)
    );
end if_id;

architecture bhv of if_id is

    signal id_pc: std_logic_vector(15 downto 0);
    signal id_inst: std_logic_vector(15 downto 0);
    begin
        id_pc_o <= id_pc;
        id_inst_o <= id_inst;

        process(clk)
        begin
            if(clk'event and clk = Enable) then
                if (rst = Enable) then
                    id_pc <= Zeroword;
                    id_inst <= NopInst; -- rst�� nop
                else
                    id_pc <= if_pc_i;
                    id_inst <= if_inst_i;
                end if;
            end if;
        end process;
    end bhv;
