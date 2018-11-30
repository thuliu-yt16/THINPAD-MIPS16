--------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:   14:28:13 11/29/2018
-- Design Name:
-- Module Name:   D:/THINPAD-MIPS16/test/inst_test.vhd
-- Project Name:  thinpad
-- Target Device:
-- Tool versions:
-- Description:
--
-- VHDL Test Bench Created by ISE for module: thinpad
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes:
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY inst_test IS
END inst_test;

ARCHITECTURE behavior OF inst_test IS

    -- Component Declaration for the Unit Under Test (UUT)

    COMPONENT thinpad
    PORT(
    rst: in std_logic;
    clk: in std_logic;
    data_ready: in std_logic;

    tbre: in std_logic;
    tsre: in std_logic;
    led : out std_logic_vector(15 downto 0);

    ram1_oe: out std_logic;
    ram1_we: out std_logic;
    ram1_en: out std_logic;
    ram1_data: inout std_logic_vector(15 downto 0);
    ram1_addr: out std_logic_vector(17 downto 0);

    rdn: out std_logic;
    wrn: out std_logic
        );
    END COMPONENT;


   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal data_ready: std_logic;
   signal tbre: std_logic;
   signal tsre: std_logic;


	--BiDirs
   signal ram1_data : std_logic_vector(15 downto 0);

 	--Outputs
    signal rdn: std_logic;
    signal wrn: std_logic;
   signal led : std_logic_vector(15 downto 0);
   signal ram1_oe : std_logic;
   signal ram1_we : std_logic;
   signal ram1_en : std_logic;
   signal ram1_addr : std_logic_vector(17 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: thinpad PORT MAP (
          rst => rst,
          clk => clk,
          led => led,
          data_ready => data_ready,
          tbre => tbre,
          tsre => tsre,
          rdn => rdn,
          wrn => wrn,
          ram1_oe => ram1_oe,
          ram1_we => ram1_we,
          ram1_en => ram1_en,
          ram1_data => ram1_data,
          ram1_addr => ram1_addr
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
   end process;


   -- Stimulus process
   stim_proc: process
   begin
      -- hold reset state for 100 ns.

		rst <= '1';
      wait for 800 ns;
		rst <= '0';
      -- insert stimulus here

      wait;
   end process;

END;
