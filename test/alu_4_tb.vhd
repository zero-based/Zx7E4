LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
USE work.timing.ALL;
USE work.operation.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY alu_4_tb IS
  GENERIC (runner_cfg : STRING);
END alu_4_tb;

ARCHITECTURE tb OF alu_4_tb IS

  CONSTANT N : NATURAL := 4;

  TYPE test_t IS RECORD
    a : std_logic_vector (N - 1 DOWNTO 0);
    b : std_logic_vector (N - 1 DOWNTO 0);
    op : operation_t;
    c_in : std_logic;
    res : std_logic_vector (N - 1 DOWNTO 0);
    cf : std_logic;
    zf : std_logic;
    vf : std_logic;
  END RECORD;

  TYPE test_array_t IS ARRAY (NATURAL RANGE <>) OF test_t;

  SIGNAL sig : test_t;

  CONSTANT tests : test_array_t := (
  ("0101", "1010", AND_OP, '-', "0000", '-', '1', '-'), -- and
  ("0101", "1010", OR_OP , '-', "1111", '-', '0', '-'), -- or
  ("0000", "0000", NOR_OP, '-', "1111", '-', '0', '-'), -- nor
  ("0101", "1010", ADD_OP, '0', "1111", '0', '0', '0'), -- add with no flags
  ("1111", "1111", ADD_OP, '0', "1110", '1', '0', '0'), -- add with carry flag
  ("1000", "1000", ADD_OP, '0', "0000", '1', '1', '1'), -- add with all flags
  ("0001", "0010", SUB_OP, '1', "1111", '0', '0', '0'), -- sub with no flags
  ("0010", "0001", SUB_OP, '1', "0001", '1', '0', '0'), -- sub with carry flag
  ("1111", "1111", SUB_OP, '1', "0000", '1', '1', '0'), -- sub with zero flag
  ("0001", "0010", SLT_OP, '1', "0001", '-', '0', '-'), -- set less than
  ("0010", "0001", SLT_OP, '1', "0000", '-', '1', '-') -- set less than
  );

BEGIN

  UUT : ENTITY work.alu
    PORT MAP(
      a => sig.a,
      b => sig.b,
      op => sig.op,
      c_in => sig.c_in,
      res => sig.res,
      cf => sig.cf,
      zf => sig.zf,
      vf => sig.vf
    );

  main : PROCESS
  BEGIN

    test_runner_setup(runner, runner_cfg);

    FOR i IN tests'RANGE LOOP

      sig.a <= tests(i).a;
      sig.b <= tests(i).b;
      sig.op <= tests(i).op;
      sig.c_in <= tests(i).c_in;

      WAIT FOR TIME_SPAN;

      ASSERT (sig.res = tests(i).res OR tests(i).res = "----")
      REPORT "test " & INTEGER'image(i) & " failed [res]" SEVERITY error;

      ASSERT (sig.cf = tests(i).cf OR tests(i).cf = '-')
      REPORT "test " & INTEGER'image(i) & " failed [cf]" SEVERITY error;

      ASSERT (sig.zf = tests(i).zf OR tests(i).zf = '-')
      REPORT "test " & INTEGER'image(i) & " failed [zf]" SEVERITY error;

      ASSERT (sig.vf = tests(i).vf OR tests(i).vf = '-')
      REPORT "test " & INTEGER'image(i) & " failed [of]" SEVERITY error;

    END LOOP;

    WAIT FOR TIME_SPAN;
    test_runner_cleanup(runner);
    WAIT;

  END PROCESS;

END tb;