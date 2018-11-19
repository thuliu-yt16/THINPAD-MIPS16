library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
  pc_i: in std_logic_vector(15 downto 0);
  inst_i: in std_logic_vector(15 downto 0);
  -- load command needs ex op
  ex_aluop_i: in std_logic_vector(7 downto 0);
  -- panglu
  ex_we_i: in std_logic;
  ex_wd_i: in std_logic_vector(3 downto 0);
  ex_wdata_i: in std_logic_vector(15 downto 0);
  mem_we_i: in std_logic;
  mem_wd_i: in std_logic_vector(3 downto 0);
  mem_wdata_i: in std_logic_vector(15 downto 0);
  -- is_in_delayslot_i is previously deleted.
  reg1_data_i: in std_logic_vector(15 downto 0);
  reg2_data_i: in std_logic_vector(15 downto 0);

  aluop_o: out std_logic_vector(7 downto 0);
  -- nop control signals
  alusel_o: out std_logic_vector(2 downto 0);

  reg1_data_o: out std_logic_vector(15 downto 0);
  reg2_data_o: out std_logic_vector(15 downto 0);

  wd_o: out std_logic_vector(3 downto 0);
  we_o: out std_logic;

  inst_o: out std_logic_vector(15 downto 0);
  -- current_inst_address_o is previously deleted.
  -- is_in_delayslot_o is previously deleted.
  -- link_addr_o is previously deleted.
  -- next_inst_in_delayslot_o is previously deleted.

  reg1_re_o: out std_logic;
  reg1_rd_o: out std_logic_vector(3 downto 0);
  reg2_re_o: out std_logic;
  reg2_rd_o: out std_logic_vector(3 downto 0);

  stallreq: out std_logic;
  branch_flag_o: out std_logic;
  branch_target_address_o: out std_logic_vector(15 downto 0) );
end id;

architecture bhv of id is
  begin
  end bhv;
