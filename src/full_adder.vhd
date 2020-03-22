LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY full_adder IS
  PORT (
    a : IN std_logic;
    b : IN std_logic;
    c_in : IN std_logic;
    sum : OUT std_logic;
    c_out : OUT std_logic
  );
END full_adder;

ARCHITECTURE behaviour OF full_adder IS
BEGIN
  sum <= a XOR b XOR c_in;
  c_out <= (a AND b) OR (c_in AND a) OR (c_in AND b);
END behaviour;