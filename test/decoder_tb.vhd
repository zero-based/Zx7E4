LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY decoder_tb IS
  GENERIC (runner_cfg : STRING);
END decoder_tb;

ARCHITECTURE tb OF decoder_tb IS

  CONSTANT SIZE : NATURAL := 2;
  SIGNAL input : std_logic_vector (SIZE - 1 DOWNTO 0);
  SIGNAL output : std_logic_vector (2 ** SIZE - 1 DOWNTO 0);

  TYPE test_case IS RECORD
    input : std_logic_vector (SIZE - 1 DOWNTO 0);
    output : std_logic_vector (2 ** SIZE - 1 DOWNTO 0);
  END RECORD;

  TYPE test_case_array IS ARRAY (NATURAL RANGE <>) OF test_case;

  CONSTANT time_span : TIME := 20 ns;
  CONSTANT test_cases : test_case_array := (
  ("00", "0001"),
  ("01", "0010"),
  ("10", "0100"),
  ("11", "1000")
  );

BEGIN

  UUT : ENTITY work.decoder GENERIC MAP (SIZE => SIZE) PORT MAP (input => input, output => output);

  main : PROCESS
  BEGIN

    test_runner_setup(runner, runner_cfg);

    FOR i IN test_cases'RANGE LOOP

      input <= test_cases(i).input;

      WAIT FOR time_span;
      ASSERT (output = test_cases(i).output)
      REPORT "test " & INTEGER'image(i) & " failed " SEVERITY error;

    END LOOP;

    WAIT FOR time_span;
    test_runner_cleanup(runner);
    WAIT;

  END PROCESS;

END tb;