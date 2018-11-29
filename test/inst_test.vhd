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
         rst : IN  std_logic;
         clk : IN  std_logic;
         led : OUT  std_logic_vector(15 downto 0);
         ram2_oe : OUT  std_logic;
         ram2_we : OUT  std_logic;
         ram2_en : OUT  std_logic;
         ram2_data : INOUT  std_logic_vector(15 downto 0);
         ram2_addr : OUT  std_logic_vector(17 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

	--BiDirs
   signal ram2_data : std_logic_vector(15 downto 0);

 	--Outputs
   signal led : std_logic_vector(15 downto 0);
   signal ram2_oe : std_logic;
   signal ram2_we : std_logic;
   signal ram2_en : std_logic;
   signal ram2_addr : std_logic_vector(17 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: thinpad PORT MAP (
          rst => rst,
          clk => clk,
          led => led,
          ram2_oe => ram2_oe,
          ram2_we => ram2_we,
          ram2_en => ram2_en,
          ram2_data => ram2_data,
          ram2_addr => ram2_addr
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
      wait for 500 ns;	
		rst <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
