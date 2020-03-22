LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
USE work.timing.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY register_tb IS
  GENERIC (runner_cfg : STRING);
END register_tb;

ARCHITECTURE tb OF register_tb IS

  CONSTANT SIZE : INTEGER := 4;

  TYPE test_t IS RECORD
    ld : std_logic;
    clr : std_logic;
    input : std_logic_vector (SIZE - 1 DOWNTO 0);
    output : std_logic_vector (SIZE - 1 DOWNTO 0);
  END RECORD;

  TYPE test_array_t IS ARRAY (NATURAL RANGE <>) OF test_t;

  SIGNAL clk : std_logic;
  SIGNAL sig : test_t;

  CONSTANT tests : test_array_t := (
  ('0', '0', "0000", "UUUU"),
  ('1', '0', "0000", "0000"),
  ('1', '0', "1111", "1111"),
  ('0', '1', "0000", "0000"),
  ('0', '1', "1111", "0000"),
  ('1', '1', "0000", "0000"),
  ('1', '1', "1111", "1111"),
  ('0', '0', "0000", "1111")
  );

BEGIN

  UUT : ENTITY work.reg
    GENERIC MAP(SIZE => SIZE)
    PORT MAP(
      clk => clk,
      ld => sig.ld,
      clr => sig.clr,
      input => sig.input,
      output => sig.output
    );

  tick : PROCESS
  BEGIN
    clk <= '0';
    WAIT FOR TIME_SPAN / 2;
    clk <= '1';
    WAIT FOR TIME_SPAN / 2;
  END PROCESS;

  main : PROCESS
  BEGIN
    test_runner_setup(runner, runner_cfg);

    FOR i IN tests'RANGE LOOP

      sig.ld <= tests(i).ld;
      sig.clr <= tests(i).clr;
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