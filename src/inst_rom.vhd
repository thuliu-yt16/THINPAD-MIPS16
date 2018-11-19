library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- input ports: addr, ce;
-- output ports: inst;
entity inst_rom is
  port(addr_i: in std_logic_vector(15 downto 0);
       ce_i: in std_logic;

       inst_o: out std_logic_vector(15 downto 0));
end inst_rom;

architecture bhv of inst_rom is
  begin
end bhv;
