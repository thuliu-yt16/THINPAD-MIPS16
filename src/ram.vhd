library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;

entity ram is
  port(rst: in std_logic;
        clk: in std_logic;

       we_i: in std_logic;
       re_i: in std_logic;
       ce_i: in std_logic; -- ram 使能
       addr_i: in std_logic_vector(15 downto 0);
       data_i: in std_logic_vector(15 downto 0);
       -- sel_i: in std_logic_vector(2 downto 0);
       data_o: out std_logic_vector(15 downto 0);

        ram2_oe: out std_logic;
        ram2_we: out std_logic;
        ram2_en: out std_logic;
        ram2_data: inout std_logic_vector(15 downto 0);
        ram2_addr: out std_logic_vector(17 downto 0)
       );
end ram;

architecture bhv of ram is
begin
    ram2_addr <= "00" & addr_i;
    ram2_we <= clk or not(we_i); -- 在下降沿到第二个上升沿写
    ram2_oe <= we_i;
    ram2_en <= '0'; -- 始终使能

    WRITE: process(clk)
    begin
        if(clk'event and clk = Enable) then
            if(rst = Disable) then
                if(ce_i = Enable and we_i = Enable) then
                    ram2_data <= data_i;
                end if;
            end if;
        end if;
    end process;

    READ: process(rst, re_i, addr_i, ram2_data)
    begin
        if(rst = Enable) then
            data_o <= Zeroword;
        elsif(re_i = Disable) then
            data_o <= ZeroWord;
        else
            data_o <= ram2_data;
        end if;
    end process;

end bhv;
