library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- input ports: stall, flush, new_pc, branch_flag_in, branch_target_address_in, clk, rst;
-- output ports: pc, ce;
entity ctrl is
  port(rst: in std_logic;

       stallreq_from_ex_i: in std_logic;
       stallreq_from_id_i: in std_logic;

       stall: out std_logic;
       flush: out std_logic
       );
end ctrl;

architecture bhv of ctrl is
  begin
  end bhv;
