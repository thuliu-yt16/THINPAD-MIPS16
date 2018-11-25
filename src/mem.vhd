-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;

entity mem is
  port(rst: in std_logic;
        -- 来自 ram
       mem_data_i: in std_logic_vector(15 downto 0);
       -- 来自 ex/mem
       mem_addr_i: in std_logic_vector(15 downto 0);
       reg2_data_i: in std_logic_vector(15 downto 0);
       wd_i: in std_logic_vector(3 downto 0);
       we_i: in std_logic;
       wdata_i: in std_logic_vector(15 downto 0);
       aluop_i: in std_logic_vector(7 downto 0);
       -- current_inst_address_i is previously deleted.
       -- is_in_delayslot_i is previously deleted.

       -- mem/wb 用
       wd_o: out std_logic_vector(3 downto 0);
       we_o: out std_logic;
       wdata_o: out std_logic_vector(15 downto 0);
       -- current_inst_address_i is previously deleted.
       -- is_in_delayslot_i is previously deleted.

       -- RAM 用
       mem_we_o: out std_logic;
       mem_ce_o: out std_logic;
       mem_data_o: out std_logic_vector(15 downto 0);
       mem_addr_o: out std_logic_vector(15 downto 0)
       -- mem_sel_o: out std_logic_vector(2 downto 0)
       );
end mem;

architecture bhv of mem is
begin
  process(rst)
  begin
    if (rst = Enable) then
      wd_o <= RegAddrZero;
      we_o <= Disable;
      wdata_o <= ZeroWord;

      mem_we_o <= '0';
      mem_ce_o <= Disable;
      mem_data_o <= ZeroWord;
      mem_addr_o <= ZeroWord;
    else
      wd_o <= wd_i;
      we_o <= we_i;
      wdata_o <= wdata_i;
    end if;
  end process;
end bhv;
