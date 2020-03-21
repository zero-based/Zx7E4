LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.vector_bus.ALL;

ENTITY mux IS
  GENERIC (
    SEL_COUNT : NATURAL := 2;
    DATA_SIZE : NATURAL := 1
  );
  PORT (
    input : IN vector_bus_t (0 TO 2 ** SEL_COUNT - 1)(DATA_SIZE - 1 DOWNTO 0);
    selector : IN std_logic_vector (SEL_COUNT - 1 DOWNTO 0);
    output : OUT std_logic_vector (DATA_SIZE - 1 DOWNTO 0)
  );
END mux;

ARCHITECTURE behaviour OF mux IS
BEGIN
  output <= input(to_integer(unsigned(selector)));
END behaviour;