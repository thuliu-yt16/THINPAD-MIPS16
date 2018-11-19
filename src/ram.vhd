library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
  port(clk: in std_logic;

       we_i: in std_logic;
       ce_i: in std_logic;
       addr_i: in std_logic_vector(15 downto 0);
       data_i: in std_logic_vector(15 downto 0);
       sel_i: in std_logic_vector(2 downto 0);

       data_o: out std_logic_vector(15 downto 0)
       );
end ram;

architecture bhv of ram is
  begin
  end bhv;
