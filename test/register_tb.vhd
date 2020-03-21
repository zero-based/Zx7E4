LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY register_tb IS
    GENERIC (runner_cfg : STRING);
END register_tb;

ARCHITECTURE tb OF register_tb IS
    CONSTANT SIZE : INTEGER := 4;
    SIGNAL clk : std_logic;
    SIGNAL ld : std_logic;
    SIGNAL clr : std_logic;
    SIGNAL input : std_logic_vector(SIZE - 1 DOWNTO 0);
    SIGNAL output : std_logic_vector(SIZE - 1 DOWNTO 0);

    TYPE test_case IS RECORD
        ld : std_logic;
        clr : std_logic;
        input : std_logic_vector(SIZE - 1 DOWNTO 0);
        output : std_logic_vector(SIZE - 1 DOWNTO 0);
    END RECORD;

    TYPE test_case_array IS ARRAY (NATURAL RANGE <>) OF test_case;
    CONSTANT time_span : TIME := 1 us;

    CONSTANT test_cases : test_case_array := (
    ('0', '0', "0000", "UUUU"),
    ('1', '0', "0000", "0000"),
    ('1', '0', "1111", "1111"),
    ('0', '1', "0000", "0000"),
    ('0', '1', "1111", "0000"),
    ('1', '1', "0000", "0000"),
    ('1', '1', "1111", "1111"),
    ('0', '0', "0000", "1111")
    );

BEGIN

    UUT : ENTITY work.reg GENERIC MAP (SIZE => SIZE)
        PORT MAP(clk => clk, ld => ld, clr => clr, input => input, output => output);

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR time_span/2;
        clk <= '1';
        WAIT FOR time_span/2;
    END PROCESS;

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);

        FOR i IN test_cases'RANGE LOOP

            ld <= test_cases(i).ld;
            clr <= test_cases(i).clr;
            input <= test_cases(i).input;

            WAIT FOR time_span;
            ASSERT (output = test_cases(i).output)
            REPORT "test " & INTEGER'image(i) & " failed " SEVERITY error;

        END LOOP;

        WAIT FOR time_span;
        test_runner_cleanup(runner);
        WAIT;
    END PROCESS;
END tb;