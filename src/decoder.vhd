LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY decoder IS
  GENERIC (N : NATURAL := 2);
  PORT (
    input : IN std_logic_vector (N - 1 DOWNTO 0);
    output : OUT std_logic_vector (2 ** N - 1 DOWNTO 0)
  );
END decoder;

ARCHITECTURE behaviour OF decoder IS
BEGIN
  PROCESS (input) BEGIN
    output <= (OTHERS => '0');
    output(to_integer(unsigned(input))) <= '1';
  END PROCESS;
END behaviour;