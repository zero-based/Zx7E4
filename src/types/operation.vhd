LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE operation IS
  CONSTANT OP_SIZE : NATURAL := 4;
  SUBTYPE operation_t IS std_logic_vector (OP_SIZE - 1 DOWNTO 0);
END PACKAGE;