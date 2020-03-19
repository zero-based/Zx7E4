LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY not_gate IS
    PORT (
        a   : IN std_logic;
        not_a : OUT std_logic
    );
END not_gate;

ARCHITECTURE behaviour OF not_gate IS
BEGIN
    not_a <= not (a);
END behaviour;