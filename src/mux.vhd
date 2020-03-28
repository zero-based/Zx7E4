LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux IS
  GENERIC (
    N : NATURAL := 2;
    SIZE : NATURAL := 1
  );
  PORT (
    input : IN std_logic_vector ((2 ** N) * SIZE - 1 DOWNTO 0);
    sel : IN std_logic_vector (N - 1 DOWNTO 0);
    output : OUT std_logic_vector (SIZE - 1 DOWNTO 0)
  );
END mux;

ARCHITECTURE behaviour OF mux IS
BEGIN
  output <= input(
    (to_integer(unsigned(sel)) + 1) * SIZE - 1
    DOWNTO
    to_integer(unsigned(sel)) * SIZE);
END behaviour;