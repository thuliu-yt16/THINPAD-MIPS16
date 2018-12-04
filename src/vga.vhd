-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity vga is
  port(clk: in std_logic;
       rst: in std_logic;

       data_i: in std_logic_vector(15 downto 0);
       pos_o: out std_logic_vector(12 downto 0);

       H: out std_logic;
       V: out std_logic;

       R: out std_logic_vector(2 downto 0);
       G: out std_logic_vector(2 downto 0);
       B: out std_logic_vector(2 downto 0)
       );
end entity;

architecture bhv of vga is
  signal next_block_x, next_block_y: Integer;
  signal next_w: Integer := 0;
  signal next_l: Integer := 0;
  signal w: Integer := 0;
  signal l: Integer := 0;
  begin

    next_block_x <= next_w / 8;
    next_block_y <= next_l / 8;
    pos_o <= conv_std_logic_vector(next_block_x + next_block_y * 80, 13);

    set_rgb: process(w, l)
    begin
      if (w < 640 and l < 480) then
        R <= data_i(8 downto 6);
        G <= data_i(5 downto 3);
        B <= data_i(2 downto 0);
        -- R <= "000";
        -- G <= "111";
        -- B <= "000";
      else
        R <= "000";
        G <= "000";
        B <= "000";
      end if;

    end process;

    set_signal: process(w, l)
    begin
      if (w > 655 and w < 752) then
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

    get_next_w: process(w)
    begin
      if (w = 799) then
        next_w <= 0;
      else
        next_w <= w + 1;
      end if;
    end process;

    get_next_l: process(w, l)
    begin
      if (w = 799 and l = 524) then
        next_l <= 0;
      elsif (w = 799) then
        next_l <= l + 1;
      end if;
    end process;
end bhv;
