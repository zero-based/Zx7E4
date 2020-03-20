LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY mux_4_tb IS
  GENERIC (runner_cfg : STRING);
END mux_4_tb;

ARCHITECTURE tb OF mux_4_tb IS

  CONSTANT SIZE : NATURAL := 4;
  SIGNAL input : std_logic_vector(SIZE - 1 DOWNTO 0);
  SIGNAL selector : NATURAL;
  SIGNAL output : std_logic;

  TYPE test_case IS RECORD
    input : std_logic_vector(SIZE - 1 DOWNTO 0);
    selector : NATURAL;
    output : std_logic;
  END RECORD;

  TYPE test_case_array IS ARRAY (NATURAL RANGE <>) OF test_case;

  CONSTANT time_span : TIME := 20 ns;
  CONSTANT test_cases : test_case_array := (
  ("0000", 0, '0'),
  ("0001", 1, '0'),
  ("0010", 2, '0'),
  ("0011", 3, '0'),
  ("0100", 0, '0'),
  ("0101", 1, '0'),
  ("0110", 2, '1'),
  ("0111", 3, '0'),
  ("1000", 0, '0'),
  ("1001", 1, '0'),
  ("1010", 2, '0'),
  ("1011", 3, '1'),
  ("1100", 0, '0'),
  ("1101", 1, '0'),
  ("1110", 2, '1'),
  ("1111", 3, '1')
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