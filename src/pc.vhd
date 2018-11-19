library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- input ports: stall, flush, new_pc, branch_flag_in, branch_target_address_in, clk, rst;
-- output ports: pc, ce;
entity pc is
  port (stall: in std_logic;
        flush: in std_logic;

        clk: in std_logic;
        rst: in std_logic;

        branch_flag_i: in std_logic;
        new_pc_i: in std_logic_vector(15 downto 0);
        target_address_i: std_logic_vector(15 downto 0);

        pc_o: out std_logic_vector(15 downto 0);
        ce_o: out std_logic
        );
end pc;

architecture bhv of pc is
  begin
end bhv;
