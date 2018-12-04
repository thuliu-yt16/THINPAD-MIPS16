-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use work.define.all;

entity flash is
  port(clk: in std_logic;
       rst: in std_logic;
       addr_in: in std_logic_vector(22 downto 1);

       flash_byte: out std_logic;
       flash_vpen: out std_logic;
       flash_ce: out std_logic;
       flash_oe: out std_logic;
       flash_we: out std_logic;
       flash_rp: out std_logic;

       flash_addr: out std_logic_vector(22 downto 1);
       flash_data: inout std_logic_vector(15 downto 0)
       );
end flash;

architecture bhv of flash is
  type state_type is (read1, read2, read3, read4);
  signal state: state_type := read1;
  begin
    flash_byte <= '1';
    flash_vpen <= '1';
    flash_rp <= '1';

    process(clk)
    begin
      if (clk'event and clk = Enable) then
        if (rst = Enable) then
          flash_oe <= '1';
          flash_ce <= '1';
          flash_we <= '1';
          flash_data <= (others => 'Z');
        else
          case state is
            when read1 =>
              if (flash_data = x"00ff") then
                state <= read2;
                flash_we <= '1';
              else
                flash_oe <= '1';
                flash_ce <= '1';
                flash_we <= '0';
                flash_data <= (others => 'Z');
              end if;
            when read2 =>
              state <= read3;
              flash_we <= '1';
            when read3 =>
              state <= read4;
              flash_oe <= '0';
              flash_addr <= addr_in;
              flash_data <= (others => 'Z');
            when read4 =>
              state <= read1;
              flash_oe <= '1';
            when others =>
              state <= read1;
              flash_oe <= '1';
              flash_ce <= '1';
              flash_we <= '1';
              flash_data <= (others => 'Z');
          end case;
        end if;
      end if;
    end process;
end bhv;
