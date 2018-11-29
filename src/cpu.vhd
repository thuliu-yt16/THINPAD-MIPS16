-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;

entity cpu is
    port(clk: in std_logic;
    rst: in std_logic;

    led : out std_logic_vector(15 downto 0);

    rom_ready_i : in std_logic; -- if ready or not.
    rom_data_i : in std_logic_vector(15 downto 0); -- ȡ��ָ��

    rom_addr_o : out std_logic_vector(15 downto 0); -- ָ����ַ
    rom_ce_o : out std_logic; -- ָ���洢��ʹ��

    ram_ready_i : in std_logic;
    ram_rdata_i : in std_logic_vector(15 downto 0);

    ram_we_o: out std_logic;
    ram_re_o: out std_logic;
    -- ram_read_o : out STD_LOGIC;
    -- ram_write_o : out STD_LOGIC;
    ram_addr_o : out std_logic_vector(15 downto 0);
    ram_wdata_o : out std_logic_vector(15 downto 0);
    ram_ce_o : out std_logic
    );
end cpu;

architecture bhv of cpu is

    -- pc -> if/id
    signal ifid_pc_o: std_logic_vector(15 downto 0); -- if_pc_i

    -- if/id -> id
    signal id_pc_o: std_logic_vector(15 downto 0); -- pc_i
    signal id_inst_o: std_logic_vector(15 downto 0); -- inst_i

    -- if/id -> id/ex
    -- signal idex_stallsignal_o: std_logic;
    -- if/id -> ctrl
    signal ifid_ctrl_stallreq_o: std_logic;

    -- id -> id/ex
    signal idex_aluop_o: std_logic_vector(7 downto 0); -- id_aluop_i
    signal idex_alusel_o: std_logic_vector(2 downto 0); -- id_alusel_i
    signal idex_reg1_data_o: std_logic_vector(15 downto 0); -- id_reg1_i
    signal idex_reg2_data_o: std_logic_vector(15 downto 0); -- id_reg2_i
    signal idex_wd_o: std_logic_vector(3 downto 0); -- id_wd_i
    signal idex_we_o: std_logic; -- id_we_i
    signal idex_inst_o: std_logic_vector(15 downto 0); -- id_inst_i

    -- id/ex -> ex
    signal ex_aluop_o: std_logic_vector(7 downto 0); -- aluop_i
    signal ex_alusel_o: std_logic_vector(2 downto 0); -- alusel_i
    signal ex_reg1_data_o: std_logic_vector(15 downto 0);-- re1_data_i
    signal ex_reg2_data_o: std_logic_vector(15 downto 0);-- reg2_data_i
    signal ex_wd_o: std_logic_vector(3 downto 0); -- wd_i
    signal ex_we_o: std_logic; -- we_i
    signal ex_inst_o: std_logic_vector(15 downto 0); -- inst_i

    -- id/ex -> ex/mem
    -- signal exmem_stallsignal_o: std_logic;
    -- id/ex -> ctrl
    -- signal idex_ctrl_stallreq_o: std_logic;

    -- ex -> ex/mem
    signal exmem_mem_addr_o: std_logic_vector(15 downto 0); --ex_mem_addr_i
    signal exmem_mem_ce_o: std_logic; -- ex_mem_ce_i
    signal exmem_mem_we_o: std_logic; -- ex_mem_we_i
    signal exmem_mem_re_o: std_logic; -- ex_mem_re_i
    signal exmem_mem_wdata_o: std_logic_vector(15 downto 0); -- ex_mem_wdata_i

    signal exmem_wd_o: std_logic_vector(3 downto 0); -- ex_wd_i
    signal exmem_we_o: std_logic;  -- ex_we_i
    signal exmem_wdata_o: std_logic_vector(15 downto 0); -- ex_wdata_i
    signal exmem_aluop_o: std_logic_vector(7 downto 0);  -- ex_aluop_i

    -- ex/mem -> mem
    signal mem_mem_addr_o: std_logic_vector(15 downto 0); -- mem_addr_i
    signal mem_mem_ce_o: std_logic; -- mem_ce_i
    signal mem_mem_we_o: std_logic; -- mem_we_i
    signal mem_mem_re_o: std_logic; -- mem_re_i
    signal mem_mem_wdata_o: std_logic_vector(15 downto 0); -- mem_wdata_i

    signal mem_wd_o: std_logic_vector(3 downto 0); -- wd_i
    signal mem_we_o: std_logic; -- we_i
    signal mem_wdata_o: std_logic_vector(15 downto 0); -- wdata_i
    signal mem_aluop_o: std_logic_vector(7 downto 0); -- aluop_i

    -- ex/mem -> ctrl
    -- signal exmem_ctrl_stallreq_o: std_logic;

    -- mem -> mem/wb
    signal memwb_wd_o: std_logic_vector(3 downto 0); -- mem_wd_i
    signal memwb_we_o: std_logic; -- mem_we_i
    signal memwb_wdata_o: std_logic_vector(15 downto 0); -- mem_wdata_i

    -- mem/wb -> reg
    signal reg_we_o: std_logic; -- we_i
    signal reg_wd_o: std_logic_vector(3 downto 0); -- wd_i
    signal reg_wdata_o: std_logic_vector(15 downto 0); -- wdata_i

    -- id -> reg
    signal reg_reg1_re_o: std_logic; -- re1_i
    signal reg_reg1_rd_o: std_logic_vector(3 downto 0); -- rd1_i
    signal reg_reg2_re_o: std_logic; -- re2_i
    signal reg_reg2_rd_o: std_logic_vector(3 downto 0); -- rd2_i

    -- reg -> id
    signal id_rdata1_o: std_logic_vector(15 downto 0); -- reg1_data_i
    signal id_rdata2_o: std_logic_vector(15 downto 0); -- reg2_data_i

    -- ex -> id  ��·
    --signal exmem_wd_o: std_logic_vector(3 downto 0); -- ex_wd_i
    --signal exmem_we_o: std_logic;  -- ex_we_i
    --signal exmem_wdata_o: std_logic_vector(15 downto 0); -- ex_wdata_i
    --signal exmem_aluop_o: std_logic_vector(7 downto 0);  -- ex_aluop_i

    --signal id_wd_o: std_logic_vector(3 downto 0); -- ex_wd_i
    --signal id_we_o: std_logic; -- ex_we_i
    --signal id_aluop_o: std_logic_vector(7 downto 0); -- ex_aluop_i
    --signal id_wdata_o: std_logic_vector(15 downto 0); -- ex_wdata_i
    -- mem -> id��·

    -- id -> pc
    signal pc_branch_flag_o: std_logic; -- branch_flag_i
    signal pc_branch_target_address_o: std_logic_vector(15 downto 0); -- branch_target_address_i

    --ctrl
    signal stallreq_from_if_id_i: std_logic;
    -- signal stallreq_from_id_ex_i: std_logic;
    -- signal stallreq_from_ex_mem_i: std_logic;
    signal stallreq_from_ex_i: std_logic;
    signal stallreq_from_id_i: std_logic;
    signal stall: std_logic_vector(5 downto 0);
    signal flush: std_logic;

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
id_inst_o: out std_logic_vector(15 downto 0);

