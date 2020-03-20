LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decoder IS
  GENERIC (SIZE : NATURAL := 4);
  PORT (
    input : IN NATURAL RANGE 0 TO SIZE - 1;
    output : OUT std_logic_vector (SIZE - 1 DOWNTO 0)
  );
END decoder;

ARCHITECTURE behaviour OF decoder IS
BEGIN
  PROCESS(input) BEGIN
    output <= (OTHERS => '0');
    output(input) <= '1';
  END PROCESS;
END behaviour;