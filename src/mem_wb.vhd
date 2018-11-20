library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_wb is
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
end mem_wb;

architecture bhv of mem_wb is
  begin
  end bhv;
