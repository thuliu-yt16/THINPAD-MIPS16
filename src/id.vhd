-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.define.all;

-- input ports: rst, pc_i, inst_i,
-- ex_aluop_i, ex_wreg_i, ex_wd_i, ex_wdata_i
-- mem_wreg_i, mem_wd_i, mem_wdata_i
-- is_in_delayslot_i,
-- reg1_data_i, reg2_data_i

-- output ports: aluop_o, alusel_o,
-- reg1_o, reg2_o,
-- wd_o, wreg_o,
-- inst_o, current_inst_address_o
-- is_in_delayslot_o
-- link_addr_o
-- next_inst_in_delayslot_o
-- reg1_read_o, reg1_addr_o
-- reg2_read_o, reg2_addr_o
-- stallreq, branch_flag_o
-- branch_target_address_o

entity id is
    port(rst: in std_logic;
    pc_i: in std_logic_vector(15 downto 0); --��ǰpc ��ַ
    inst_i: in std_logic_vector(15 downto 0); -- ��ǰָ��
    -- load command needs ex op
    -- TODO panglu
    ex_aluop_i: in std_logic_vector(7 downto 0);
    ex_we_i: in std_logic;
    ex_wd_i: in std_logic_vector(3 downto 0);
    ex_wdata_i: in std_logic_vector(15 downto 0);

    mem_we_i: in std_logic;
    mem_wd_i: in std_logic_vector(3 downto 0);
    mem_wdata_i: in std_logic_vector(15 downto 0);
    -- is_in_delayslot_i is previously deleted.

    reg1_data_i: in std_logic_vector(15 downto 0); --  ��reg1��������
    reg2_data_i: in std_logic_vector(15 downto 0); --  ��reg1��������

    -- ID/EX ��
    aluop_o: out std_logic_vector(7 downto 0); -- alu ִ�еĲ���
    -- nop control signals
    alusel_o: out std_logic_vector(2 downto 0); -- alu ִ�в���������

    reg1_data_o: out std_logic_vector(15 downto 0); -- ��reg1��������
    reg2_data_o: out std_logic_vector(15 downto 0); -- ��reg2��������

    wd_o: out std_logic_vector(3 downto 0); -- Ҫд����Ŀ�ļĴ�������
    we_o: out std_logic; -- �Ƿ�Ҫд��Ŀ�ļĴ���

    inst_o: out std_logic_vector(15 downto 0); -- ����ָ������
    -- current_inst_address_o is previously deleted.
    -- is_in_delayslot_o is previously deleted.
    -- link_addr_o is previously deleted.
    -- next_inst_in_delayslot_o is previously deleted.

    -- �Ĵ�������
    reg1_re_o: out std_logic;
    reg1_rd_o: out std_logic_vector(3 downto 0);
    reg2_re_o: out std_logic;
    reg2_rd_o: out std_logic_vector(3 downto 0);

    -- ������
    stallreq: out std_logic;

    -- PC ��
    branch_flag_o: out std_logic; -- Diable -- Enable
    branch_target_address_o: out std_logic_vector(15 downto 0));
end id;

