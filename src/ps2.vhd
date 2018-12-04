-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use work.define.all;

entity ps2 is
  port(clk_in: in std_logic;
       rst: in std_logic;

       ps2clk: in std_logic;
       ps2data: in std_logic;

       data_out: out std_logic_vector(7 downto 0);
       oe: out std_logic
       );
end ps2;

architecture bhv of ps2 is
  type state_type is (delay, start, d0, d1, d2, d3, d4, d5, d6, d7, parity, stop, finish);
  signal state: state_type := delay;
  signal odd, fok, data, clk, clk1, clk2: std_logic;
  signal code: std_logic_vector(7 downto 0);
  begin
    clk1 <= ps2clk when rising_edge(clk_in);
    clk2 <= clk1 when rising_edge(clk_in);
    clk <= (not clk1) and clk2;
    data <= ps2data when rising_edge(clk_in);
    data_out <= code when fok = '1';
    odd <= code(0) xor code(1) xor code(2) xor code(3)
		xor code(4) xor code(5) xor code(6) xor code(7) ;


    process(clk, rst)
    begin
      if (clk'event and clk = Enable) then
        fok <= '0';
        oe <= '0';
        case state is
          when delay =>
            state <= start;
          when start =>
            if clk = Enable and data = '0' then
              state <= d0;
            else
              state <= delay;
            end if;
          when d0 =>
            if clk = Enable then
              code(0) <= data;
              state <= d1;
            else
              state <= delay;
            end if;
          when d1 =>
            if clk = Enable then
              code(1) <= data;
              state <= d2;
            else
              state <= delay;
            end if;
          when d2 =>
            if clk = Enable then
              code(2) <= data;
              state <= d3;
            else
              state <= delay;
            end if;
          when d3 =>
            if clk = Enable then
              code(3) <= data;
              state <= d4;
            else
              state <= delay;
            end if;
          when d4 =>
            if clk = Enable then
              code(4) <= data;
              state <= d5;
            else
              state <= delay;
            end if;
          when d5 =>
            if clk = Enable then
              code(5) <= data;
              state <= d6;
            else
              state <= delay;
            end if;
          when d6 =>
            if clk = Enable then
              code(6) <= data;
              state <= d7;
            else
              state <= delay;
            end if;
          when d7 =>
            if clk = Enable then
              code(7) <= data;
              state <= parity;
            else
              state <= delay;
            end if;
          when parity =>
            if clk = Enable and (data xor odd) = '1' then
              state <= stop;
            else
              state <= delay;
            end if;
          when stop =>
            if clk = Enable and data = '1' then
              state <= finish;
            else
              state <= delay;
            end if ;
          when finish =>
            state <= delay;
            fok <= '1';
            oe <= '1';
          when others =>
            state <= delay;
        end case;
      end if;
    end process;
end bhv;
