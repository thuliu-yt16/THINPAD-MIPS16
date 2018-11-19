library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity id_ex is
  port(clk: in std_logic;
       rst: in std_logic;

       stall: in std_logic;
       flush: in std_logic;

       id_aluop_i: in std_logic_vector(7 downto 0);
       id_alusel_i: in std_logic_vector(2 downto 0);

       id_reg1_data_i: in std_logic_vector(15 downto 0);
       id_reg2_data_i: in std_logic_vector(15 downto 0);
       id_wd_i: in std_logic_vector(3 downto 0);
       id_we_i: in std_logic;

       id_inst_i: in std_logic_vector(15 downto 0);
       -- id_current_inst_address is previously deleted.
       -- id_is_in_delayslot is previously deleted.
       -- id_link_addr is previously deleted.
       -- next_inst_in_delayslot_i is previously deleted.
       ex_aluop_o: out std_logic_vector(7 downto 0);
       ex_alusel_o: out std_logic_vector(2 downto 0);

       ex_reg1_data_o: out std_logic_vector(15 downto 0);
       ex_reg2_data_o: out std_logic_vector(15 downto 0);
       ex_wd_o: out std_logic_vector(3 downto 0);
       ex_we_o: out std_logic;

       ex_inst_o: in std_logic_vector(15 downto 0)
       -- ex_current_inst_addr is previously deleted.
       -- ex_is_in_delayslot is previously deleted.
       -- ex_link_addr is previously deleted.
       -- is_in_delayslot_o is previously deleted.
       );
end id_ex;

architecture bhv of id_ex is
  begin
  end bhv;
