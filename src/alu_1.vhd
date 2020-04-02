LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.operation.ALL;

ENTITY alu_1 IS
  PORT (
    a : IN std_logic;
    b : IN std_logic;
    c_in : IN std_logic;
    less : IN std_logic;
    op : IN operation_t;
    c_out : OUT std_logic;
    res : OUT std_logic;
    set : OUT std_logic
  );
END alu_1;

ARCHITECTURE behaviour OF alu_1 IS

  SIGNAL mux_a_res : std_logic;
  SIGNAL mux_b_res : std_logic;

BEGIN

  mux_a : ENTITY work.mux
    GENERIC MAP(N => 1)
    PORT MAP(
      input(0)(0) => a,
      input(1)(0) => NOT a,
      sel(0) => op(3),
      output(0) => mux_a_res
    );

  mux_b : ENTITY work.mux
    GENERIC MAP(N => 1)
    PORT MAP(
      input(0)(0) => b,
      input(1)(0) => NOT b,
      sel(0) => op(2),
      output(0) => mux_b_res
    );

  a_add_b : ENTITY work.full_adder
    PORT MAP(
      a => mux_a_res,
      b => mux_b_res,
      c_in => c_in,
      sum => set,
      c_out => c_out
    );

  mux_4 : ENTITY work.mux
    PORT MAP(
      input(0)(0) => mux_a_res AND mux_b_res,
      input(1)(0) => mux_a_res OR mux_b_res,
      input(2)(0) => set,
      input(3)(0) => less,
      sel => op (1 DOWNTO 0),
      output(0) => res
    );

END behaviour;