LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.operation.ALL;

ENTITY alu IS

  GENERIC (
    BITS_COUNT : NATURAL := 4
  );

  PORT (
    a : IN std_logic_vector (BITS_COUNT - 1 DOWNTO 0);
    b : IN std_logic_vector (BITS_COUNT - 1 DOWNTO 0);
    op : IN operation_t;
    c_in : IN std_logic;
    data_out : OUT std_logic_vector (BITS_COUNT - 1 DOWNTO 0);
    cf : OUT std_logic := '0';
    zf : OUT std_logic := '0';
    vf : OUT std_logic := '0'
  );

END alu;

ARCHITECTURE behaviour OF alu IS

  CONSTANT sub_op : operation_t := "0110";

  SIGNAL less_first : std_logic;
  SIGNAL sf : std_logic;
  SIGNAL cf_inv : std_logic;
  SIGNAL io_bus : std_logic_vector (BITS_COUNT - 1 DOWNTO 0);

  FUNCTION or_reduce(vec : std_logic_vector) RETURN std_logic IS
    VARIABLE res : std_logic := '0';
  BEGIN
    FOR i IN vec'RANGE LOOP
      res := res OR vec(i);
      EXIT WHEN res = '1';
    END LOOP;
    RETURN res;
  END or_reduce;

BEGIN

  first_alu_1 : ENTITY work.alu_1
    PORT MAP(
      a => a(0),
      b => b(0),
      op => op(3 DOWNTO 0),
      c_in => c_in,
      less => vf XOR sf,
      c_out => io_bus(0),
      res => data_out(0),
      set => OPEN
    );

  gen_alu : FOR i IN 1 TO BITS_COUNT - 2 GENERATE
    alu_1 : ENTITY work.alu_1
      PORT MAP(
        a => a(i),
        b => b(i),
        op => op(3 DOWNTO 0),
        c_in => io_bus(i - 1),
        less => '0',
        c_out => io_bus(i),
        res => data_out(i),
        set => OPEN
      );
  END GENERATE gen_alu;

  last_alu_1 : ENTITY work.alu_1
    PORT MAP(
      a => a(BITS_COUNT - 1),
      b => b(BITS_COUNT - 1),
      op => op(3 DOWNTO 0),
      c_in => io_bus(BITS_COUNT - 2),
      less => '0',
      c_out => io_bus(BITS_COUNT - 1),
      res => data_out(BITS_COUNT - 1),
      set => sf
    );

  cf_inv <= io_bus(BITS_COUNT - 1) XOR '1';
  zf <= NOT or_reduce(data_out);
  vf <= io_bus(BITS_COUNT - 2) XOR io_bus(BITS_COUNT - 1);
  cf <= cf_inv WHEN op = sub_op ELSE
    io_bus(BITS_COUNT - 1);

END behaviour;