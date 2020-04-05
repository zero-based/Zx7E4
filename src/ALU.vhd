LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE work.operation.ALL;

ENTITY ALU IS
  GENERIC (N : NATURAL := 32);
  PORT (
    data1 : IN std_logic_vector (N - 1 DOWNTO 0);
    data2 : IN std_logic_vector (N - 1 DOWNTO 0);
    aluop : IN operation_t;
    cin : IN std_logic;
    dataout : OUT std_logic_vector (N - 1 DOWNTO 0);
    cflag : OUT std_logic := '0';
    zflag : OUT std_logic := '0';
    oflag : OUT std_logic := '0'
  );
END ALU;

ARCHITECTURE behaviour OF ALU IS

  SIGNAL sf : std_logic;
  SIGNAL io_bus : std_logic_vector (N - 1 DOWNTO 0);

BEGIN

  first : ENTITY work.alu_bit
    PORT MAP(
      a => data1(0),
      b => data2(0),
      op => aluop(3 DOWNTO 0),
      c_in => cin,
      less => oflag XOR sf,
      c_out => io_bus(0),
      res => dataout(0),
      set => OPEN
    );

  gen_alu : FOR i IN 1 TO N - 2 GENERATE
    mid : ENTITY work.alu_bit
      PORT MAP(
        a => data1(i),
        b => data2(i),
        op => aluop(3 DOWNTO 0),
        c_in => io_bus(i - 1),
        less => '0',
        c_out => io_bus(i),
        res => dataout(i),
        set => OPEN
      );
  END GENERATE gen_alu;

  last : ENTITY work.alu_bit
    PORT MAP(
      a => data1(N - 1),
      b => data2(N - 1),
      op => aluop(3 DOWNTO 0),
      c_in => io_bus(N - 2),
      less => '0',
      c_out => io_bus(N - 1),
      res => dataout(N - 1),
      set => sf
    );

  cflag <= io_bus(N - 1);
  zflag <= '1' WHEN dataout = (dataout'RANGE => '0') ELSE '0';
  oflag <= io_bus(N - 2) XOR io_bus(N - 1);

END behaviour;