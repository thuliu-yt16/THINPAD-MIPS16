library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity if_id is
  port(clk: in std_logic;
       rst: in std_logic;

       stall: in std_logic;
       flush: in std_logic;

       if_pc_i: in std_logic_vector(15 downto 0);
       if_inst_i: in std_logic_vector(15 downto 0);

       id_pc_o: out std_logic_vector(15 downto 0);
       id_inst_o: out std_logic_vector(15 downto 0)
       );
end if_id;

architecture bhv of if_id is
  begin
  end bhv;
