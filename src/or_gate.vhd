LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY or_gate IS
  PORT (
    a, b : IN std_logic;
    res : OUT std_logic
  );
END or_gate;

ARCHITECTURE behaviour OF or_gate IS
BEGIN
  res <= a OR b;
END behaviour;