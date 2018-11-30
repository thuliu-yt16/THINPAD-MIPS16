-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.define.all;

entity ex is

    port(
    rst: in std_logic;
    aluop_i: in std_logic_vector(7 downto 0);
    alusel_i: in std_logic_vector(2 downto 0);

    reg1_data_i: in std_logic_vector(15 downto 0);
    reg2_data_i: in std_logic_vector(15 downto 0);
    wd_i: in std_logic_vector(3 downto 0);
    we_i: in std_logic;

    inst_i: in std_logic_vector(15 downto 0);
    -- current_inst_address_i is previously deleted.
    -- is_in_delayslot_i is previously deleted.
    -- link_address_i is previously deleted.

    mem_addr_o: out std_logic_vector(15 downto 0);
    mem_ce_o: out std_logic;
    mem_we_o: out std_logic;
    mem_re_o: out std_logic;
    mem_wdata_o: out std_logic_vector(15 downto 0);

    -- reg2_data_o: out std_logic_vector(15 downto 0); -- ??
    wd_o: out std_logic_vector(3 downto 0);
    we_o: out std_logic;
    wdata_o: out std_logic_vector(15 downto 0);
    aluop_o: out std_logic_vector(7 downto 0);
    -- current_inst_address_o is previously deleted.
    -- is_in_delayslot_o is previously deleted.

    stallreq: out std_logic
    );
end ex;

architecture bhv of ex is
    signal logicout: std_logic_vector(15 downto 0);
    begin
        stallreq <= NoStop;
        aluop_o <= aluop_i;
        ARITH_PROCESS: process(rst, alusel_i, aluop_i, inst_i, reg1_data_i, reg2_data_i, wd_i, we_i)
        begin
            if (rst = Enable) then
                logicout <= ZeroWord;
            else
                -- reg2_data_o <= ZeroWord;
                mem_addr_o <= ZeroWord;
                mem_ce_o <= Disable;
                mem_we_o <= Disable;
                mem_wdata_o <= ZeroWord;
                mem_re_o <= Disable;
                case aluop_i is
                    when EXE_ADDIU_OP =>
                        logicout <= reg1_data_i + reg2_data_i;
                    when EXE_ADDIU3_OP =>
                        logicout <= reg1_data_i + reg2_data_i;
                    when EXE_ADDSP3_OP =>
                        logicout <= reg1_data_i + reg2_data_i;
                    when EXE_ADDSP_OP =>
                        logicout <= reg1_data_i + reg2_data_i;
                    when EXE_ADDU_OP =>
                        logicout <= reg1_data_i + reg2_data_i;
                    when EXE_AND_OP =>
                        logicout <= reg1_data_i and reg2_data_i;
                    when EXE_CMP_OP =>
                        if(reg1_data_i = reg2_data_i) then
                            logicout <= ZeroWord;
                        else
                            logicout <= OneWord;
                        end if;
                    when EXE_LI_OP =>
                        logicout <= reg1_data_i;
                    when EXE_LW_OP =>
                        mem_ce_o <= Enable;
                        mem_re_o <= Enable;
                        mem_addr_o <= reg1_data_i + reg2_data_i;
                    when EXE_LW_SP_OP =>
                        mem_ce_o <= Enable;
                        mem_re_o <= Enable;
                        mem_addr_o <= reg1_data_i + reg2_data_i;
                    when EXE_MFIH_OP =>
                        logicout <= reg1_data_i;
                    when EXE_MFPC_OP =>
                        logicout <= reg1_data_i;
                    when EXE_MOVE_OP =>
                        logicout <= reg1_data_i;
                    when EXE_MTIH_OP =>
                        logicout <= reg1_data_i;
                    when EXE_MTSP_OP =>
                        logicout <= reg1_data_i;
                    when EXE_OR_OP =>
                        logicout <= reg1_data_i or reg2_data_i;
                    when EXE_SLL_OP =>
                        if(reg2_data_i = ZeroWord) then
                            --logicout <= std_logic_vector(shift_left(unsigned(reg1_data_i), 8));
                            logicout <= to_stdlogicvector(to_bitvector(reg1_data_i) sll 8);
                        else
                            -- logicout <= std_logic_vector(shift_left(unsigned(reg1_data_i), to_integer(unsigned(reg2_data_i))));
                            logicout <= to_stdlogicvector(to_bitvector(reg1_data_i) sll conv_integer(reg2_data_i));
                        end if;
                    when EXE_SLT_OP =>
                        if(conv_integer(signed(reg1_data_i)) < conv_integer(signed(reg2_data_i))) then
                        -- if(to_integer(signed(reg1_data_i)) < to_integer(signed(reg2_data_i))) then
                            logicout <= OneWord;
                        else
                            logicout <= ZeroWord;
                        end if;
                    when EXE_SLTI_OP =>
                        if(conv_integer(signed(reg1_data_i)) < conv_integer(signed(reg2_data_i))) then
                        -- if(to_integer(signed(reg1_data_i)) < to_integer(signed(reg2_data_i))) then
                            logicout <= OneWord;
                        else
                            logicout <= ZeroWord;
                        end if;
                    when EXE_SRA_OP =>
                        if(reg2_data_i = ZeroWord) then
                            -- logicout <= std_logic_vector(shift_right(signed(reg1_data_i), 8));
                            logicout <= to_stdlogicvector(to_bitvector(reg1_data_i) sra 8);
                        else
                            -- logicout <= std_logic_vector(shift_right(signed(reg1_data_i), to_integer(unsigned(reg2_data_i))));
                            logicout <= to_stdlogicvector(to_bitvector(reg1_data_i) sra conv_integer(reg2_data_i));
                        end if;
                    when EXE_SUBU_OP =>
                        logicout <= reg1_data_i - reg2_data_i;
                    when EXE_SW_OP =>
                        mem_addr_o <= reg1_data_i + SXT(inst_i(4 downto 0),16);
                        mem_ce_o <= Enable;
                        mem_we_o <= Enable;
                        mem_wdata_o <= reg2_data_i;
                    when EXE_SW_RS_OP =>
                        mem_addr_o <= reg1_data_i + SXT(inst_i(7 downto 0),16);
                        mem_ce_o <= Enable;
                        mem_we_o <= Enable;
                        mem_wdata_o <= reg2_data_i;
                    when EXE_SW_SP_OP =>
                        mem_addr_o <= reg1_data_i + SXT(inst_i(7 downto 0),16);
                        mem_ce_o <= Enable;
                        mem_we_o <= Enable;
                        mem_wdata_o <= reg2_data_i;
                    when others =>
                        logicout <= ZeroWord;
                end case;
            end if;
        end process;

        RESULT_PROCESS: process(wd_i, we_i, alusel_i, aluop_i, logicout)
        begin
            wd_o <= wd_i;
            we_o <= we_i;
            case alusel_i is
                when EXE_RES_LOGIC =>
					wdata_o <= logicout;
                when others =>
					wdata_o <= ZeroWord;
            end case;
        end process;
    end bhv;
