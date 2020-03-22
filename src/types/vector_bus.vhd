LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE vector_bus IS
  TYPE vector_bus_t IS ARRAY (NATURAL RANGE <>) OF std_logic_vector;
END PACKAGE;