LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu_1 IS
    PORT (
        a : IN std_logic;
        b : IN std_logic;
        cin : IN std_logic;
        less : IN std_logic;
        operation : IN std_logic_vector (3 DOWNTO 0);
        cout : OUT std_logic;
        res : OUT std_logic;
        set : OUT std_logic
    );
END alu_1;

ARCHITECTURE behaviour OF alu_1 IS

    SIGNAL mux_a_res : std_logic;
    SIGNAL mux_b_res : std_logic;
    SIGNAL not_a_res : std_logic;
    SIGNAL not_b_res : std_logic;
    SIGNAL and_res : std_logic;
    SIGNAL or_res : std_logic;
    SIGNAL add_res : std_logic;

BEGIN

    not_a : ENTITY work.not_gate
        PORT MAP(
            a => a,
            not_a => not_a_res
        );

    not_b : ENTITY work.not_gate
        PORT MAP(
            a => b,
            not_a => not_b_res
        );

    mux_a : ENTITY work.mux
        GENERIC MAP(SEL_COUNT => 1)
        PORT MAP(
            input(0)(0) => a,
            input(1)(0) => not_a_res,
            selector(0) => operation(3),
            output(0) => mux_a_res
        );

    mux_b : ENTITY work.mux
        GENERIC MAP(SEL_COUNT => 1)
        PORT MAP(
            input(0)(0) => b,
            input(1)(0) => not_b_res,
            selector(0) => operation(2),
            output(0) => mux_b_res
        );

    a_and_b : ENTITY work.and_gate
        PORT MAP(
            a => mux_a_res,
            b => mux_b_res,
            res => and_res
        );

    a_or_b : ENTITY work.or_gate
        PORT MAP(
            a => mux_a_res,
            b => mux_b_res,
            res => or_res
        );

    a_add_b : ENTITY work.full_adder
        PORT MAP(
            a => mux_a_res,
            b => mux_b_res,
            cin => cin,
            s => add_res,
            cout => cout
        );

    mux_4 : ENTITY work.mux
        PORT MAP(
            input(0)(0) => and_res,
            input(1)(0) => or_res,
            input(2)(0) => add_res,
            input(3)(0) => less,
            selector => operation (1 DOWNTO 0),
            output(0) => res
        );

    set <= add_res;

END behaviour;