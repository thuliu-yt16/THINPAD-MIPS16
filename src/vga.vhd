-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;

entity vga is
    port(clk: in std_logic;
    rst: in std_logic;

    vga_data_i: in std_logic_vector(7 downto 0);
    vga_start_pos_x: in Integer;
    vga_start_pos_y: in Integer;


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
    signal clk_2: std_logic := '0';
    constant pixelColNum : Integer:= 80;
    type pixelArray is array(0 to pixelColNum) of std_logic_vector(0 to 63);
    signal pixels: pixelArray := (others => "0000000000000000000000000000000000000000000000000000000000000000");

    begin
        RECOLOR: process(vga_start_pos_x, vga_start_pos_y)
        variable x: Integer := vga_start_pos_x;
        variable y: Integer := vga_start_pos_y;
        begin
            if(x >= 0 and x < 80 and y >= 0 and y < 64) then
                pixels(x)(y) <= vga_data_i(7);
                pixels(x + 1)(y) <= vga_data_i(6);
                pixels(x + 2)(y) <= vga_data_i(5);
                pixels(x + 3)(y) <= vga_data_i(4);
                pixels(x + 4)(y) <= vga_data_i(3);
                pixels(x + 5)(y) <= vga_data_i(2);
                pixels(x + 6)(y) <= vga_data_i(1);
                pixels(x + 7)(y) <= vga_data_i(0);
            end if;

        end process;

        clk2: process(clk)
        begin
            if(clk'event and clk = '1') then
                clk_2 <= not(clk_2);
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

        set_rgb: process(w, l)
        begin
            if (w < 640 and l < 480) then
                if(pixels(w/8)(l/8) = '0') then
                    R <= "111";
                    G <= "111";
                    B <= "111";
                else
                    R <= "000";
                    G <= "000";
                    B <= "000";
                end if;
            else
                R <= "000";
                G <= "000";
                B <= "000";
            end if;
        end process;

        w_update: process(clk)
        begin
            if(rising_edge(clk)) then
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
