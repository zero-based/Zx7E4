LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.vector_bus.ALL;

ENTITY RegisterFile IS

  GENERIC (
    N : NATURAL := 5;
    SIZE : NATURAL := 32
  );

  PORT (
    read_sel1 : IN std_logic_vector (N - 1 DOWNTO 0);
    read_sel2 : IN std_logic_vector (N - 1 DOWNTO 0);
    write_sel : IN std_logic_vector (N - 1 DOWNTO 0);
    write_ena : IN std_logic;
    clk : IN std_logic;
    write_data : IN std_logic_vector (SIZE - 1 DOWNTO 0);
    data1 : OUT std_logic_vector (SIZE - 1 DOWNTO 0);
    data2 : OUT std_logic_vector (SIZE - 1 DOWNTO 0)
  );

END RegisterFile;

ARCHITECTURE behaviour OF RegisterFile IS
  SIGNAL reg_bus : vector_bus_t (0 TO 2 ** N - 1)(SIZE - 1 DOWNTO 0);
  SIGNAL dec_bus : std_logic_vector (2 ** N - 1 DOWNTO 0);
  SIGNAL and_bus : std_logic_vector (2 ** N - 1 DOWNTO 0);
BEGIN

  decoder : ENTITY work.decoder
    GENERIC MAP(N => N)
    PORT MAP(
      input => write_sel,
      output => dec_bus
    );

  gen_reg : FOR i IN 0 TO 2 ** N - 1 GENERATE

    and_bus(i) <= write_ena AND dec_bus(i);

    reg : ENTITY work.reg
      PORT MAP(
        clk => clk,
        ld => and_bus(i),
        clr => '0',
        input => write_data,
        output => reg_bus(i)
      );

  END GENERATE gen_reg;

  mux_1 : ENTITY work.mux
    GENERIC MAP(
      N => N,
      SIZE => SIZE
    )
    PORT MAP(
      input => reg_bus,
      sel => read_sel1,
      output => data1
    );

  mux_2 : ENTITY work.mux
    GENERIC MAP(
      N => N,
      SIZE => SIZE
    )
    PORT MAP(
      input => reg_bus,
      sel => read_sel2,
      output => data2
    );

END behaviour;