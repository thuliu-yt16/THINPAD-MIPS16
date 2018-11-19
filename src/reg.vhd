library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- input ports: re1, raddr1, re2, raddr2,
-- waddr, we, wdata, clk, RST
-- output ports: rdata1, rdata2;
entity reg is
  port(clk: in std_logic;
        rst: in std_logic;

        re1: in std_logic;
        rd1: in std_logic_vector(3 downto 0);
        re2: in std_logic;
        rd2: in std_logic_vector(3 downto 0);
        we: in std_logic;
        wd: in std_logic_vector(3 downto 0);
        wdata: in std_logic_vector(15 downto 0)
        );
end reg;

architecture bhv of reg is
  begin
end bhv;
