LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu IS

  GENERIC (
    BITS_COUNT : NATURAL := 4
  );

  PORT (
    data_1 : IN std_logic_vector(BITS_COUNT - 1 DOWNTO 0);
    data_2 : IN std_logic_vector(BITS_COUNT - 1 DOWNTO 0);
    operation : IN std_logic_vector(3 DOWNTO 0);
    cin : IN std_logic;
    data_out : OUT std_logic_vector(BITS_COUNT - 1 DOWNTO 0);
    cflag : OUT std_logic := '0';
    zflag : OUT std_logic := '0';
    oflag : OUT std_logic := '0'
  );

END alu;

ARCHITECTURE behaviour OF alu IS

  SIGNAL less_first : std_logic;
  SIGNAL sflag : std_logic;
  SIGNAL inverted_cflag : std_logic;
  SIGNAL io_bus : std_logic_vector (BITS_COUNT - 1 DOWNTO 0);

  FUNCTION or_reduce(vec : std_logic_vector) RETURN std_logic IS
    VARIABLE result : std_logic := '0';
  BEGIN
    FOR i IN vec'RANGE LOOP
      result := result OR vec(i);
      EXIT WHEN result = '1';
    END LOOP;
    RETURN result;
  END or_reduce;

BEGIN

  first_alu_1 : ENTITY work.alu_1
    PORT MAP(
      a => data_1(0),
      b => data_2(0),
      operation => operation(3 DOWNTO 0),
      cin => cin,
      less => less_first,
      cout => io_bus(0),
      res => data_out(0),
      set => OPEN
    );

  gen_alu : FOR i IN 1 TO BITS_COUNT - 2 GENERATE
    alu_1 : ENTITY work.alu_1
      PORT MAP(
        a => data_1(i),
        b => data_2(i),
        operation => operation(3 DOWNTO 0),
        cin => io_bus(i - 1),
        less => '0',
        cout => io_bus(i),
        res => data_out(i),
        set => OPEN
      );
  END GENERATE gen_alu;

  last_alu_1 : ENTITY work.alu_1
    PORT MAP(
      a => data_1(BITS_COUNT - 1),
      b => data_2(BITS_COUNT - 1),
      operation => operation(3 DOWNTO 0),
      cin => io_bus(BITS_COUNT - 2),
      less => '0',
      cout => io_bus(BITS_COUNT - 1),
      res => data_out(BITS_COUNT - 1),
      set => sflag
    );

  inverted_cflag <= io_bus(BITS_COUNT - 1) XOR '1';
  zflag <= NOT or_reduce(data_out);
  oflag <= io_bus(BITS_COUNT - 2) XOR io_bus(BITS_COUNT - 1);
  cflag <= inverted_cflag WHEN operation = "0110" ELSE
    io_bus(BITS_COUNT - 1);
  less_first <= oflag XOR sflag;

END behaviour;