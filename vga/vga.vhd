-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;

entity vga is
    port(clk: in std_logic;
    rst: in std_logic;

    vga_data_i: in std_logic_vector(7 downto 0);
    vga_start_pos: in Integer;


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
    type pixelArray is array(0 to 4800) of std_logic;
    signal pixels: pixelArray := (others => '0');

    begin
        RECOLOR: process(vga_start_pos, vga_data_i)
        begin
            pixels(vga_start_pos) <= vga_data_i(7);
            pixels(vga_start_pos + 1) <= vga_data_i(6);
            pixels(vga_start_pos + 2) <= vga_data_i(5);
            pixels(vga_start_pos + 3) <= vga_data_i(4);
            pixels(vga_start_pos + 4) <= vga_data_i(3);
            pixels(vga_start_pos + 5) <= vga_data_i(2);
            pixels(vga_start_pos + 6) <= vga_data_i(1);
            pixels(vga_start_pos + 7) <= vga_data_i(0);
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
                if(pixels(w / 8  + l / 8 * 80) = '0') then
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
