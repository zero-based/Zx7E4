LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.operation.ALL;

ENTITY alu IS
  GENERIC (N : NATURAL := 4);
  PORT (
    a : IN std_logic_vector (N - 1 DOWNTO 0);
    b : IN std_logic_vector (N - 1 DOWNTO 0);
    op : IN operation_t;
    c_in : IN std_logic;
    res : OUT std_logic_vector (N - 1 DOWNTO 0);
    cf : OUT std_logic := '0';
    zf : OUT std_logic := '0';
    vf : OUT std_logic := '0'
  );
END alu;

ARCHITECTURE behaviour OF alu IS

  SIGNAL sf : std_logic;
  SIGNAL ci_x_co : std_logic;
  SIGNAL c_bus : std_logic_vector (N - 1 DOWNTO 0);
  SIGNAL tmp : std_logic_vector (N - 1 DOWNTO 0);

BEGIN

  first : ENTITY work.alu_1
    PORT MAP(
      a => a(0),
      b => b(0),
      op => op(3 DOWNTO 0),
      c_in => c_in,
      less => ci_x_co XOR sf,
      c_out => c_bus(0),
      res => tmp(0),
      set => OPEN
    );

  gen_alu : FOR i IN 1 TO N - 2 GENERATE
    mid : ENTITY work.alu_1
      PORT MAP(
        a => a(i),
        b => b(i),
        op => op(3 DOWNTO 0),
        c_in => c_bus(i - 1),
        less => '0',
        c_out => c_bus(i),
        res => tmp(i),
        set => OPEN
      );
  END GENERATE gen_alu;

  last : ENTITY work.alu_1
    PORT MAP(
      a => a(N - 1),
      b => b(N - 1),
      op => op(3 DOWNTO 0),
      c_in => c_bus(N - 2),
      less => '0',
      c_out => c_bus(N - 1),
      res => tmp(N - 1),
      set => sf
    );

  res <= tmp;
  ci_x_co <= c_bus(N - 2) XOR c_bus(N - 1);

  zf <= '1' WHEN tmp = (tmp'RANGE => '0') ELSE '0';
  cf <= NOT c_bus(N - 1) WHEN op = SUB_OP ELSE c_bus(N - 1); -- invert carry flag for sub operations
  vf <= ci_x_co;

END behaviour;