LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
USE work.timing.ALL;
USE work.operation.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY alu_bit_tb IS
  GENERIC (runner_cfg : STRING);
END alu_bit_tb;

ARCHITECTURE tb OF alu_bit_tb IS

  TYPE test_t IS RECORD
    a : std_logic;
    b : std_logic;
    c_in : std_logic;
    less : std_logic;
    op : operation_t;
    c_out : std_logic;
    res : std_logic;
  END RECORD;

  TYPE test_array_t IS ARRAY (NATURAL RANGE <>) OF test_t;

  SIGNAL sig : test_t;

  CONSTANT tests : test_array_t := (
  -- a and b
  ('0', '0', '0', '0', AND_OP, '-', '0'),
  ('0', '1', '0', '0', AND_OP, '-', '0'),
  ('1', '0', '0', '0', AND_OP, '-', '0'),
  ('1', '1', '0', '0', AND_OP, '-', '1'),

  -- a or b
  ('0', '0', '0', '0', OR_OP, '-', '0'),
  ('0', '1', '0', '0', OR_OP, '-', '1'),
  ('1', '0', '0', '0', OR_OP, '-', '1'),
  ('1', '1', '0', '0', OR_OP, '-', '1'),

  -- a nor b
  ('0', '0', '0', '0', NOR_OP, '-', '1'),
  ('0', '1', '0', '0', NOR_OP, '-', '0'),
  ('1', '0', '0', '0', NOR_OP, '-', '0'),
  ('1', '1', '0', '0', NOR_OP, '-', '0'),

  -- a + b
  ('0', '0', '0', '0', ADD_OP, '0', '0'), --  0 +  0 + 0
  ('0', '0', '1', '0', ADD_OP, '0', '1'), --  0 +  0 + 1
  ('0', '1', '0', '0', ADD_OP, '0', '1'), --  0 +  1 + 0
  ('0', '1', '1', '0', ADD_OP, '1', '0'), --  0 +  1 + 1
  ('1', '0', '0', '0', ADD_OP, '0', '1'), --  1 +  0 + 0
  ('1', '0', '1', '0', ADD_OP, '1', '0'), --  1 +  0 + 1
  ('1', '1', '0', '0', ADD_OP, '1', '0'), --  1 +  1 + 0
  ('1', '1', '1', '0', ADD_OP, '1', '1'), --  1 +  1 + 1

  -- a - b
  ('0', '0', '0', '0', SUB_OP,  '0', '1'), --  0 + !0 + 0
  ('0', '0', '1', '0', SUB_OP,  '1', '0'), --  0 + !0 + 1
  ('0', '1', '0', '0', SUB_OP,  '0', '0'), --  0 + !1 + 0
  ('0', '1', '1', '0', SUB_OP,  '0', '1'), --  0 + !1 + 1
  ('1', '0', '0', '0', SUB_OP,  '1', '0'), --  1 + !0 + 0
  ('1', '0', '1', '0', SUB_OP,  '1', '1'), --  1 + !0 + 1
  ('1', '1', '0', '0', SUB_OP,  '0', '1'), --  1 + !1 + 0
  ('1', '1', '1', '0', SUB_OP,  '1', '0'), --  1 + !1 + 1

  -- -a + b
  ('0', '0', '0', '0', NADD_OP, '0', '1'), -- !0 +  0 + 0
  ('0', '0', '1', '0', NADD_OP, '1', '0'), -- !0 +  0 + 1
  ('0', '1', '0', '0', NADD_OP, '1', '0'), -- !0 +  1 + 0
  ('0', '1', '1', '0', NADD_OP, '1', '1'), -- !0 +  1 + 1
  ('1', '0', '0', '0', NADD_OP, '0', '0'), -- !1 +  0 + 0
  ('1', '0', '1', '0', NADD_OP, '0', '1'), -- !1 +  0 + 1
  ('1', '1', '0', '0', NADD_OP, '0', '1'), -- !1 +  1 + 0
  ('1', '1', '1', '0', NADD_OP, '1', '0'), -- !1 +  1 + 1

  -- -a - b
  ('0', '0', '0', '0', NSUB_OP, '1', '0'), -- !0 + !0 + 0
  ('0', '0', '1', '0', NSUB_OP, '1', '1'), -- !0 + !0 + 1
  ('0', '1', '0', '0', NSUB_OP, '0', '1'), -- !0 + !1 + 0
  ('0', '1', '1', '0', NSUB_OP, '1', '0'), -- !0 + !1 + 1
  ('1', '0', '0', '0', NSUB_OP, '0', '1'), -- !1 + !0 + 0
  ('1', '0', '1', '0', NSUB_OP, '1', '0'), -- !1 + !0 + 1
  ('1', '1', '0', '0', NSUB_OP, '0', '0'), -- !1 + !1 + 0
  ('1', '1', '1', '0', NSUB_OP, '0', '1')  -- !1 + !1 + 1
  );

BEGIN

  UUT : ENTITY work.alu_bit
    PORT MAP(
      a => sig.a,
      b => sig.b,
      c_in => sig.c_in,
      less => sig.less,
      op => sig.op,
      c_out => sig.c_out,
      res => sig.res,
      set => OPEN
    );

  main : PROCESS
  BEGIN

    test_runner_setup(runner, runner_cfg);

    FOR i IN tests'RANGE LOOP

      sig.a <= tests(i).a;
      sig.b <= tests(i).b;
      sig.c_in <= tests(i).c_in;
      sig.less <= tests(i).less;
      sig.op <= tests(i).op;

      WAIT FOR TIME_SPAN;

      ASSERT (sig.c_out = tests(i).c_out OR tests(i).c_out = '-')
      REPORT "test " & INTEGER'image(i) & " failed [c_out]" SEVERITY error;

      ASSERT (sig.res = tests(i).res)
      REPORT "test " & INTEGER'image(i) & " failed [res]" SEVERITY error;

    END LOOP;

    WAIT FOR TIME_SPAN;
    test_runner_cleanup(runner);
    WAIT;

  END PROCESS;

END tb;