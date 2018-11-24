-- args: --ieee=synopsys -fexplicit
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.define.all;

entity ex is

    port(aluop_i: in std_logic_vector(7 downto 0);
    alusel_i: in std_logic_vector(2 downto 0);

    reg1_data_i: in std_logic_vector(15 downto 0);
    reg2_data_i: in std_logic_vector(15 downto 0);
    wd_i: in std_logic_vector(3 downto 0);
    we_i: in std_logic;

    inst_i: in std_logic_vector(15 downto 0);
    -- current_inst_address_i is previously deleted.
    -- is_in_delayslot_i is previously deleted.
    -- link_address_i is previously deleted.

    mem_addr_o: out std_logic_vector(15 downto 0);
    reg2_data_o: out std_logic_vector(15 downto 0);
    wd_o: out std_logic_vector(3 downto 0);
    we_o: out std_logic;
    aluop_o: out std_logic_vector(7 downto 0);
    wdata_o: out std_logic_vector(15 downto 0);
    -- current_inst_address_o is previously deleted.
    -- is_in_delayslot_o is previously deleted.

    stallreq: out std_logic
    );
end ex;

architecture bhv of ex is
  signal logicout: std_logic_vector(15 downto 0);
  begin

  ARITH_PROCESS: process(rst, aluop_i, inst_i, reg1_data_i, reg2_data_i)
  begin
    if (rst = Enable) then
      logicout <= ZeroWord;
    else
      case aluop_i is
        when EXE_LI_OP =>
          logicout <= reg1_data_i;
        when others =>
          logicout <= ZeroWord;
      end case;
    end if;
  end process;

  RESULT_PROCESS: process(alusel_i)
  begin
    wd_o <= wd_i;
    we_o <= we_i;
    case alusel_i is
      when EXE_RES_LOGIC =>
        wdata_o <= logicout;
      when others =>
        wdata_o <= ZeroWord;
    end case;
  end process;
end bhv;

