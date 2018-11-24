-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;

entity cpu is
  port(clk: in std_logic;
       rst: in std_logic;
       LED : out STD_LOGIC_VECTOR(15 downto 0);
       rom_ready_i : in STD_LOGIC; -- if ready or not.
       rom_data_i : in STD_LOGIC_VECTOR(15 downto 0); -- inst
       rom_addr_o : out STD_LOGIC_VECTOR(15 downto 0); -- wd
       rom_ce_o : out STD_LOGIC;
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
begin
  component pc
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
  end component;
end bhv;
