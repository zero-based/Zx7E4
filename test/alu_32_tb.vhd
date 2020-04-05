LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
USE work.timing.ALL;
USE work.operation.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY alu_32_tb IS
  GENERIC (runner_cfg : STRING);
END alu_32_tb;

ARCHITECTURE tb OF alu_32_tb IS

  CONSTANT N : NATURAL := 32;

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
  (X"C0000000", X"A0000000", AND_OP, '-', X"80000000", '-', '0', '-'),
  (X"C0000000", X"A0000000", OR_OP , '-', X"E0000000", '-', '0', '-'),
  (X"70000000", X"60000000", ADD_OP, '0', X"D0000000", '0', '0', '1'),
  (X"F0000000", X"10000000", ADD_OP, '0', X"00000000", '1', '1', '0'),
  (X"00000007", X"00000006", SUB_OP, '1', X"00000001", '1', '0', '0'),
  (X"00000006", X"00000007", SUB_OP, '1', X"FFFFFFFF", '0', '0', '0'),
  (X"FFFFFFF8", X"00000001", SUB_OP, '1', X"FFFFFFF7", '1', '0', '0')
  );

BEGIN

  UUT : ENTITY work.alu
    GENERIC MAP(N => N)
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

      ASSERT (sig.res = tests(i).res OR tests(i).res = X"--------")
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