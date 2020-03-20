LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY mux_tb IS
  GENERIC (runner_cfg : STRING);
END mux_tb;

ARCHITECTURE tb OF mux_tb IS

  CONSTANT SIZE : NATURAL := 2;
  SIGNAL input : std_logic_vector (2 ** SIZE - 1 DOWNTO 0);
  SIGNAL selector : std_logic_vector (SIZE - 1 DOWNTO 0);
  SIGNAL output : std_logic;

  TYPE test_case IS RECORD
    input : std_logic_vector (2 ** SIZE - 1 DOWNTO 0);
    selector : std_logic_vector (SIZE - 1 DOWNTO 0);
    output : std_logic;
  END RECORD;

  TYPE test_case_array IS ARRAY (NATURAL RANGE <>) OF test_case;

  CONSTANT time_span : TIME := 20 ns;
  CONSTANT test_cases : test_case_array := (
  ("0000", "00", '0'),
  ("0001", "01", '0'),
  ("0010", "10", '0'),
  ("0011", "11", '0'),
  ("0100", "00", '0'),
  ("0101", "01", '0'),
  ("0110", "10", '1'),
  ("0111", "11", '0'),
  ("1000", "00", '0'),
  ("1001", "01", '0'),
  ("1010", "10", '0'),
  ("1011", "11", '1'),
  ("1100", "00", '0'),
  ("1101", "01", '0'),
  ("1110", "10", '1'),
  ("1111", "11", '1')
  );

BEGIN

  UUT : ENTITY work.mux GENERIC MAP (SIZE => SIZE) PORT MAP (input => input, selector => selector, output => output);

  main : PROCESS
  BEGIN

    test_runner_setup(runner, runner_cfg);

    FOR i IN test_cases'RANGE LOOP

      input <= test_cases(i).input;
      selector <= test_cases(i).selector;

      WAIT FOR time_span;
      ASSERT (output = test_cases(i).output)
      REPORT "test " & INTEGER'image(i) & " failed " SEVERITY error;

    END LOOP;

    WAIT FOR time_span;
    test_runner_cleanup(runner);
    WAIT;

  END PROCESS;

END tb;