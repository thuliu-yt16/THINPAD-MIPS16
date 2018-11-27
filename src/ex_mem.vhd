-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;

entity ex_mem is
  port(clk: in std_logic;
       rst: in std_logic;

       stall: in std_logic_vector(5 downto 0);
       flush: in std_logic;

       ex_mem_addr_i: in std_logic_vector(15 downto 0); -- mem�׶ζ��ڴ��ַ
       ex_reg2_data_i: in std_logic_vector(15 downto 0); -- �ڶ����Ĵ���������
       ex_wd_i: in std_logic_vector(3 downto 0); -- д�ؽ׶�Ŀ��Ĵ�������
       ex_we_i: in std_logic; -- д�ؽ׶��Ƿ�д��
       ex_wdata_i: in std_logic_vector(15 downto 0); -- д�ؽ׶ε�д������
       ex_aluop_i: in std_logic_vector(7 downto 0); -- alu���� ?
       -- ex_current_inst_address is previously deleted.
       -- ex_is_in_delayslot is previously deleted.

       mem_mem_addr_o: out std_logic_vector(15 downto 0);
       mem_reg2_data_o: out std_logic_vector(15 downto 0);
       mem_wd_o: out std_logic_vector(3 downto 0);
       mem_we_o: out std_logic;
       mem_wdata_o: out std_logic_vector(15 downto 0);
       mem_aluop_o: out std_logic_vector(7 downto 0)
       -- mem_current_inst_address is previously deleted.
       -- mem_is_in_delayslot is previously deleted.
       );
end ex_mem;

architecture bhv of ex_mem is
  begin
    process(clk)
    begin
      if (rst = Enable) then
        mem_wd_o <= RegAddrZero;
        mem_we_o <= Disable;
        mem_wdata_o <= ZeroWord;
      else
        mem_mem_addr_o <= ex_mem_addr_i;
        mem_reg2_data_o <= ex_reg2_data_i;
        mem_wd_o <= ex_wd_i;
        mem_we_o <= ex_we_i;
        mem_wdata_o <= ex_wdata_i;
        mem_aluop_o <= ex_aluop_i;
      end if;
    end process;
end bhv;
