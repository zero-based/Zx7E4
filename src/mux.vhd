LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux IS
  GENERIC (SIZE : NATURAL := 4);
  PORT (
    input : IN std_logic_vector(SIZE - 1 DOWNTO 0);
    selector : IN NATURAL RANGE 0 TO SIZE - 1;
    output : OUT std_logic
  );
END mux;

ARCHITECTURE behaviour OF mux IS
BEGIN
  output <= input(selector);
END behaviour;