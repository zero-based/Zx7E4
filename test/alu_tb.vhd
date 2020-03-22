LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY alu_tb IS
    GENERIC (runner_cfg : STRING);
END alu_tb;

ARCHITECTURE tb OF alu_tb IS

    CONSTANT BITS_COUNT : NATURAL := 4;

    SIGNAL data_1 : std_logic_vector(BITS_COUNT - 1 DOWNTO 0);
    SIGNAL data_2 : std_logic_vector(BITS_COUNT - 1 DOWNTO 0);
    SIGNAL operation : std_logic_vector(3 DOWNTO 0);
    SIGNAL cin : std_logic;
    SIGNAL data_out : std_logic_vector(BITS_COUNT - 1 DOWNTO 0);
    SIGNAL cflag : std_logic;
    SIGNAL zflag : std_logic;
    SIGNAL oflag : std_logic;

    TYPE test_case IS RECORD
        data_1 : std_logic_vector(BITS_COUNT - 1 DOWNTO 0);
        data_2 : std_logic_vector(BITS_COUNT - 1 DOWNTO 0);
        operation : std_logic_vector(3 DOWNTO 0);
        cin : std_logic;
        data_out : std_logic_vector(BITS_COUNT - 1 DOWNTO 0);
        cflag : std_logic;
        zflag : std_logic;
        oflag : std_logic;
    END RECORD;

    TYPE test_case_array IS ARRAY (NATURAL RANGE <>) OF test_case;

    CONSTANT time_span : TIME := 20 ns;
    CONSTANT test_cases : test_case_array := (
    ("0101", "1010", "0000", '-', "0000", '-', '1', '-'), -- and
    ("0101", "1010", "0001", '-', "1111", '-', '0', '-'), -- or
    ("0000", "0000", "1100", '-', "1111", '-', '0', '-'), -- nor
    ("0101", "1010", "0010", '0', "1111", '0', '0', '0'), -- add with no flags
    ("1111", "1111", "0010", '0', "1110", '1', '0', '0'), -- add with carry flag
    ("1000", "1000", "0010", '0', "0000", '1', '1', '1'), -- add with all flags
    ("0010", "0001", "0110", '1', "0001", '0', '0', '0'), -- sub with no flags
    ("0001", "0010", "0110", '1', "1111", '1', '0', '0'), -- sub with carry flag
    ("1111", "1111", "0110", '1', "0000", '0', '1', '0'), -- sub with zero flag
    ("0001", "0010", "0111", '1', "0001", '-', '0', '-'), -- set less than
    ("0010", "0001", "0111", '1', "0000", '-', '1', '-') -- set less than
    );
  
BEGIN

    UUT : ENTITY work.alu
        PORT MAP(
            data_1 => data_1,
            data_2 => data_2,
            operation => operation,
            cin => cin,
            data_out => data_out,
            cflag => cflag,
            zflag => zflag,
            oflag => oflag
        );

    main : PROCESS
    BEGIN

        test_runner_setup(runner, runner_cfg);

        FOR i IN test_cases'RANGE LOOP

            data_1 <= test_cases(i).data_1;
            data_2 <= test_cases(i).data_2;
            operation <= test_cases(i).operation;
            cin <= test_cases(i).cin;

            WAIT FOR time_span;

            ASSERT (data_out = test_cases(i).data_out OR test_cases(i).data_out = "----")
            REPORT "test " & INTEGER'image(i) & " failed [BAD DATAOUT]" SEVERITY error;

            ASSERT (cflag = test_cases(i).cflag OR test_cases(i).cflag = '-')
            REPORT "test " & INTEGER'image(i) & " failed [BAD CFLAG]" SEVERITY error;

            ASSERT (zflag = test_cases(i).zflag OR test_cases(i).zflag = '-')
            REPORT "test " & INTEGER'image(i) & " failed [BAD ZFLAG]" SEVERITY error;

            ASSERT (oflag = test_cases(i).oflag OR test_cases(i).oflag = '-')
            REPORT "test " & INTEGER'image(i) & " failed [BAD OFLAG]" SEVERITY error;

        END LOOP;

        WAIT FOR time_span;
        test_runner_cleanup(runner);
        WAIT;

    END PROCESS;

END tb;