-- stallsignal_o: out std_logic;
stallreq_o: out std_logic
);
end component;

component id
port(rst: in std_logic;
pc_i: in std_logic_vector(15 downto 0); --��ǰpc ��ַ
inst_i: in std_logic_vector(15 downto 0); -- ��ǰָ��
-- load command needs ex op
-- TODO ��·
ex_we_i: in std_logic;
ex_wd_i: in std_logic_vector(3 downto 0);
ex_wdata_i: in std_logic_vector(15 downto 0);
ex_aluop_i: in std_logic_vector(7 downto 0);

mem_we_i: in std_logic;
mem_wd_i: in std_logic_vector(3 downto 0);
mem_wdata_i: in std_logic_vector(15 downto 0);
-- is_in_delayslot_i is previously deleted.
reg1_data_i: in std_logic_vector(15 downto 0); --  ��reg1��������
reg2_data_i: in std_logic_vector(15 downto 0); --  ��reg2��������

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
end component;

component reg
port(clk: in std_logic;
rst: in std_logic;

re1_i: in std_logic;
rd1_i: in std_logic_vector(3 downto 0);
re2_i: in std_logic;
rd2_i: in std_logic_vector(3 downto 0);

-- ���� WB
we_i: in std_logic;
wd_i: in std_logic_vector(3 downto 0);
wdata_i: in std_logic_vector(15 downto 0);

-- ID ��
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
-- ex_current_inst_addr is previously deleted.
-- ex_is_in_delayslot is previously deleted.
-- ex_link_addr is previously deleted.
-- is_in_delayslot_o is previously deleted.
-- stallreq_o: out std_logic;
-- stallsignal_o: out std_logic
);
end component;

component ex
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

-- ex/mem ��
mem_addr_o: out std_logic_vector(15 downto 0);
mem_ce_o: out std_logic;
mem_we_o: out std_logic;
mem_re_o: out std_logic;
mem_wdata_o: out std_logic_vector(15 downto 0);

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

ex_mem_addr_i: in std_logic_vector(15 downto 0);
ex_mem_ce_i: in std_logic;
ex_mem_we_i: in std_logic;
ex_mem_re_i: in std_logic;
ex_mem_wdata_i: in std_logic_vector(15 downto 0);

ex_wd_i: in std_logic_vector(3 downto 0);
ex_we_i: in std_logic;
ex_wdata_i: in std_logic_vector(15 downto 0);
ex_aluop_i: in std_logic_vector(7 downto 0);

-- stallsignal_i: in std_logic;
-- ex_current_inst_address is previously deleted.
-- ex_is_in_delayslot is previously deleted.

mem_mem_addr_o: out std_logic_vector(15 downto 0);
mem_mem_ce_o: out std_logic;
mem_mem_we_o: out std_logic;
mem_mem_re_o: out std_logic;
mem_mem_wdata_o: out std_logic_vector(15 downto 0);

mem_wd_o: out std_logic_vector(3 downto 0);
mem_we_o: out std_logic;
mem_wdata_o: out std_logic_vector(15 downto 0);
mem_aluop_o: out std_logic_vector(7 downto 0)
-- mem_current_inst_address is previously deleted.
-- mem_is_in_delayslot is previously deleted.
-- stallreq_o: out std_logic
);
end component;

