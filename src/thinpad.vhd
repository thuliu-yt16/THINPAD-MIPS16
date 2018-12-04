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
    wrn: out std_logic;

    --flash
    FlashByte: out std_logic;
    FlashVpen: out std_logic;
    FlashCE: out std_logic;
    FlashOE: out std_logic;
    FlashWE: out std_logic;
    FlashRP: out std_logic;
    FlashAddr: out std_logic_vector(22 downto 1);
    FlashData: inout std_logic_vector(15 downto 0);

    -- vga
    H: out std_logic;
    V: out std_logic;

    R: out std_logic_vector(2 downto 0);
    G: out std_logic_vector(2 downto 0);
    B: out std_logic_vector(2 downto 0)
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

-- signal vga_addr_i: std_logic_vector(17 downto 0);
signal vga_data_o: std_logic_vector(15 downto 0);
signal vga_pos_o: std_logic_vector(12 downto 0);
signal vga_memwe_o: std_logic_vector(0 downto 0);

signal pos_o: std_logic_vector(12 downto 0);
signal data_i: std_logic_vector(15 downto 0);
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
wrn: out std_logic;

--flash
FlashByte: out std_logic;
FlashVpen: out std_logic;
FlashCE: out std_logic;
FlashOE: out std_logic;
FlashWE: out std_logic;
FlashRP: out std_logic;
FlashAddr: out std_logic_vector(22 downto 1);
FlashData: inout std_logic_vector(15 downto 0);

-- vga
--VGAAddr: in std_logic_vector(17 downto 0);
VGAData: out std_logic_vector(15 downto 0);
VGAPos: out std_logic_vector(12 downto 0);
VGAMEMWE: out std_logic_vector(0 downto 0)
);
end component;

component screen_mem
PORT (
  clka : IN STD_LOGIC;
  wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
  addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
  dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
  clkb : IN STD_LOGIC;
  addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
  doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
end component;

component vga
port(clk: in std_logic;
     rst: in std_logic;

     data_i: in std_logic_vector(15 downto 0);
     pos_o: out std_logic_vector(12 downto 0);

     H: out std_logic;
     V: out std_logic;

     R: out std_logic_vector(2 downto 0);
     G: out std_logic_vector(2 downto 0);
     B: out std_logic_vector(2 downto 0)
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
    wrn => wrn,

    --flash
    FlashByte => FlashByte,
    FlashVpen => FlashVpen,
    FlashCE => FlashCE,
    FlashOE => FlashOE,
    FlashWE => FlashWE,
    FlashRP => FlashRP,
    FlashAddr => FlashAddr,
    FlashData => FlashData,

    -- VGAAddr => vga_addr_i,
    VGAData => vga_data_o,
    VGAPos => vga_pos_o,
    VGAMEMWE => vga_memwe_o
    );

    mscreen_mem: screen_mem port map(
      clka => clk_2,
      wea => vga_memwe_o,
      addra => vga_pos_o,
      dina => vga_data_o,
      clkb => clk_2,
      addrb => pos_o,
      doutb => data_i
    );

    mvga: vga port map(
      clk => clk_2,
      rst => rst,

      data_i => data_i,
      pos_o => pos_o,

      H => H,
      V => V,

      R => R,
      G => G,
      B => B
    );
end bhv;
