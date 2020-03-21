LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
USE work.vector_bus.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY mux_tb IS
  GENERIC (runner_cfg : STRING);
END mux_tb;

ARCHITECTURE tb OF mux_tb IS

  CONSTANT SEL_COUNT : NATURAL := 2;
  CONSTANT DATA_SIZE : NATURAL := 4;

  SIGNAL input : vector_bus_t (0 TO 2 ** SEL_COUNT - 1)(DATA_SIZE - 1 DOWNTO 0);
  SIGNAL selector : std_logic_vector (SEL_COUNT - 1 DOWNTO 0);
  SIGNAL output : std_logic_vector (DATA_SIZE - 1 DOWNTO 0);

  TYPE test_case IS RECORD
    input : vector_bus_t (0 TO 2 ** SEL_COUNT - 1)(DATA_SIZE - 1 DOWNTO 0);
    selector : std_logic_vector (SEL_COUNT - 1 DOWNTO 0);
    output : std_logic_vector (DATA_SIZE - 1 DOWNTO 0);
  END RECORD;

  TYPE test_case_array IS ARRAY (NATURAL RANGE <>) OF test_case;

  CONSTANT time_span : TIME := 20 ns;
  CONSTANT test_cases : test_case_array := (
  (("0000", "0101", "1111", "1010"), "00", "0000"),
  (("0000", "0101", "1111", "1010"), "01", "0101"),
  (("0000", "0101", "1111", "1010"), "10", "1111"),
  (("0000", "0101", "1111", "1010"), "11", "1010")
  );

BEGIN

  UUT : ENTITY work.mux
    GENERIC MAP(SEL_COUNT => SEL_COUNT, DATA_SIZE => DATA_SIZE)
    PORT MAP(input => input, selector => selector, output => output);

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