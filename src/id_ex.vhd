-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use work.define.all;

entity id_ex is
    port(clk: in std_logic;
    rst: in std_logic;

    stall: in std_logic_vector(5 downto 0);
    flush: in std_logic;

    id_aluop_i: in std_logic_vector(7 downto 0);
    id_alusel_i: in std_logic_vector(2 downto 0);

    id_reg1_data_i: in std_logic_vector(15 downto 0);
    id_reg2_data_i: in std_logic_vector(15 downto 0);
    id_wd_i: in std_logic_vector(3 downto 0);
    id_we_i: in std_logic;

    id_inst_i: in std_logic_vector(15 downto 0);

    -- stallsignal_i: in std_logic;
    -- id_current_inst_address is previously deleted.
    -- id_is_in_delayslot is previously deleted.
    -- id_link_addr is previously deleted.
    -- next_inst_in_delayslot_i is previously deleted.
    ex_aluop_o: out std_logic_vector(7 downto 0);
    ex_alusel_o: out std_logic_vector(2 downto 0);

    ex_reg1_data_o: out std_logic_vector(15 downto 0);
    ex_reg2_data_o: out std_logic_vector(15 downto 0);
    ex_wd_o: out std_logic_vector(3 downto 0);
    ex_we_o: out std_logic;

    ex_inst_o: out std_logic_vector(15 downto 0)

    -- stallreq_o: out std_logic;
    -- stallsignal_o: out std_logic
    -- ex_current_inst_addr is previously deleted.
    -- ex_is_in_delayslot is previously deleted.
    -- ex_link_addr is previously deleted.
    -- is_in_delayslot_o is previously deleted.
    );
end id_ex;

architecture bhv of id_ex is
    -- TODO ���Ӷ�stall �� flush ���ж�
    -- TODO ����������һЩδ֪�ź� ??

    begin
        process(clk)
        begin
            if(clk'event and clk = Enable) then
                if(rst = Enable) then
                    ex_alusel_o <= EXE_RES_NOP;
                    ex_aluop_o <= EXE_NOP_OP;
                    ex_reg1_data_o <= ZeroWord;
                    ex_reg2_data_o <= ZeroWord;
                    ex_wd_o <= RegAddrZero;
                    ex_we_o <= Disable;
                    ex_inst_o <= NopInst;
                    -- stallreq_o <= NoStop;
                    -- stallsignal_o <= NoStop;
                elsif(stall(2) = Stop and stall(3) = NoStop) then
                    ex_alusel_o <= EXE_RES_NOP;
                    ex_aluop_o <= EXE_NOP_OP;
                    ex_reg1_data_o <= ZeroWord;
                    ex_reg2_data_o <= ZeroWord;
                    ex_wd_o <= RegAddrZero;
                    ex_we_o <= Disable;
                    ex_inst_o <= NopInst;
                elsif (stall(2) = NoStop) then
                    ex_aluop_o <= id_aluop_i;
                    ex_alusel_o <= id_alusel_i;
                    ex_reg1_data_o <= id_reg1_data_i;
                    ex_reg2_data_o <= id_reg2_data_i;
                    ex_wd_o <= id_wd_i;
                    ex_we_o <= id_we_i;
                    ex_inst_o <= id_inst_i;
                    -- stallreq_o <= NoStop;
                    -- stallsignal_o <= NoStop;
                    -- if (stallsignal_i =  Stop) then
                      -- stallreq_o <= Stop;
                      -- stallsignal_o <= Stop;
                    -- end if;
                end if;
            end if;
    end process;
    end bhv;
