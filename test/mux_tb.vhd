LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
USE work.timing.ALL;
USE work.vector_bus.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY mux_tb IS
  GENERIC (runner_cfg : STRING);
END mux_tb;

ARCHITECTURE tb OF mux_tb IS

  CONSTANT N : NATURAL := 2;
  CONSTANT SIZE : NATURAL := 4;

  TYPE test_t IS RECORD
    input : vector_bus_t (0 TO 2 ** N - 1)(SIZE - 1 DOWNTO 0);
    sel : std_logic_vector (N - 1 DOWNTO 0);
    output : std_logic_vector (SIZE - 1 DOWNTO 0);
  END RECORD;

  TYPE test_array_t IS ARRAY (NATURAL RANGE <>) OF test_t;

  SIGNAL sig : test_t;

  CONSTANT tests : test_array_t := (
  (("0000", "0101", "1111", "1010"), "00", "0000"),
  (("0000", "0101", "1111", "1010"), "01", "0101"),
  (("0000", "0101", "1111", "1010"), "10", "1111"),
  (("0000", "0101", "1111", "1010"), "11", "1010")
  );

BEGIN

  UUT : ENTITY work.mux
    GENERIC MAP(
      N => N,
      SIZE => SIZE
    )
    PORT MAP(
      input => sig.input,
      sel => sig.sel,
      output => sig.output
    );

  main : PROCESS
  BEGIN

    test_runner_setup(runner, runner_cfg);

    FOR i IN tests'RANGE LOOP

      sig.input <= tests(i).input;
      sig.sel <= tests(i).sel;

      WAIT FOR TIME_SPAN;
      ASSERT (sig.output = tests(i).output)
      REPORT "test " & INTEGER'image(i) & " failed [output]" SEVERITY error;

    END LOOP;

    WAIT FOR TIME_SPAN;
    test_runner_cleanup(runner);
    WAIT;

  END PROCESS;

END tb;