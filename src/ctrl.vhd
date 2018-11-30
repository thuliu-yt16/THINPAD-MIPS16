-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;

-- input ports: stall, flush, new_pc, branch_flag_in, branch_target_address_in, clk, rst;
-- output ports: pc, ce;
entity ctrl is
  port(rst: in std_logic;

       -- stallreq_from_if_id_i: in std_logic;
       stallreq_from_if_i: in std_logic;
       -- stallreq_from_id_ex_i: in std_logic;
       -- stallreq_from_ex_mem_i: in std_logic;
       stallreq_from_id_i: in std_logic;
       stallreq_from_ex_i: in std_logic;
       stallreq_from_mem_i: in std_logic;

       stall_o: out std_logic_vector(5 downto 0);
       flush_o: out std_logic
       );
end ctrl;

architecture bhv of ctrl is
  signal stall: std_logic_vector(5 downto 0);
  begin
  stall_o <= stall;

  -- process(rst, stallreq_from_if_id_i, stallreq_from_mem_i) -- , stallreq_from_id_ex_i, stallreq_from_ex_mem_i)
  -- begin
  --   -- Stop = 1, NoStop = 0;
  --   if(rst = Enable) then
  --       stall <= "000000";
  --   elsif (stallreq_from_if_id_i = Stop) then
  --     stall <= "000011";
  --   elsif (stallreq_from_mem_i = Stop) then
  --     stall <= "011111";
  --   else
  --     stall <= "000000";
  --   -- elsif (stallreq_from_id_ex_i = Stop) then
  --     -- stall <= "000011";
  --   -- elsif (stallreq_from_ex_mem_i = Stop) then
  --     -- stall <= "000011";
  --   end if;
  -- end process;
 process(rst,stallreq_from_if_i ,stallreq_from_id_i ,stallreq_from_ex_i, stallreq_from_mem_i)
	begin
		if(rst = Enable) then
			stall <= "000000";
		elsif(stallreq_from_mem_i = Stop) then
			stall <= "011111";
		elsif(stallreq_from_ex_i = Stop) then
			stall <= "001111";
		elsif(stallreq_from_id_i = Stop) then
			stall <= "000111";
		elsif(stallreq_from_if_i = Stop) then
			stall <= "001111";
		else
			stall <= "000000";
		end if;
	end process;
end bhv;
