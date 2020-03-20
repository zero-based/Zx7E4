LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux IS
  GENERIC (SIZE : NATURAL := 2);
  PORT (
    input : IN std_logic_vector (2 ** SIZE - 1 DOWNTO 0);
    selector : IN std_logic_vector (SIZE - 1 DOWNTO 0);
    output : OUT std_logic
  );
END mux;

ARCHITECTURE behaviour OF mux IS
BEGIN
  output <= input(to_integer(unsigned(selector)));
END behaviour;