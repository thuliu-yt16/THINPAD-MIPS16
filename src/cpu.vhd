-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;

entity cpu is
port(clk: in std_logic;
    rst: in std_logic;
    LED : out STD_LOGIC_VECTOR(15 downto 0);
    rom_ready_i : in STD_LOGIC; -- if ready or not.
    rom_data_i : in STD_LOGIC_VECTOR(15 downto 0); -- 取得指令
    rom_addr_o : out STD_LOGIC_VECTOR(15 downto 0); -- 指令地址
    rom_ce_o : out STD_LOGIC; -- 指令存储器使能

    ram_ready_i : in STD_LOGIC;
    ram_rdata_i : in STD_LOGIC_VECTOR(15 downto 0);
    ram_read_o : out STD_LOGIC;
    ram_write_o : out STD_LOGIC;
    ram_addr_o : out STD_LOGIC_VECTOR(15 downto 0);
    ram_wdata_o : out STD_LOGIC_VECTOR(15 downto 0);
    ram_ce_o : out STD_LOGIC
    );
end cpu;

architecture bhv of cpu is

component pc
    port (stall: in std_logic_vector(5 downto 0);
    flush: in std_logic;

    clk: in std_logic;
    rst: in std_logic;

    branch_flag_i: in std_logic;
    branch_target_address_i: std_logic_vector(15 downto 0);
    -- new_pc_i: in std_logic_vector(15 downto 0);

    pc_o: out std_logic_vector(15 downto 0);
    ce_o: out std_logic
    );
end component;

component if_id
  port(clk: in std_logic;
       rst: in std_logic;

       stall: in std_logic_vector(5 downto 0);
       flush: in std_logic;

       if_pc_i: in std_logic_vector(15 downto 0);
       if_inst_i: in std_logic_vector(15 downto 0);

       id_pc_o: out std_logic_vector(15 downto 0);
       id_inst_o: out std_logic_vector(15 downto 0)
       );
end component;

component id
  port(rst: in std_logic;
  pc_i: in std_logic_vector(15 downto 0); --当前pc 地址
  inst_i: in std_logic_vector(15 downto 0); -- 当前指令
  -- load command needs ex op
  ex_aluop_i: in std_logic_vector(7 downto 0);
  -- TODO 旁路
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
end component;

component reg
  port(clk: in std_logic;
      rst: in std_logic;

      re1_i: in std_logic;
      rd1_i: in std_logic_vector(3 downto 0);
      re2_i: in std_logic;
      rd2_i: in std_logic_vector(3 downto 0);

      -- 来自 WB
      we_i: in std_logic;
      wd_i: in std_logic_vector(3 downto 0);
      wdata_i: in std_logic_vector(15 downto 0);

      -- ID 用
      rdata1_o: out std_logic_vector(15 downto 0);
      rdata2_o: out std_logic_vector(15 downto 0)
      );
end component;

component id_ex
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
    ex_inst_o: in std_logic_vector(15 downto 0)
    -- ex_current_inst_addr is previously deleted.
    -- ex_is_in_delayslot is previously deleted.
    -- ex_link_addr is previously deleted.
    -- is_in_delayslot_o is previously deleted.
    );
end component;
component ex
    port(aluop_i: in std_logic_vector(7 downto 0);
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
    reg2_data_o: out std_logic_vector(15 downto 0);
    wd_o: out std_logic_vector(3 downto 0);
    we_o: out std_logic;
    aluop_o: out std_logic_vector(7 downto 0);
    wdata_o: out std_logic_vector(15 downto 0);
    -- current_inst_address_o is previously deleted.
    -- is_in_delayslot_o is previously deleted.

    stallreq: out std_logic
    );
end component;
component ex_mem
  port(clk: in std_logic;
       rst: in std_logic;

       stall: in std_logic_vector(5 downto 0);
       flush: in std_logic;

       ex_mem_addr_i: in std_logic_vector(15 downto 0); -- mem阶段读内存地址
       ex_reg2_data_i: in std_logic_vector(15 downto 0); -- 第二个寄存器的内容
       ex_wd_i: in std_logic_vector(3 downto 0); -- 写回阶段目标寄存器索引
       ex_we_i: in std_logic; -- 写回阶段是否写回
       ex_wdata_i: in std_logic_vector(15 downto 0); -- 写回阶段的写回数据
       ex_aluop_i: in std_logic_vector(7 downto 0); -- alu操作 ?
       -- ex_current_inst_address is previously deleted.
       -- ex_is_in_delayslot is previously deleted.

       mem_mem_addr_o: out std_logic_vector(15 downto 0);
       mem_reg2_data_o: out std_logic_vector(15 downto 0);
       mem_wd_o: out std_logic_vector(3 downto 0);
       mem_we_o: out std_logic;
       mem_wdata_o: out std_logic_vector(15 downto 0);
       mem_aluop_o: out std_logic_vector(7 downto 0)
       -- mem_current_inst_address is previously deleted.
       -- mem_is_in_delayslot is previously deleted.
       );
end component;
component mem
  port(rst: in std_logic;
       mem_data_i: in std_logic_vector(15 downto 0);
       mem_addr_i: in std_logic_vector(15 downto 0);
       reg2_data_i: in std_logic_vector(15 downto 0);
       wd_i: in std_logic_vector(3 downto 0);
       we_i: in std_logic;
       wdata_i: in std_logic_vector(15 downto 0);
       aluop_i: in std_logic_vector(7 downto 0);
       -- current_inst_address_i is previously deleted.
       -- is_in_delayslot_i is previously deleted.

       -- mem/wb 用
       wd_o: out std_logic_vector(3 downto 0);
       we_o: out std_logic;
       wdata_o: out std_logic_vector(15 downto 0);
       -- current_inst_address_i is previously deleted.
       -- is_in_delayslot_i is previously deleted.

       -- RAM 用
       mem_we_o: out std_logic;
       mem_ce_o: out std_logic;
       mem_data_o: out std_logic_vector(15 downto 0);
       mem_addr_o: out std_logic_vector(15 downto 0)
       -- mem_sel_o: out std_logic_vector(2 downto 0)
       );
end component;
component mem_wb
  port(clk: in std_logic;
       rst: in std_logic;

       stall: in std_logic_vector(5 downto 0);
       flush: in std_logic;

       mem_wd_i: in std_logic_vector(3 downto 0);
       mem_we_i: in std_logic;
       mem_wdata_i: in std_logic_vector(15 downto 0);

       wb_wd_o: out std_logic_vector(3 downto 0);
       wb_we_o: out std_logic;
       wb_wdata_o: out std_logic_vector(15 downto 0)
       );
end component;

component ctrl
  port(rst: in std_logic;

       stallreq_from_ex_i: in std_logic;
       stallreq_from_id_i: in std_logic;

       stall: out std_logic_vector(5 downto 0);
       flush: out std_logic
       );
end component;



begin

end bhv;
