-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;

entity ram is
    port(rst: in std_logic;
    clk: in std_logic;

    we_i: in std_logic;
    re_i: in std_logic;
    ce_i: in std_logic; -- ram ʹ��
    addr_i: in std_logic_vector(15 downto 0);
    data_i: in std_logic_vector(15 downto 0);
    -- sel_i: in std_logic_vector(2 downto 0);
    data_o: out std_logic_vector(15 downto 0);

    ram1_oe: out std_logic;
    ram1_we: out std_logic;
    ram1_en: out std_logic;
    ram1_data: inout std_logic_vector(15 downto 0);
    ram1_addr: out std_logic_vector(17 downto 0)
    );
end ram;

architecture bhv of ram is
    begin
        ram1_addr <= "00" & addr_i;
        ram1_we <= clk or not(we_i); -- ���½��ص��ڶ���������д
        ram1_oe <= not(re_i);
        ram1_en <= '0'; -- ʼ��ʹ��

        WRITE: process(clk, addr_i, data_i)
        begin
            --if(clk'event) then
            if(rst = Disable) then
                if(we_i = Enable) then
                    ram1_data <= data_i;
                end if;
            end if;
            -- end if;
        end process;

        READ: process(rst, re_i, addr_i, ram1_data)
        begin
            if(rst = Enable) then
                data_o <= Zeroword;
            elsif(re_i = Disable) then
                data_o <= ZeroWord;
            else
                data_o <= ram1_data;
            end if;
        end process;

    end bhv;
