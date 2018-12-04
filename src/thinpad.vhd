-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.define.all;

entity thinpad is
port(
    rst: in std_logic;
    clk: in std_logic;

    data_ready: in std_logic;
    tbre: in std_logic;
    tsre: in std_logic;

    led : out std_logic_vector(15 downto 0);

    ram1_oe: out std_logic;
    ram1_we: out std_logic;
    ram1_en: out std_logic;
    ram1_data: inout std_logic_vector(15 downto 0);
    ram1_addr: out std_logic_vector(17 downto 0);

    rdn: out std_logic;
    wrn: out std_logic
);

end thinpad;

architecture bhv of thinpad is
signal rst_reversed: std_logic;
signal rom_ready_i: std_logic; -- if ready or not.
signal rom_data_i: std_logic_vector(15 downto 0);

signal rom_addr_o: std_logic_vector(15 downto 0);
signal rom_ce_o: std_logic;

signal ram_ready_i: std_logic;
signal ram_rdata_i: std_logic_vector(15 downto 0);

signal ram_we_o: std_logic;
signal ram_addr_o: std_logic_vector(15 downto 0);
signal ram_wdata_o: std_logic_vector(15 downto 0);
signal ram_ce_o: std_logic;
signal ram_re_o: std_logic;

signal inst_ready: std_logic;

signal rst_cpu: std_logic;
component cpu
    port(clk: in std_logic;
        rst: in std_logic;

        led : out std_logic_vector(15 downto 0);

        -- inst
        rom_ready_i : in std_logic;
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
    end component;
    component inst_rom
    port(addr_i: in std_logic_vector(15 downto 0); -- Ҫȡָ���ĵ�ַ
    ce_i: in std_logic; -- оƬʹ��
    inst_o: out std_logic_vector(15 downto 0)); -- ��ȡָ��
end component;

component ram_new
port ( clk : in std_logic;
rst : in std_logic;

--id
ce_id : in  std_logic;
addr_id : in  std_logic_vector (15 downto 0);
inst_id : out  std_logic_vector (15 downto 0);
inst_ready : out std_logic;
rom_ready_o : out std_logic;

--mem
re_i : in  std_logic;
we_i : in  std_logic;
addr_i : in  std_logic_vector (15 downto 0);
data_i : in  std_logic_vector (15 downto 0);
data_o : out  std_logic_vector (15 downto 0);
ram_ready_o : out std_logic;

--ram1
data_ready: in std_logic;
ram1_addr: out std_logic_vector(17 downto 0);
ram1_data: inout std_logic_vector(15 downto 0);
ram1_oe: out std_logic;
ram1_we: out std_logic;
ram1_en: out std_logic;

tbre: in std_logic;
tsre: in std_logic;
rdn: out std_logic;
wrn: out std_logic
);
end component;
--
-- component ram
-- port(rst: in std_logic;
-- clk: in std_logic;
-- we_i: in std_logic;
-- re_i: in std_logic;
-- ce_i: in std_logic;
-- addr_i: in std_logic_vector(15 downto 0);
-- data_i: in std_logic_vector(15 downto 0);
-- -- sel_i: in std_logic_vector(2 downto 0);
-- data_o: out std_logic_vector(15 downto 0);
--
-- ram1_oe: out std_logic;
-- ram1_we: out std_logic;
-- ram1_en: out std_logic;
-- ram1_data: inout std_logic_vector(15 downto 0);
-- ram1_addr: out std_logic_vector(17 downto 0)
-- );
--
-- end component;
signal clk_2: std_logic := '0';
signal clk_4: std_logic := '0';
begin
    rst_reversed <= not(rst);
    rst_cpu <= rst_reversed or not(inst_ready);

    CLK2:process(clk)
    begin
        if(clk'event and clk='1')then
            clk_2 <= not clk_2;
        end if;
    end process;

    --
    -- CLK4:process(clk_2)
    -- begin
    --     if(clk_2'event and clk_2 = '1')then
    --         clk_4 <= not clk_4;
    --     end if;
    -- end process;

    mcpu: cpu port map(
    clk => clk_2,
    rst => rst_cpu,
    led => led,

    rom_ready_i => rom_ready_i,
    rom_data_i => rom_data_i,
    rom_addr_o => rom_addr_o,
    rom_ce_o => rom_ce_o,

    ram_ready_i => ram_ready_i,
    ram_rdata_i => ram_rdata_i,
    ram_we_o => ram_we_o,
    ram_re_o => ram_re_o,
    ram_addr_o => ram_addr_o,
    ram_wdata_o => ram_wdata_o,
    ram_ce_o => ram_ce_o);
    -- mrom: inst_rom port map(
    -- addr_i => rom_addr_o,
    -- ce_i => rom_ce_o,
    -- inst_o => rom_data_i);

    -- mram: ram port map(
    --     rst => rst_reversed,
    --     clk => clk,
    --     we_i => ram_we_o,
    --     re_i => ram_re_o,
    --     ce_i => ram_ce_o,
    --     addr_i => ram_addr_o,
    --     data_i => ram_wdata_o,
    --
    --     data_o => ram_rdata_i,
    --     ram1_oe => ram1_oe,
    --     ram1_we => ram1_we,
    --     ram1_en => ram1_en,
    --     ram1_data => ram1_data,
    --     ram1_addr => ram1_addr);
    mram: ram_new port map(
    rst => rst_reversed,
    clk => clk_2,

    ce_id => rom_ce_o,
    addr_id => rom_addr_o,
    inst_id => rom_data_i,
    inst_ready => inst_ready,
    rom_ready_o => rom_ready_i,

    we_i => ram_we_o,
    re_i => ram_re_o,
    addr_i => ram_addr_o,
    data_i => ram_wdata_o,

    data_o => ram_rdata_i,

    ram1_oe => ram1_oe,
    ram1_we => ram1_we,
    ram1_en => ram1_en,

    ram1_data => ram1_data,
    ram1_addr => ram1_addr,

    ram_ready_o => ram_ready_i,
    data_ready => data_ready,

    tbre => tbre,
    tsre => tsre,
    rdn => rdn,
    wrn => wrn
    );
end bhv;
