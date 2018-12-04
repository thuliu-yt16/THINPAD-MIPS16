-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;

entity vga is
  port(clk: in std_logic;
       rst: in std_logic;

       H: out std_logic;
       V: out std_logic;

       R: out std_logic_vector(2 downto 0);
       G: out std_logic_vector(2 downto 0);
       B: out std_logic_vector(2 downto 0)
       );
end entity;

architecture bhv of vga is
  signal w: Integer := 0;
  signal l: Integer := 0;
  begin

    set_signal: process(w, l)
    begin
      if (w > 655 and w < 753) then
        H <= '0';
      else
        H <= '1';
      end if;

      if (l = 490 or l = 491) then
        V <= '0';
      else
        V <= '1';
      end if;
    end process;

    set_rgb: process(w, l)
    begin
      if (w < 640 and l < 480) then
        R <= "000";
        G <= "000";
        B <= "111";
      else
        R <= "000";
        G <= "000";
        B <= "000";
      end if;

    end process;

    w_update: process(clk)
    begin
      if (rising_edge(clk)) then
        if (w = 799) then
          w <= 0;
        else
          w <= w + 1;
        end if;
      end if;
    end process;

    l_update: process(clk)
    begin
      if (rising_edge(clk)) then
        if (w = 799 and l = 524) then
          l <= 0;
        elsif (w = 799) then
          l <= l + 1;
        end if;
      end if;
    end process;
end bhv;
