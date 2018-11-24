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
  pc_i: in std_logic_vector(15 downto 0); --当前pc 地址
  inst_i: in std_logic_vector(15 downto 0); -- 当前指令
  -- load command needs ex op
  ex_aluop_i: in std_logic_vector(7 downto 0);
  -- TODO panglu
  ex_we_i: in std_logic;
  ex_wd_i: in std_logic_vector(3 downto 0);
  ex_wdata_i: in std_logic_vector(15 downto 0);

  mem_we_i: in std_logic;
  mem_wd_i: in std_logic_vector(3 downto 0);
  mem_wdata_i: in std_logic_vector(15 downto 0);
  -- is_in_delayslot_i is previously deleted.

  reg1_data_i: in std_logic_vector(15 downto 0); --  从reg1读的数据
  reg2_data_i: in std_logic_vector(15 downto 0); --  从reg1读的数据

  -- ID/EX 用
  aluop_o: out std_logic_vector(7 downto 0); -- alu 执行的操作
  -- nop control signals
  alusel_o: out std_logic_vector(2 downto 0); -- alu 执行操作的种类

  reg1_data_o: out std_logic_vector(15 downto 0); -- 从reg1读的数据
  reg2_data_o: out std_logic_vector(15 downto 0); -- 从reg2读的数据

  wd_o: out std_logic_vector(3 downto 0); -- 要写入的目的寄存器索引
  we_o: out std_logic; -- 是否要写入目的寄存器

  inst_o: out std_logic_vector(15 downto 0); -- 传递指令内容
  -- current_inst_address_o is previously deleted.
  -- is_in_delayslot_o is previously deleted.
  -- link_addr_o is previously deleted.
  -- next_inst_in_delayslot_o is previously deleted.

  -- 寄存器堆用
  reg1_re_o: out std_logic;
  reg1_rd_o: out std_logic_vector(3 downto 0);
  reg2_re_o: out std_logic;
  reg2_rd_o: out std_logic_vector(3 downto 0);

  -- 控制用
  stallreq: out std_logic;

  -- PC 用
  branch_flag_o: out std_logic; -- Diable -- Enable
  branch_target_address_o: out std_logic_vector(15 downto 0));
end id;

architecture bhv of id is
  signal reg1_re, reg2_re, instvalid: std_logic; -- instuction is valid or not
  signal reg1_data, reg2_data, imm: std_logic_vector(15 downto 0);
  signal imm8: std_logic_vector(7 downto 0);
  signal rx, ry, rz: std_logic_vector(3 downto 0);
  signal op: std_logic_vector(15 downto 11);
  begin

    inst_o <= inst_i;
    reg1_re_o <= reg1_re;
    reg2_re_o <= reg2_re;
    reg1_data <= reg1_data_i;
    reg2_data <= reg2_data_i;

    ID_PROCESS: process(rst, pc_i, inst_i)
    begin
      if (rst = Enable) then
        aluop_o <= EXE_NOP_OP;
        alusel_o <= EXE_RES_NOP;
        instvalid <= Disable;
        we_o <= Disable;
        reg1_re <= Disable;
        reg2_re <= Disable;
        wd_o  <= RegAddrZero;
        reg1_rd_o <= RegAddrZero;
        reg2_rd_o <= RegAddrZero;
        imm <= ZeroWord;
        branch_flag_o <= Disable;
        branch_target_address_o <= ZeroWord;

      else
        aluop_o <= EXE_NOP_OP;
        alusel_o <= EXE_RES_NOP;
        instvalid <= Disable;
        we_o <= Disable;
        reg1_re <= Disable;
        reg2_re <= Disable;
        wd_o <= RegAddrZero;
        rx <= "0" & inst_i(10 downto 8);
        ry <= "0" & inst_i(7 downto 5);
        rz <= "0" & inst_i(4 downto 2);
        imm <= ZeroWord;

        case op is
          when "01101" => -- LI
            aluop_o <= EXE_LI_OP;
            alusel_o <= EXE_RES_LOGIC;
            instvalid <= Enable;
            we_o <= Enable;
            reg1_re <= Disable;
            reg2_re <= Disable;
            wd_o <= rx;
            imm <= EXT(imm8, 16);
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
      elsif (reg1_re = Enable) then
        reg2_data_o <= reg2_data;
      elsif (reg1_re = Disable) then
        reg2_data_o <= imm;
      else
        reg2_data_o <= ZeroWord;
      end if;
    end process;
  end bhv;
