LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY full_adder_tb IS
  GENERIC (runner_cfg : STRING);
END full_adder_tb;

ARCHITECTURE tb OF full_adder_tb IS

  SIGNAL a, b, cin : std_logic;
  SIGNAL cout, s : std_logic;

  TYPE test_case IS RECORD
    a, b, cin : std_logic;
    s, cout : std_logic;
  END RECORD;

  TYPE test_case_array IS ARRAY (NATURAL RANGE <>) OF test_case;
  CONSTANT time_span : TIME := 20 ns;
  CONSTANT test_cases : test_case_array := (
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

  UUT : ENTITY work.full_adder PORT MAP (a => a, b => b, cin => cin, s => s, cout => cout);
  main : PROCESS
  BEGIN

    test_runner_setup(runner, runner_cfg);

    FOR i IN test_cases'RANGE LOOP

      a <= test_cases(i).a;
      b <= test_cases(i).b;
      cin <= test_cases(i).cin;
      s <= test_cases(i).s;
      cout <= test_cases(i).cout;

      WAIT FOR time_span;
      ASSERT (s = test_cases(i).s)
      REPORT "test " & INTEGER'image(i) & " failed [BAD SUM]" SEVERITY error;
      ASSERT (cout = test_cases(i).cout)
      REPORT "test " & INTEGER'image(i) & " failed [BAD C.OUT]" SEVERITY error;

    END LOOP;

    WAIT FOR time_span;
    test_runner_cleanup(runner);
    WAIT;

  END PROCESS;

END tb;