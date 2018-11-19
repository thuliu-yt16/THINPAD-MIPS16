library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex_mem is
  port(clk: in std_logic;
       rst: in std_logic;

       stall: in std_logic;
       flush: in std_logic;

       ex_mem_addr_i: in std_logic_vector(15 downto 0);
       ex_reg2_data_i: in std_logic_vector(15 downto 0);
       ex_wd_i: in std_logic;
       ex_we_i: in std_logic;
       ex_wdata_i: in std_logic_vector(15 downto 0);
       ex_aluop_i: in std_logic_vector(7 downto 0);
       -- ex_current_inst_address is previously deleted.
       -- ex_is_in_delayslot is previously deleted.

       mem_mem_addr_o: out std_logic_vector(15 downto 0);
       mem_reg2_data_o: in std_logic_vector(15 downto 0);
       mem_wd_o: in std_logic;
       mem_we_o: in std_logic;
       mem_wdata_o: in std_logic_vector(15 downto 0);
       mem_aluop_o: in std_logic_vector(7 downto 0)
       -- mem_current_inst_address is previously deleted.
       -- mem_is_in_delayslot is previously deleted.
       );
end ex_mem;

architecture bhv of ex_mem is
  begin
  end bhv;
