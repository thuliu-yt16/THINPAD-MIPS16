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
    id_inst_o: out std_logic_vector(15 downto 0);

    -- stallsignal_o: out std_logic;
    stallreq_o: out std_logic
    );
end if_id;

architecture bhv of if_id is

    signal stop_cnt: std_logic_vector(1 downto 0);
    signal id_pc: std_logic_vector(15 downto 0);
    signal id_inst: std_logic_vector(15 downto 0);
    signal stallreq: std_logic;
    signal stallsignal: std_logic;
    begin
        id_pc_o <= id_pc;
        id_inst_o <= id_inst;
        stallreq_o <= stallreq;
        -- stallsignal_o <= stallsignal;

        -- process(clk)
        -- begin
        --     if(clk'event and clk = Enable) then
        --         if (rst = Enable) then
        --             id_pc <= Zeroword;
        --             id_inst <= NopInst; -- rst�� nop
        --             -- stallsignal <= NoStop;
        --             stallreq <= NoStop;
        --             stop_cnt <= "00";
        --         elsif (stall(1) = Stop and stall(2) = NoStop) then
        --             id_pc <= ZeroWord;
        --             id_inst <= NopInst;
        --             -- stallsignal <= NoStop;
        --
        --             stallreq <= NoStop;
        --             if (stop_cnt = "01") then
        --               stop_cnt <= "10";
        --               stallreq <= Stop;
        --             elsif (stop_cnt = "10") then
        --               stop_cnt <= "11";
        --               stallreq <= NoStop;
        --             elsif (stop_cnt = "11") then
        --               stop_cnt <= "00";
        --               stallreq <= NoStop;
        --             end if;
        --
        --         elsif (stall(2) = NoStop) then
        --             id_pc <= if_pc_i;
        --             id_inst <= if_inst_i;
        --             -- stallsignal <= NoStop;
        --             stallreq <= NoStop;
        --             stop_cnt <= "00";
        --
        --             if (if_inst_i(15 downto 11) = "11011" -- sw
        --             or if_inst_i(15 downto 11) = "11010" -- SW_SP
        --             or if_inst_i(15 downto 8) = "01100010" -- SW_RS
        --             ) then
        --                 stop_cnt <= "01";
        --                 stallreq <= Stop;
        --             end if;
        --
        --             -- ɵ�Ƶ�ȡ��Nop
        --             -- if (if_inst_i(15 downto 11) = "00010" -- B
        --             -- or if_inst_i(15 downto 11) = "00100" -- BEQZ
        --             -- or if_inst_i(15 downto 11) = "00101" -- BNEZ
        --             -- or if_inst_i(15 downto 8) = "01100000" -- BTEQZ
        --             -- or (if_inst_i(15 downto 11) = "11101" and if_inst_i(7 downto 5) = "000")
        --             -- ) then
        --             --   stallreq <= Stop;
        --             -- end if;
        --
        --         end if;
        --     end if;
        -- end process;
        process(clk)
        begin
            if(clk'event and clk = Enable) then
                if (rst = Enable) then
                    id_pc <= Zeroword;
                    id_inst <= NopInst;
                elsif (stall(1) = Stop and stall(2) = NoStop) then
                    id_pc <= ZeroWord;
                    id_inst <= NopInst;
                elsif (stall(1) = NoStop) then
                    id_pc <= if_pc_i;
                    id_inst <= if_inst_i;
                    -- -- stallsignal <= NoStop;
                    -- stallreq <= NoStop;
                    -- stop_cnt <= "00";
                    --
                    -- if (if_inst_i(15 downto 11) = "11011" -- sw
                    -- or if_inst_i(15 downto 11) = "11010" -- SW_SP
                    -- or if_inst_i(15 downto 8) = "01100010" -- SW_RS
                    -- ) then
                    --     stop_cnt <= "01";
                    --     stallreq <= Stop;
                    -- end if;

                    -- if (if_inst_i(15 downto 11) = "00010" -- B
                    -- or if_inst_i(15 downto 11) = "00100" -- BEQZ
                    -- or if_inst_i(15 downto 11) = "00101" -- BNEZ
                    -- or if_inst_i(15 downto 8) = "01100000" -- BTEQZ
                    -- or (if_inst_i(15 downto 11) = "11101" and if_inst_i(7 downto 5) = "000") -- JR
                    -- ) then
                    --   stallreq <= Stop;
                    -- end if;

                end if;
            end if;
        end process;
    end bhv;
