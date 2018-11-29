-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;

entity ex_mem is
    port(clk: in std_logic;
    rst: in std_logic;

    stall: in std_logic_vector(5 downto 0);
    flush: in std_logic;

    ex_mem_addr_i: in std_logic_vector(15 downto 0); -- mem�׶ζ��ڴ���ַ
    ex_mem_ce_i: in std_logic;
    ex_mem_we_i: in std_logic;
    ex_mem_re_i: in std_logic;
    ex_mem_wdata_i: in std_logic_vector(15 downto 0);
    -- ex_reg2_data_i: in std_logic_vector(15 downto 0); -- �ڶ����Ĵ���������

    ex_wd_i: in std_logic_vector(3 downto 0); -- д�ؽ׶�Ŀ���Ĵ�������
    ex_we_i: in std_logic; -- д�ؽ׶��Ƿ�д��
    ex_wdata_i: in std_logic_vector(15 downto 0); -- д�ؽ׶ε�д������
    ex_aluop_i: in std_logic_vector(7 downto 0);

    -- stallsignal_i: in std_logic;
    -- ex_current_inst_address is previously deleted.
    -- ex_is_in_delayslot is previously deleted.

    mem_mem_addr_o: out std_logic_vector(15 downto 0);
    mem_mem_ce_o: out std_logic;
    mem_mem_we_o: out std_logic;
    mem_mem_re_o: out std_logic;
    mem_mem_wdata_o: out std_logic_vector(15 downto 0);
    -- mem_reg2_data_o: out std_logic_vector(15 downto 0);

    mem_wd_o: out std_logic_vector(3 downto 0);
    mem_we_o: out std_logic;
    mem_wdata_o: out std_logic_vector(15 downto 0);
    mem_aluop_o: out std_logic_vector(7 downto 0)
    -- mem_current_inst_address is previously deleted.
    -- mem_is_in_delayslot is previously deleted.
    -- stallsignal_o: out std_logic;
    -- stallreq_o: out std_logic
    );
end ex_mem;

architecture bhv of ex_mem is
    begin
        process(clk)
        begin
            if(clk'event and clk = Enable) then
                if (rst = Enable) then
                    mem_wd_o <= RegAddrZero;
                    mem_we_o <= Disable;
                    mem_wdata_o <= ZeroWord;
                    mem_mem_addr_o <= ZeroWord;
                    mem_mem_ce_o <= Disable;
                    mem_mem_re_o <= Disable;
                    mem_mem_we_o <= Disable;
                    mem_mem_wdata_o <= ZeroWord;
                    mem_aluop_o <= EXE_NOP_OP;
                    -- stallsignal_o <= NoStop;
                    -- stallreq_o <= NoStop;
                else
                    mem_wd_o <= ex_wd_i;
                    mem_we_o <= ex_we_i;
                    mem_wdata_o <= ex_wdata_i;
                    mem_mem_addr_o <= ex_mem_addr_i;
                    mem_mem_ce_o <= ex_mem_ce_i;
                    mem_mem_re_o <= ex_mem_re_i;
                    mem_mem_we_o <= ex_mem_we_i;
                    mem_mem_wdata_o <= ex_mem_wdata_i;
                    mem_aluop_o <= ex_aluop_i;
                    -- stallsignal_o <= NoStop;
                    -- stallreq_o <= NoStop;
                    --
                    -- if (stallsignal_i = Stop) then
                    --   -- stallsignal_o <= Stop;
                    --   stallreq_o <= Stop;
                    -- end if;
                end if;
            end if;
        end process;
    end bhv;
