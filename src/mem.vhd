-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;

entity mem is
    port(rst: in std_logic;
    -- ���� ram
    mem_data_i: in std_logic_vector(15 downto 0);
    -- ���� ex/mem
    mem_addr_i: in std_logic_vector(15 downto 0);
    mem_ce_i: in std_logic;
    mem_we_i: in std_logic;
    mem_re_i: in std_logic;
    mem_wdata_i: in std_logic_vector(15 downto 0);
    -- reg2_data_i: in std_logic_vector(15 downto 0);
    wd_i: in std_logic_vector(3 downto 0);
    we_i: in std_logic;
    wdata_i: in std_logic_vector(15 downto 0);
    aluop_i: in std_logic_vector(7 downto 0);
    -- current_inst_address_i is previously deleted.
    -- is_in_delayslot_i is previously deleted.

    -- mem/wb ��
    wd_o: out std_logic_vector(3 downto 0);
    we_o: out std_logic;
    wdata_o: out std_logic_vector(15 downto 0);
    -- current_inst_address_i is previously deleted.
    -- is_in_delayslot_i is previously deleted.

    -- RAM ��
    mem_we_o: out std_logic;
    mem_re_o: out std_logic;
    mem_ce_o: out std_logic;
    mem_wdata_o: out std_logic_vector(15 downto 0);
    mem_addr_o: out std_logic_vector(15 downto 0)
    -- mem_sel_o: out std_logic_vector(2 downto 0)
    );
end mem;

architecture bhv of mem is
    begin
        process(rst, mem_data_i, mem_addr_i, mem_ce_i, mem_we_i, mem_re_i, mem_wdata_i, wd_i, we_i, wdata_i, aluop_i)
        begin
            if (rst = Enable) then
                wd_o <= RegAddrZero;
                we_o <= Disable;
                wdata_o <= ZeroWord;

                mem_we_o <= Disable;
                mem_re_o <= Disable;
                mem_ce_o <= Disable;
                mem_wdata_o <= ZeroWord;
                mem_addr_o <= ZeroWord;
            else
                wd_o <= wd_i;
                we_o <= we_i;

                mem_we_o <= mem_we_i;
                mem_re_o <= mem_re_i;
                mem_ce_o <= mem_ce_i;
                mem_wdata_o <= mem_wdata_i;
                mem_addr_o <= mem_addr_i;
                case aluop_i is
                    when EXE_LW_OP | EXE_LW_SP_OP=>
                        wdata_o <= mem_data_i;
                    when EXE_SW_OP | EXE_SW_RS_OP | EXE_SW_SP_OP =>
                        wdata_o <= ZeroWord;
                    when others =>
                        wdata_o <= wdata_i;
                end case;
            end if;
        end process;
    end bhv;
