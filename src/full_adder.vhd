LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY full_adder IS
    PORT (
        a, b : IN std_logic;
        cin : IN std_logic;
        cout : OUT std_logic;
        s : OUT std_logic
    );
END full_adder;

ARCHITECTURE behaviour OF full_adder IS
    SIGNAL temp : std_logic_vector(2 DOWNTO 0);
BEGIN
    s <= a XOR b XOR cin;
    cout <= (a AND b) OR (cin AND a) OR (cin AND b);
END behaviour;