architecture bhv of id is
    signal reg1_re, reg2_re, instvalid: std_logic; -- instuction is valid or not
    signal reg1_data, reg2_data, imm: std_logic_vector(15 downto 0);
    signal reg1_rd, reg2_rd: std_logic_vector(3 downto 0);
    -- signal rx, ry, rz: std_logic_vector(3 downto 0);
    signal op: std_logic_vector(15 downto 11);

    begin
        inst_o <= inst_i;
        reg1_re_o <= reg1_re;
        reg2_re_o <= reg2_re;
        reg1_rd_o <= reg1_rd;
        reg2_rd_o <= reg2_rd;
        -- ������·
        -- reg1_data <= reg1_data_i;
        -- reg2_data <= reg2_data_i;

        ID_PROCESS: process(rst, pc_i, inst_i)
        variable op: std_logic_vector(4 downto 0);
        variable rx, ry, rz : STD_LOGIC_VECTOR(3 downto 0);
        variable imm3: std_logic_vector(2 downto 0);
        variable imm4: std_logic_vector(3 downto 0);
        variable imm5: std_logic_vector(4 downto 0);
        variable imm8: std_logic_vector(7 downto 0);
        variable imm11: std_logic_vector(10 downto 0);
        variable cur_pc: std_logic_vector(15 downto 0);
        variable func10_8: std_logic_vector(2 downto 0);
        variable func4_0: std_logic_vector(4 downto 0);
        variable func7_5: std_logic_vector(2 downto 0);
        variable func1_0: std_logic_vector(1 downto 0);


        begin
            if (rst = Enable) then
                instvalid <= Disable;
                imm <= ZeroWord;
                branch_flag_o <= Disable;
                branch_target_address_o <= ZeroWord;

                reg1_re <= Disable;
                reg2_re <= Disable;
                reg1_rd <= RegAddrZero;
                reg2_rd <= RegAddrZero;

                aluop_o <= EXE_NOP_OP;
                alusel_o <= EXE_RES_NOP;

                we_o <= Disable;
                wd_o  <= RegAddrZero;
            else
                instvalid <= Disable;
                imm <= ZeroWord;
                branch_flag_o <= Disable;
                branch_target_address_o <= ZeroWord;

                reg1_re <= Disable;
                reg2_re <= Disable;
                reg1_rd <= RegAddrZero;
                reg2_rd <= RegAddrZero;

                aluop_o <= EXE_NOP_OP;
                alusel_o <= EXE_RES_NOP;

                we_o <= Disable;
                wd_o <= RegAddrZero;
                rx := "0" & inst_i(10 downto 8);
                ry := "0" & inst_i(7 downto 5);
                rz := "0" & inst_i(4 downto 2);
                op := inst_i(15 downto 11);
                imm3:= inst_i(4 downto 2);
                imm4:= inst_i(3 downto 0);
                imm5:= inst_i(4 downto 0);
                imm8:= inst_i(7 downto 0);
                imm11:= inst_i(10 downto 0);
                cur_pc := pc_i + OneWord;
                func10_8:= inst_i(10 downto 8);
                func4_0:= inst_i(4 downto 0);
                func7_5:= inst_i(7 downto 5);
                func1_0:= inst_i(1 downto 0);

                case op is
                    when "01001" => -- ADDIU
                        aluop_o <= EXE_ADDIU_OP;
                        alusel_o <= EXE_RES_LOGIC;
                        instvalid <= Enable;
                        we_o <= Enable;
                        wd_o <= rx;
                        imm <= SXT(imm8, 16);
                        reg1_re <= Enable;
                        reg1_rd <= rx;
                    when "01000" => -- ADDIU3
                        aluop_o <= EXE_ADDIU3_OP;
                        alusel_o <= EXE_RES_LOGIC;
                        instvalid <= Enable;
                        we_o <= Enable;
                        wd_o <= ry;
                        imm <= SXT(imm4, 16);
                        reg1_re <= Enable;
                        reg1_rd <= rx;
                    when "00000" => -- ADDSP3
                        aluop_o <= EXE_ADDSP3_OP;
                        alusel_o <= EXE_RES_LOGIC;
                        instvalid <= Enable;
                        we_o <= Enable;
                        wd_o <= rx;
                        imm <= SXT(imm8, 16);
                        reg1_re <= Enable;
                        reg1_rd <= REG_SP;
                    when "01100" =>
                        case func10_8 is
                            when "011" =>-- ADDSP
                                aluop_o <= EXE_ADDSP_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= REG_SP;
                                imm <= SXT(imm8, 16);
                                reg1_re <= Enable;
                                reg1_rd <= REG_SP;
                            when "000" => -- BTEQZ
                                instvalid <= Enable;
                                reg1_re <= Enable;
                                reg1_rd <= REG_T;
                                imm <= SXT(imm8, 16);
                                if(reg1_data = ZeroWord) then
                                    branch_flag_o <= Enable;
                                    branch_target_address_o <= cur_pc + imm;
                                end if;
                            when "100" => -- MTSP
                                aluop_o <= EXE_MTSP_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= REG_SP;
                                reg1_re <= Enable;
                                reg1_rd <= ry;
                            when "010" => -- SW_RS
                                aluop_o <= EXE_SW_RS_OP;
                                alusel_o <= EXE_RES_LOAD_STORE;
                                instvalid <= Enable;
                                reg1_re <= Enable;
                                reg1_rd <= REG_SP;
                                reg2_re <= Enable;
                                reg2_rd <= REG_RA;
                            when others =>
                        end case;
                    when "11100" =>
                        case func1_0 is
                            when "01" => -- ADDU
                                aluop_o <= EXE_ADDU_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= rz;
                                reg1_re <= Enable;
                                reg2_re <= Enable;
                                reg1_rd <= rx;
                                reg2_rd <= ry;
                            when "11" => -- SUBU
                                aluop_o <= EXE_SUBU_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= rz;
                                reg1_re <= Enable;
                                reg2_re <= Enable;
                                reg1_rd <= rx;
                                reg2_rd <= ry;
                            when others =>
                        end case;
                    when "11101" => -- AND
                        case func4_0 is
                            when "01100" => -- AND
                                aluop_o <= EXE_AND_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= rx;
                                reg1_re <= Enable;
                                reg2_re <= Enable;
                                reg1_rd <= rx;
                                reg2_rd <= ry;
                            when "01010" => --CMP
                                aluop_o <= EXE_CMP_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= REG_T;
                                reg1_re <= Enable;
                                reg2_re <= Enable;
                                reg1_rd <= rx;
                                reg2_rd <= ry;
                            when "00000" =>
                                case func7_5 is
                                    when "000" => -- JR
                                        instvalid <= Enable;
                                        reg1_re <= Enable;
                                        reg1_rd <= rx;
                                        branch_flag_o <= Enable;
                                        branch_target_address_o <= reg1_data;
                                    when "010" => -- MFPC
                                        aluop_o <= EXE_MFPC_OP;
                                        alusel_o <= EXE_RES_LOGIC;
                                        instvalid <= Enable;
                                        we_o <= Enable;
                                        wd_o <= rx;
                                        imm <= cur_pc;
                                    when others =>
                                end case;
                            when "01101" => -- OR
                                aluop_o <= EXE_OR_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= rx;
                                reg1_re <= Enable;
                                reg2_re <= Enable;
                                reg1_rd <= rx;
                                reg2_rd <= ry;
                            when "00010" => -- SLT
                                aluop_o <= EXE_SLT_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= REG_T;
                                reg1_re <= Enable;
                                reg2_re <= Enable;
                                reg1_rd <= rx;
                                reg2_rd <= ry;
                            when others =>
                        end case;
                    when "00010" => -- B
                        instvalid <= Enable;
                        imm <= SXT(imm11, 16);
                        branch_flag_o <= Enable;
                        branch_target_address_o <= cur_pc + imm;
                    when "00100" => -- BEQZ
                        instvalid <= Enable;
                        reg1_re <= Enable;
                        reg1_rd <= rx;
                        imm <= SXT(imm8, 16);
                        if(reg1_data = ZeroWord) then
                            branch_flag_o <= Enable;
                            branch_target_address_o <= cur_pc + imm;
                        end if;
                    when "00101" => --BNEZ
                        instvalid <= Enable;
                        reg1_re <= Enable;
                        reg1_rd <= rx;
                        imm <= SXT(imm8, 16);
                        if(reg1_data /= ZeroWord) then
                            branch_flag_o <= Enable;
                            branch_target_address_o <= cur_pc + imm;
                        end if;
                    when "01101" => -- LI
                        aluop_o <= EXE_LI_OP;
                        alusel_o <= EXE_RES_LOGIC;
                        instvalid <= Enable;
                        we_o <= Enable;
                        wd_o <= rx;
                        imm <= EXT(imm8, 16);
                    when "10011" => -- LW
                        aluop_o <= EXE_LW_OP;
                        alusel_o <= EXE_RES_LOAD_STORE;
                        instvalid <= Enable;
                        we_o <= Enable;
                        wd_o <= ry;
                        imm <= SXT(imm5, 16);
                        reg1_re <= Enable;
                        reg1_rd <= rx;
                    when "10010" => -- LW_SP
                        aluop_o <= EXE_LW_SP_OP;
                        alusel_o <= EXE_RES_LOAD_STORE;
                        instvalid <= Enable;
                        we_o <= Enable;
                        wd_o <= rx;
                        imm <= SXT(imm8, 16);
                        reg1_re <= Enable;
                        reg1_rd <= REG_SP;
                    when "11110" => -- MFIH
                        case imm8 is
                            when "00000000" => -- MFIH
                                aluop_o <= EXE_MFIH_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= rx;
                                reg1_re <= Enable;
                                reg1_rd <= REG_IH;
                            when "00000001" => -- MTIH
                                aluop_o <= EXE_MTIH_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= REG_IH;
                                reg1_re <= Enable;
                                reg1_rd <= rx;
                            when others =>
                        end case;
                    when "01111" => -- MOVE
                        aluop_o <= EXE_MOVE_OP;
                        alusel_o <= EXE_RES_LOGIC;
                        instvalid <= Enable;
                        we_o <= Enable;
                        wd_o <= rx;
                        reg1_re <= Enable;
                        reg1_rd <= ry;
                    when "00001" => -- NOP
                        aluop_o <= EXE_NOP_OP;
                        alusel_o <= EXE_RES_NOP;
                        instvalid <= Enable;
                    when "00110" => -- SLL
                        case func1_0 is
                            when "00" => -- SLL
                                aluop_o <= EXE_SLL_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= rx;
                                imm <= EXT(imm3, 16);
                                reg1_re <= Enable;
                                reg1_rd <= ry;
                            when "11" => -- SRA
                                aluop_o <= EXE_SRA_OP;
                                alusel_o <= EXE_RES_LOGIC;
                                instvalid <= Enable;
                                we_o <= Enable;
                                wd_o <= rx;
                                imm <= EXT(imm3, 16);
                                reg1_re <= Enable;
                                reg1_rd <= ry;
                            when others =>
                        end case;
                    when "01010" => -- SLTI
                        aluop_o <= EXE_SLTI_OP;
                        alusel_o <= EXE_RES_LOGIC;
                        instvalid <= Enable;
                        we_o <= Enable;
                        wd_o <= REG_T;
                        imm <= SXT(imm8, 16);
                        reg1_re <= Enable;
                        reg1_rd <= rx;
                    when "11011" => -- SW
                        aluop_o <= EXE_SW_OP;
                        alusel_o <= EXE_RES_LOAD_STORE;
                        instvalid <= Enable;
                        imm <= SXT(imm8, 16);
                        reg1_re <= Enable;
                        reg1_rd <= rx;
                        reg2_re <= Enable;
                        reg2_rd <= ry;
                    when "11010" => -- SW_SP
                        aluop_o <= EXE_SW_SP_OP;
                        alusel_o <= EXE_RES_LOAD_STORE;
                        instvalid <= Enable;
                        reg1_re <= Enable;
                        reg1_rd <= REG_SP;
                        reg2_re <= Enable;
                        reg2_rd <= rx;
                    when others =>
                end case;
            end if;
        end process;

        REG1_PROCESS: process(rst, imm, reg1_data, reg1_re)
        begin
            if (rst = Enable) then
                reg1_data_o <= ZeroWord;
            elsif (reg1_re = Enable) then
                reg1_data_o <= reg1_data;
            elsif (reg1_re = Disable) then
                reg1_data_o <= imm;
            else
                reg1_data_o <= ZeroWord;
            end if;
        end process;

        REG2_PROCESS: process(rst, imm, reg2_data, reg2_re)
        begin
            if (rst = Enable) then
                reg2_data_o <= ZeroWord;
            elsif (reg2_re = Enable) then
                reg2_data_o <= reg2_data;
            elsif (reg2_re = Disable) then
                reg2_data_o <= imm;
            else
                reg2_data_o <= ZeroWord;
            end if;
        end process;

        REG1_FORWADING: process(rst, imm, reg1_data_i, reg1_re, reg1_rd, ex_wd_i, ex_we_i, ex_wdata_i, mem_we_i, mem_wd_i, mem_wdata_i)
        begin
            if(rst = Enable) then
                reg1_data <= ZeroWord;
            elsif (reg1_re = Enable and ex_we_i = Enable and reg1_rd = ex_wd_i) then
                reg1_data <= ex_wdata_i;
            elsif (reg1_re = Enable and mem_we_i = Enable and reg1_rd = mem_wd_i) then
                reg1_data <= mem_wdata_i;
            elsif (reg1_re = Enable) then
                reg1_data <= reg1_data_i;
            else
                reg1_data <= ZeroWord;
            end if;
        end process;

        REG2_FORWADING: process(rst, imm, reg2_data_i, reg2_re, reg2_rd, ex_wd_i, ex_we_i, ex_wdata_i, mem_we_i, mem_wd_i, mem_wdata_i)
        begin
            if(rst = Enable) then
                reg2_data <= ZeroWord;
            elsif (reg2_re = Enable and ex_we_i = Enable and reg2_rd = ex_wd_i) then
                reg2_data <= ex_wdata_i;
            elsif (reg2_re = Enable and mem_we_i = Enable and reg2_rd = mem_wd_i) then
                reg2_data <= mem_wdata_i;
            elsif (reg2_re = Enable) then
                reg2_data <= reg2_data_i;
            else
                reg2_data <= ZeroWord;
            end if;
        end process;
    end bhv;