component mem
port(rst: in std_logic;
mem_data_i: in std_logic_vector(15 downto 0);

mem_addr_i: in std_logic_vector(15 downto 0);
mem_ce_i: in std_logic;
mem_we_i: in std_logic;
mem_re_i: in std_logic;
mem_wdata_i: in std_logic_vector(15 downto 0);

wd_i: in std_logic_vector(3 downto 0);
we_i: in std_logic;
wdata_i: in std_logic_vector(15 downto 0);
aluop_i: in std_logic_vector(7 downto 0);
-- current_inst_address_i is previously deleted.
-- is_in_delayslot_i is previously deleted.

-- mem/wb �� idҲ�� ��·
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

     stallreq_from_if_id_i: in std_logic;
     -- stallreq_from_id_ex_i: in std_logic;
     -- stallreq_from_ex_mem_i: in std_logic;
     stallreq_from_id_i: in std_logic;
     stallreq_from_ex_i: in std_logic;

     stall_o: out std_logic_vector(5 downto 0);
     flush_o: out std_logic
     );
end component;

begin
    rom_addr_o <= ifid_pc_o;
    pc_component: pc port map(
    stall => stall,
    flush => flush,

    clk => clk,
    rst => rst,

    branch_flag_i => pc_branch_flag_o,
    branch_target_address_i => pc_branch_target_address_o,

    pc_o => ifid_pc_o,
    ce_o => rom_ce_o);
    if_id_component: if_id port map(
    clk => clk,
    rst => rst,

    stall => stall,
    flush => flush,

    if_pc_i => ifid_pc_o,
    if_inst_i => rom_data_i,

    id_pc_o => id_pc_o,
    id_inst_o => id_inst_o,

    -- stallsignal_o => idex_stallsignal_o,
    stallreq_o => ifid_ctrl_stallreq_o
    );
    id_component: id port map(
    rst => rst,
    pc_i => id_pc_o,
    inst_i => id_inst_o,

    ex_aluop_i => exmem_aluop_o,
    ex_we_i => exmem_we_o,
    ex_wd_i => exmem_wd_o,
    ex_wdata_i => exmem_wdata_o,
    mem_we_i => memwb_we_o,
    mem_wd_i => memwb_wd_o,
    mem_wdata_i => memwb_wdata_o,

    reg1_data_i => id_rdata1_o,
    reg2_data_i => id_rdata2_o,

    aluop_o => idex_aluop_o,
    alusel_o => idex_alusel_o,
    reg1_data_o => idex_reg1_data_o,
    reg2_data_o => idex_reg2_data_o,
    wd_o => idex_wd_o,
    we_o => idex_we_o,
    inst_o => idex_inst_o,

    reg1_re_o => reg_reg1_re_o,
    reg1_rd_o => reg_reg1_rd_o,
    reg2_re_o => reg_reg2_re_o,
    reg2_rd_o => reg_reg2_rd_o,

    stallreq => stallreq_from_id_i,

    branch_flag_o => pc_branch_flag_o,
    branch_target_address_o => pc_branch_target_address_o);
    id_ex_component: id_ex port map(
    clk => clk,
    rst => rst,
    stall => stall,
    flush => flush,
    id_aluop_i => idex_aluop_o,
    id_alusel_i => idex_alusel_o,
    id_reg1_data_i => idex_reg1_data_o,
    id_reg2_data_i => idex_reg2_data_o,
    id_wd_i => idex_wd_o,
    id_we_i => idex_we_o,
    id_inst_i => idex_inst_o,
    -- stallsignal_i => idex_stallsignal_o,

    ex_aluop_o => ex_aluop_o,
    ex_alusel_o => ex_alusel_o,
    ex_reg1_data_o => ex_reg1_data_o,
    ex_reg2_data_o => ex_reg2_data_o,
    ex_wd_o => ex_wd_o,
    ex_we_o => ex_we_o,
    ex_inst_o => ex_inst_o
    -- stallsignal_o => exmem_stallsignal_o,
    -- stallreq_o => idex_ctrl_stallreq_o
    );
    ex_component: ex port map(
    rst => rst,
    aluop_i => ex_aluop_o,
    alusel_i => ex_alusel_o,
    reg1_data_i => ex_reg1_data_o,
    reg2_data_i => ex_reg2_data_o,
    wd_i => ex_wd_o,
    we_i => ex_we_o,
    inst_i => ex_inst_o,

    mem_addr_o => exmem_mem_addr_o,
    mem_ce_o => exmem_mem_ce_o,
    mem_we_o => exmem_mem_we_o,
    mem_re_o => exmem_mem_re_o,
    mem_wdata_o => exmem_mem_wdata_o,

    wd_o => exmem_wd_o,
    we_o => exmem_we_o,
    aluop_o => exmem_aluop_o,
    wdata_o => exmem_wdata_o,

    stallreq => stallreq_from_ex_i);
    ex_mem_component: ex_mem port map(
    clk => clk,
    rst => rst,
    stall => stall,
    flush => flush,

    ex_mem_addr_i => exmem_mem_addr_o,
    ex_mem_ce_i => exmem_mem_ce_o,
    ex_mem_we_i => exmem_mem_we_o,
    ex_mem_re_i => exmem_mem_re_o,
    ex_mem_wdata_i => exmem_mem_wdata_o,

    ex_wd_i => exmem_wd_o,
    ex_we_i => exmem_we_o,
    ex_wdata_i => exmem_wdata_o,
    ex_aluop_i => exmem_aluop_o,
    -- stallsignal_i => exmem_stallsignal_o,

    mem_mem_addr_o => mem_mem_addr_o,
    mem_mem_ce_o => mem_mem_ce_o,
    mem_mem_we_o => mem_mem_we_o,
    mem_mem_re_o => mem_mem_re_o,
    mem_mem_wdata_o => mem_mem_wdata_o,

    mem_wd_o => mem_wd_o,
    mem_we_o => mem_we_o,
    mem_wdata_o => mem_wdata_o,
    mem_aluop_o => mem_aluop_o
    -- stallreq_o => exmem_ctrl_stallreq_o
    );
    mem_component: mem port map(
    rst => rst,
    mem_data_i => ram_rdata_i,

    mem_addr_i => mem_mem_addr_o,

    mem_ce_i => mem_mem_ce_o,
    mem_we_i => mem_mem_we_o,
    mem_re_i => mem_mem_re_o,
    mem_wdata_i => mem_mem_wdata_o,

    wd_i => mem_wd_o,
    we_i => mem_we_o,
    wdata_i => mem_wdata_o,
    aluop_i => mem_aluop_o,

    wd_o => memwb_wd_o,
    we_o => memwb_we_o,
    wdata_o => memwb_wdata_o,

    mem_we_o => ram_we_o,
    mem_ce_o => ram_ce_o,
    mem_re_o => ram_re_o,
    mem_wdata_o => ram_wdata_o,
    mem_addr_o => ram_addr_o);
    mem_wb_component: mem_wb port map(
    clk => clk,
    rst => rst,
    stall => stall,
    flush => flush,

    mem_wd_i => memwb_wd_o,
    mem_we_i => memwb_we_o,
    mem_wdata_i => memwb_wdata_o,

    wb_wd_o => reg_wd_o,
    wb_we_o => reg_we_o,
    wb_wdata_o => reg_wdata_o);
    ctrl_component: ctrl port map(
    rst => rst,
    stallreq_from_if_id_i => stallreq_from_if_id_i,
    -- stallreq_from_id_ex_i => stallreq_from_id_ex_i,
    -- stallreq_from_ex_mem_i => stallreq_from_ex_mem_i,
    stallreq_from_ex_i => stallreq_from_ex_i,
    stallreq_from_id_i => stallreq_from_id_i,
    stall_o => stall,
    flush_o => flush);
    reg_component: reg port map(
    clk => clk,
    rst => rst,
    re1_i => reg_reg1_re_o,
    rd1_i => reg_reg1_rd_o,
    re2_i => reg_reg2_re_o,
    rd2_i => reg_reg2_rd_o,

    we_i => reg_we_o,
    wd_i => reg_wd_o,
    wdata_i => reg_wdata_o,

    rdata1_o => id_rdata1_o,
    rdata2_o => id_rdata2_o);

end bhv;
