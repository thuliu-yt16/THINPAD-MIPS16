-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;
use ieee.std_logic_unsigned.all;

-- input ports: re1, raddr1, re2, raddr2,
-- waddr, we, wdata, clk, RST
-- output ports: rdata1, rdata2;
entity reg is
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
end reg;

architecture bhv of reg is
  type RegArray is array (0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
  signal regs: RegArray := (others => ZeroWord);
  signal rdata1: std_logic_vector(15 downto 0);
  signal rdata2: std_logic_vector(15 downto 0);

  begin
    rdata1_o <= rdata1;
    rdata2_o <= rdata2;

    WRITE_PROCESS: process(clk)
    begin
      if (rst = Disable) then
        if (we_i = Enable) then
          regs(conv_integer(wd_i)) <= wdata_i;
        end if;
      end if;
    end process;

    READ1_PROCESS: process(rst, re1_i, rd1_i, we_i, wd_i, wdata_i)
    begin
      if (rst = Enable) then
        rdata1 <= ZeroWord;
      elsif (re1_i = Disable) then
        rdata1 <= Zeroword;
      elsif ((rd1_i = wd_i) and (we_i = Enable)) then
        rdata1 <= wdata_i;
      else
        rdata1 <= ZeroWord;
      end if;
    end process;

    READ2_PROCESS: process(rst, re2_i, rd2_i, we_i, wd_i, wdata_i)
    begin
      if (rst = Enable) then
        rdata2 <= ZeroWord;
      elsif (re1_i = Disable) then
        rdata2 <= Zeroword;
      elsif ((rd1_i = wd_i) and (we_i = Enable)) then
        rdata2 <= wdata_i;
      else
        rdata2 <= ZeroWord;
      end if;
    end process;

end bhv;
