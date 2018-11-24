library ieee;
use ieee.std_logic_1164.all;

package define is
  constant Enable: std_logic := '1';
  constant Disable: std_logic := '0';
  constant Zeroword: std_logic_vector := "0000000000000000";
  constant RegAddrZero : std_logic_vector(3  downto 0) := "0000";

  --ALU operation types
	constant EXE_RES_NOP : std_logic_vector(2 downto 0) := "000";
	constant EXE_RES_LOGIC : std_logic_vector(2 downto 0) := "001";
	constant EXE_RES_LOAD_STORE : std_logic_vector(2 downto 0) := "100";

  constant EXE_LI_OP : std_logic_vector(7 downto 0) := "00010011"; --19
  constant EXE_NOP_OP : std_logic_vector(7 downto 0) := "00011101"; --29

end define;
