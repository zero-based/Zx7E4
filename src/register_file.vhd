LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.vector_bus.ALL;

ENTITY register_file IS

  GENERIC (
    COUNT_BITS : NATURAL := 5;
    REG_SIZE : NATURAL := 32
  );

  PORT (
    clk : IN std_logic;
    write_enable : IN std_logic;
    write_num : IN std_logic_vector (COUNT_BITS - 1 DOWNTO 0);
    read_num_1 : IN std_logic_vector (COUNT_BITS - 1 DOWNTO 0);
    read_num_2 : IN std_logic_vector (COUNT_BITS - 1 DOWNTO 0);
    write_data : IN std_logic_vector (REG_SIZE - 1 DOWNTO 0);
    read_data_1 : OUT std_logic_vector (REG_SIZE - 1 DOWNTO 0);
    read_data_2 : OUT std_logic_vector (REG_SIZE - 1 DOWNTO 0)
  );

END register_file;

ARCHITECTURE behaviour OF register_file IS
  SIGNAL reg_output : vector_bus_t (0 TO 2 ** COUNT_BITS - 1)(REG_SIZE - 1 DOWNTO 0);
  SIGNAL decoder_output : std_logic_vector (2 ** COUNT_BITS - 1 DOWNTO 0);
  SIGNAL and_output : std_logic_vector (2 ** COUNT_BITS - 1 DOWNTO 0);
BEGIN

  decoder : ENTITY work.decoder
    GENERIC MAP(SIZE => COUNT_BITS)
    PORT MAP(
      input => write_num,
      output => decoder_output
    );

  bank : FOR i IN 0 TO 2 ** COUNT_BITS - 1 GENERATE

    ang_gate : ENTITY work.and_gate
      PORT MAP(
        a => write_enable,
        b => decoder_output(i),
        res => and_output(i)
      );

    reg : ENTITY work.reg
      PORT MAP(
        clk => clk,
        ld => and_output(i),
        clr => '0',
        input => write_data,
        output => reg_output(i)
      );

  END GENERATE;

  mux_1 : ENTITY work.mux
    GENERIC MAP(
      SEL_COUNT => COUNT_BITS,
      DATA_SIZE => REG_SIZE
    )
    PORT MAP(
      input => reg_output,
      selector => read_num_1,
      output => read_data_1
    );

  mux_2 : ENTITY work.mux
    GENERIC MAP(
      SEL_COUNT => COUNT_BITS,
      DATA_SIZE => REG_SIZE
    )
    PORT MAP(
      input => reg_output,
      selector => read_num_2,
      output => read_data_2
    );

END behaviour;