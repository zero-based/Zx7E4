LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
USE work.timing.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY decoder_tb IS
  GENERIC (runner_cfg : STRING);
END decoder_tb;

ARCHITECTURE tb OF decoder_tb IS

  CONSTANT N : NATURAL := 2;

  TYPE test_t IS RECORD
    input : std_logic_vector (N - 1 DOWNTO 0);
    output : std_logic_vector (2 ** N - 1 DOWNTO 0);
  END RECORD;

  SIGNAL sig : test_t;

  TYPE test_array_t IS ARRAY (NATURAL RANGE <>) OF test_t;

  CONSTANT tests : test_array_t := (
  ("00", "0001"),
  ("01", "0010"),
  ("10", "0100"),
  ("11", "1000")
  );

BEGIN

  UUT : ENTITY work.decoder
    GENERIC MAP(N => N)
    PORT MAP(
      input => sig.input,
      output => sig.output
    );

  main : PROCESS
  BEGIN

    test_runner_setup(runner, runner_cfg);

    FOR i IN tests'RANGE LOOP

      sig.input <= tests(i).input;

      WAIT FOR TIME_SPAN;
      ASSERT (sig.output = tests(i).output)
      REPORT "test " & INTEGER'image(i) & " failed [output]" SEVERITY error;

    END LOOP;

    WAIT FOR TIME_SPAN;
    test_runner_cleanup(runner);
    WAIT;

  END PROCESS;

END tb;