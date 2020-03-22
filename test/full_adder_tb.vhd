LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
USE work.timing.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY full_adder_tb IS
  GENERIC (runner_cfg : STRING);
END full_adder_tb;

ARCHITECTURE tb OF full_adder_tb IS

  TYPE test_t IS RECORD
    a : std_logic;
    b : std_logic;
    c_in : std_logic;
    sum : std_logic;
    c_out : std_logic;
  END RECORD;

  TYPE test_array_t IS ARRAY (NATURAL RANGE <>) OF test_t;

  SIGNAL sig : test_t;

  CONSTANT tests : test_array_t := (
  ('0', '0', '0', '0', '0'),
  ('0', '0', '1', '1', '0'),
  ('0', '1', '0', '1', '0'),
  ('0', '1', '1', '0', '1'),
  ('1', '0', '0', '1', '0'),
  ('1', '0', '1', '0', '1'),
  ('1', '1', '0', '0', '1'),
  ('1', '1', '1', '1', '1')
  );

BEGIN

  UUT : ENTITY work.full_adder
    PORT MAP(
      a => sig.a,
      b => sig.b,
      c_in => sig.c_in,
      sum => sig.sum,
      c_out => sig.c_out
    );

  main : PROCESS
  BEGIN

    test_runner_setup(runner, runner_cfg);

    FOR i IN tests'RANGE LOOP

      sig.a <= tests(i).a;
      sig.b <= tests(i).b;
      sig.c_in <= tests(i).c_in;
      sig.sum <= tests(i).sum;
      sig.c_out <= tests(i).c_out;

      WAIT FOR TIME_SPAN;

      ASSERT (sig.sum = tests(i).sum)
      REPORT "test " & INTEGER'image(i) & " failed [sum]" SEVERITY error;

      ASSERT (sig.c_out = tests(i).c_out)
      REPORT "test " & INTEGER'image(i) & " failed [c_out]" SEVERITY error;

    END LOOP;

    WAIT FOR TIME_SPAN;
    test_runner_cleanup(runner);
    WAIT;

  END PROCESS;

END tb;