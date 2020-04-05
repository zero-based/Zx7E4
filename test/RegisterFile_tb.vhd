
LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY RegisterFileTest IS
   GENERIC (runner_cfg : STRING);
END RegisterFileTest;

ARCHITECTURE behavior OF RegisterFileTest IS

   COMPONENT RegisterFile
      PORT (
         read_sel1 : IN std_logic_vector(4 DOWNTO 0);
         read_sel2 : IN std_logic_vector(4 DOWNTO 0);
         write_sel : IN std_logic_vector(4 DOWNTO 0);
         write_ena : IN std_logic;
         clk : IN std_logic;
         write_data : IN std_logic_vector(31 DOWNTO 0);
         data1 : OUT std_logic_vector(31 DOWNTO 0);
         data2 : OUT std_logic_vector(31 DOWNTO 0)
      );
   END COMPONENT;
   --Inputs
   SIGNAL read_sel1 : std_logic_vector(4 DOWNTO 0) := (OTHERS => '0');
   SIGNAL read_sel2 : std_logic_vector(4 DOWNTO 0) := (OTHERS => '0');
   SIGNAL write_sel : std_logic_vector(4 DOWNTO 0) := (OTHERS => '0');
   SIGNAL write_ena : std_logic := '0';
   SIGNAL clk : std_logic := '0';
   SIGNAL write_data : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');

   --Outputs
   SIGNAL data1 : std_logic_vector(31 DOWNTO 0);
   SIGNAL data2 : std_logic_vector(31 DOWNTO 0);

   -- Clock period definitions
   CONSTANT clk_period : TIME := 10 ps;

BEGIN
   -- Instantiate the Unit Under Test (UUT)
   uut : RegisterFile PORT MAP(
      read_sel1 => read_sel1,
      read_sel2 => read_sel2,
      write_sel => write_sel,
      write_ena => write_ena,
      clk => clk,
      write_data => write_data,
      data1 => data1,
      data2 => data2
   );

   -- Clock process definitions
   clk_process : PROCESS
   BEGIN
      clk <= '0';
      WAIT FOR clk_period/2;
      clk <= '1';
      WAIT FOR clk_period/2;
   END PROCESS;
   -- Stimulus process
   stim_proc : PROCESS
   BEGIN
      test_runner_setup(runner, runner_cfg);

      WAIT FOR clk_period - 3 ps;

      --Write value in $t0
      write_sel <= "01000"; --$t0
      write_data <= "00001111000011110000111100001111";
      write_ena <= '1';
      WAIT FOR clk_period * 1;

      --Write value in $s0
      write_sel <= "10000"; --$s0
      write_data <= "11110000111100001111000011110000";
      write_ena <= '1';
      WAIT FOR clk_period * 1;

      --Read data from $t0 and $s0
      read_sel1 <= "01000"; --$t0
      read_sel2 <= "10000"; --$s0
      write_ena <= '0';
      WAIT FOR clk_period * 2;

      REPORT "Test1";
      ASSERT(data1 = "00001111000011110000111100001111") REPORT "1:Fail" SEVERITY error;
      REPORT "Test2";
      ASSERT(data2 = "11110000111100001111000011110000") REPORT "2:Fail" SEVERITY error;

      WAIT FOR clk_period * 1;

      --Read data from $t0 and $s0 and write new data in $t0
      read_sel1 <= "01000"; --$t0
      read_sel2 <= "10000"; --$s0
      write_sel <= "01000"; --$t0
      write_data <= "00000000000000000000000000000000";
      write_ena <= '1';

      WAIT FOR clk_period * 2;

      REPORT "Test3";
      ASSERT(data1 = "00000000000000000000000000000000") REPORT "3:Fail" SEVERITY error;
      REPORT "Test4";
      ASSERT(data2 = "11110000111100001111000011110000") REPORT "4:Fail" SEVERITY error;
      -- insert stimulus here 
      REPORT "Test Complete";

      test_runner_cleanup(runner);
      WAIT;
   END PROCESS;

END;