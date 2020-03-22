LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.vector_bus.ALL;

ENTITY register_file IS

  GENERIC (
    N : NATURAL := 5;
    SIZE : NATURAL := 32
  );

  PORT (
    clk : IN std_logic;
    wr_en : IN std_logic;
    wr_num : IN std_logic_vector (N - 1 DOWNTO 0);
    rd_num_1 : IN std_logic_vector (N - 1 DOWNTO 0);
    rd_num_2 : IN std_logic_vector (N - 1 DOWNTO 0);
    wr : IN std_logic_vector (SIZE - 1 DOWNTO 0);
    rd_1 : OUT std_logic_vector (SIZE - 1 DOWNTO 0);
    rd_2 : OUT std_logic_vector (SIZE - 1 DOWNTO 0)
  );

END register_file;

ARCHITECTURE behaviour OF register_file IS
  SIGNAL reg_bus : vector_bus_t (0 TO 2 ** N - 1)(SIZE - 1 DOWNTO 0);
  SIGNAL dec_bus : std_logic_vector (2 ** N - 1 DOWNTO 0);
  SIGNAL and_bus : std_logic_vector (2 ** N - 1 DOWNTO 0);
BEGIN

  decoder : ENTITY work.decoder
    GENERIC MAP(N => N)
    PORT MAP(
      input => wr_num,
      output => dec_bus
    );

  bank : FOR i IN 0 TO 2 ** N - 1 GENERATE

    and_bus(i) <= wr_en AND dec_bus(i);

    reg : ENTITY work.reg
      PORT MAP(
        clk => clk,
        ld => and_bus(i),
        clr => '0',
        input => wr,
        output => reg_bus(i)
      );

  END GENERATE;

  mux_1 : ENTITY work.mux
    GENERIC MAP(
      N => N,
      SIZE => SIZE
    )
    PORT MAP(
      input => reg_bus,
      sel => rd_num_1,
      output => rd_1
    );

  mux_2 : ENTITY work.mux
    GENERIC MAP(
      N => N,
      SIZE => SIZE
    )
    PORT MAP(
      input => reg_bus,
      sel => rd_num_2,
      output => rd_2
    );

END behaviour;