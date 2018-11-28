library ieee;
use ieee.std_logic_1164.all;

package define is
  constant Enable: std_logic := '1';
  constant Disable: std_logic := '0';
  constant ZeroWord: std_logic_vector := "0000000000000000";
  constant OneWord: std_logic_vector := "0000000000000001";
  constant RegAddrZero : std_logic_vector(3  downto 0) := "0000";
  constant NopInst : std_logic_vector := "0000100000000000";

  --ALU operation types
  constant EXE_RES_NOP : std_logic_vector(2 downto 0) := "000";
  constant EXE_RES_LOGIC : std_logic_vector(2 downto 0) := "001";
  constant EXE_RES_LOAD_STORE : std_logic_vector(2 downto 0) := "100";

  constant EXE_ADDIU_OP : std_logic_vector(7 downto 0) := "00000010";
  constant EXE_ADDIU3_OP : std_logic_vector(7 downto 0) := "00000011";
  constant EXE_ADDSP3_OP : std_logic_vector(7 downto 0) := "00000100";
  constant EXE_ADDSP_OP : std_logic_vector(7 downto 0) := "00000101";
  constant EXE_ADDU_OP : std_logic_vector(7 downto 0) := "00000110";
  constant EXE_AND_OP : std_logic_vector(7 downto 0) := "00000111";
  constant EXE_B_OP : std_logic_vector(7 downto 0) := "00001000";
  constant EXE_BEQZ_OP : std_logic_vector(7 downto 0) := "00001001";
  constant EXE_BNEZ_OP : std_logic_vector(7 downto 0) := "00001010";
  constant EXE_BTEQZ_OP : std_logic_vector(7 downto 0) := "00001011";
  constant EXE_CMP_OP : std_logic_vector(7 downto 0) := "00001101";
  constant EXE_JR_OP : std_logic_vector(7 downto 0) := "00010001";
  constant EXE_LI_OP : std_logic_vector(7 downto 0) := "00010011"; --19
  constant EXE_LW_OP : std_logic_vector(7 downto 0) := "00010100";
  constant EXE_LW_SP_OP : std_logic_vector(7 downto 0) := "00010101";
  constant EXE_MFIH_OP : std_logic_vector(7 downto 0) := "00010110";
  constant EXE_MFPC_OP : std_logic_vector(7 downto 0) := "00010111";
  constant EXE_MOVE_OP : std_logic_vector(7 downto 0) := "00011000";
  constant EXE_MTIH_OP : std_logic_vector(7 downto 0) := "00011001";
  constant EXE_MTSP_OP : std_logic_vector(7 downto 0) := "00011010";
  constant EXE_NOP_OP : std_logic_vector(7 downto 0) := "00011101"; --29
  constant EXE_OR_OP : std_logic_vector(7 downto 0) := "00011110";
  constant EXE_SLL_OP : std_logic_vector(7 downto 0) := "00011111";
  constant EXE_SLT_OP : std_logic_vector(7 downto 0) := "00100001";
  constant EXE_SLTI_OP : std_logic_vector(7 downto 0) := "00100010";
  constant EXE_SRA_OP : std_logic_vector(7 downto 0) := "00100101";
  constant EXE_SUBU_OP : std_logic_vector(7 downto 0) := "00101001";
  constant EXE_SW_OP : std_logic_vector(7 downto 0) := "00101010";
  constant EXE_SW_RS_OP : std_logic_vector(7 downto 0) := "00101011";
  constant EXE_SW_SP_OP : std_logic_vector(7 downto 0) := "00101100";

  constant REG_SP: std_logic_vector(3 downto 0):= "1000";
  constant REG_IH: std_logic_vector(3 downto 0):= "1001";
  constant REG_RA: std_logic_vector(3 downto 0):= "1010";
  constant REG_T: std_logic_vector(3 downto 0):= "1011";
end define;
