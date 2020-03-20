LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg IS
    GENERIC (SIZE : NATURAL := 32);
    PORT (
        clk : IN std_logic; -- clock.
        ld : IN std_logic; -- load/enable.
        clr : IN std_logic; -- async. clear.
        input : IN std_logic_vector(SIZE - 1 DOWNTO 0); --input
        output : OUT std_logic_vector(SIZE - 1 DOWNTO 0) -- output.
    );
END reg;

ARCHITECTURE behaviour OF reg IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (ld = '1') THEN
                output <= input;
            ELSIF (clr = '1') THEN
                output <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;
END behaviour;