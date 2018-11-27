library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.define.all;

entity thinpad is
port(
    rst: in std_logic;
    clk: in std_logic;

    led : out std_logic_vector(15 downto 0);

    ram2_oe: out std_logic;
    ram2_we: out std_logic;
    ram2_en: out std_logic;
    ram2_data: inout std_logic_vector(15 downto 0);
    ram2_addr: out std_logic_vector(17 downto 0)
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

component cpu
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
end component;
component inst_rom
  port(addr_i: in std_logic_vector(15 downto 0); -- Ҫȡָ���ĵ�ַ
       ce_i: in std_logic; -- оƬʹ��
       inst_o: out std_logic_vector(15 downto 0)); -- ��ȡָ��
end component;

component ram
  port(rst: in std_logic;
        clk: in std_logic;
       we_i: in std_logic;
       re_i: in std_logic;
       ce_i: in std_logic;
       addr_i: in std_logic_vector(15 downto 0);
       data_i: in std_logic_vector(15 downto 0);
       -- sel_i: in std_logic_vector(2 downto 0);
       data_o: out std_logic_vector(15 downto 0);

        ram2_oe: out std_logic;
        ram2_we: out std_logic;
        ram2_en: out std_logic;
        ram2_data: inout std_logic_vector(15 downto 0);
        ram2_addr: out std_logic_vector(17 downto 0)
       );

end component;
begin
    rst_reversed <= not(rst);
    mcpu: cpu port map(
        clk => clk,
        rst => rst_reversed,
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
    mrom: inst_rom port map(
        addr_i => rom_addr_o,
        ce_i => rom_ce_o,
        inst_o => rom_data_i);
    mram: ram port map(
        rst => rst_reversed,
        clk => clk,
        we_i => ram_we_o,
        re_i => ram_re_o,
        ce_i => ram_ce_o,
        addr_i => ram_addr_o,
        data_i => ram_wdata_o,

        data_o => ram_rdata_i,
        ram2_oe => ram2_oe,
        ram2_we => ram2_we,
        ram2_en => ram2_en,
        ram2_data => ram2_data,
        ram2_addr => ram2_addr);



end bhv;
