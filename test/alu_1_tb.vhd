LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY alu_1_tb IS
    GENERIC (runner_cfg : STRING);
END alu_1_tb;

ARCHITECTURE tb OF alu_1_tb IS

    SIGNAL a, b : std_logic;
    SIGNAL cin : std_logic;
    SIGNAL less : std_logic;
    SIGNAL operation : std_logic_vector(3 DOWNTO 0);
    SIGNAL cout : std_logic;
    SIGNAL res : std_logic;

    TYPE test_case IS RECORD
        a, b : std_logic;
        cin : std_logic;
        less : std_logic;
        operation : std_logic_vector(3 DOWNTO 0);
        cout : std_logic;
        res : std_logic;
    END RECORD;

    TYPE test_case_array IS ARRAY (NATURAL RANGE <>) OF test_case;

    CONSTANT time_span : TIME := 20 ns;
    CONSTANT test_cases : test_case_array := (
    -- a and b (0 - 3)
    ('0', '0', '0', '0', "0000", '-', '0'),
    ('0', '1', '0', '0', "0000", '-', '0'),
    ('1', '0', '0', '0', "0000", '-', '0'),
    ('1', '1', '0', '0', "0000", '-', '1'),

    ('0', '0', '0', '0', "0001", '-', '0'),
    ('0', '1', '0', '0', "0001", '-', '1'),
    ('1', '0', '0', '0', "0001", '-', '1'),
    ('1', '1', '0', '0', "0001", '-', '1'),

    ('0', '0', '0', '0', "1100", '-', '1'),
    ('0', '1', '0', '0', "1100", '-', '0'),
    ('1', '0', '0', '0', "1100", '-', '0'),
    ('1', '1', '0', '0', "1100", '-', '0'),

    ('0', '0', '0', '0', "0010", '0', '0'), --  0 +  0 + 0
    ('0', '0', '1', '0', "0010", '0', '1'), --  0 +  0 + 1
    ('0', '0', '0', '0', "0110", '0', '1'), --  0 + !0 + 0
    ('0', '0', '1', '0', "0110", '1', '0'), --  0 + !0 + 1
    ('0', '0', '0', '0', "1010", '0', '1'), -- !0 +  0 + 0
    ('0', '0', '1', '0', "1010", '1', '0'), -- !0 +  0 + 1
    ('0', '0', '0', '0', "1110", '1', '0'), -- !0 + !0 + 0
    ('0', '0', '1', '0', "1110", '1', '1'), -- !0 + !0 + 1

    ('0', '1', '0', '0', "0010", '0', '1'), --  0 +  1 + 0
    ('0', '1', '1', '0', "0010", '1', '0'), --  0 +  1 + 1
    ('0', '1', '0', '0', "0110", '0', '0'), --  0 + !1 + 0
    ('0', '1', '1', '0', "0110", '0', '1'), --  0 + !1 + 1
    ('0', '1', '0', '0', "1010", '1', '0'), -- !0 +  1 + 0
    ('0', '1', '1', '0', "1010", '1', '1'), -- !0 +  1 + 1
    ('0', '1', '0', '0', "1110", '0', '1'), -- !0 + !1 + 0
    ('0', '1', '1', '0', "1110", '1', '0'), -- !0 + !1 + 1

    ('1', '0', '0', '0', "0010", '0', '1'), --  1 +  0 + 0
    ('1', '0', '1', '0', "0010", '1', '0'), --  1 +  0 + 1
    ('1', '0', '0', '0', "0110", '1', '0'), --  1 + !0 + 0
    ('1', '0', '1', '0', "0110", '1', '1'), --  1 + !0 + 1
    ('1', '0', '0', '0', "1010", '0', '0'), -- !1 +  0 + 0
    ('1', '0', '1', '0', "1010", '0', '1'), -- !1 +  0 + 1
    ('1', '0', '0', '0', "1110", '0', '1'), -- !1 + !0 + 0
    ('1', '0', '1', '0', "1110", '1', '0'), -- !1 + !0 + 1

    ('1', '1', '0', '0', "0010", '1', '0'), --  1 +  1 + 0
    ('1', '1', '1', '0', "0010", '1', '1'), --  1 +  1 + 1
    ('1', '1', '0', '0', "0110", '0', '1'), --  1 + !1 + 0
    ('1', '1', '1', '0', "0110", '1', '0'), --  1 + !1 + 1
    ('1', '1', '0', '0', "1010", '0', '1'), -- !1 +  1 + 0
    ('1', '1', '1', '0', "1010", '1', '0'), -- !1 +  1 + 1
    ('1', '1', '0', '0', "1110", '0', '0'), -- !1 + !1 + 0
    ('1', '1', '1', '0', "1110", '0', '1') -- !1 + !1 + 1
    );

BEGIN

    UUT : ENTITY work.alu_1
        PORT MAP(
            a => a,
            b => b,
            cin => cin,
            less => less,
            operation => operation,
            cout => cout,
            res => res
        );

    main : PROCESS
    BEGIN

        test_runner_setup(runner, runner_cfg);

        FOR i IN test_cases'RANGE LOOP

            a <= test_cases(i).a;
            b <= test_cases(i).b;
            cin <= test_cases(i).cin;
            less <= test_cases(i).less;
            operation <= test_cases(i).operation;

            WAIT FOR time_span;

            IF (test_cases(i).cout /= '-') THEN
                ASSERT (cout = test_cases(i).cout)
                REPORT "test " & INTEGER'image(i) & " failed [BAD C.OUT]" SEVERITY error;
            END IF;

            ASSERT (res = test_cases(i).res)
            REPORT "test " & INTEGER'image(i) & " failed [BAD Result]" SEVERITY error;

        END LOOP;

        WAIT FOR time_span;
        test_runner_cleanup(runner);
        WAIT;

    END PROCESS;

END tb;