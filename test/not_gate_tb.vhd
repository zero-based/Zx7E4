LIBRARY ieee;
LIBRARY vunit_lib;
USE ieee.std_logic_1164.ALL;
CONTEXT vunit_lib.vunit_context;

ENTITY not_gate_tb IS
	GENERIC (runner_cfg : STRING);
END not_gate_tb;

ARCHITECTURE tb OF not_gate_tb IS

	SIGNAL a : std_logic;
	SIGNAL not_a : std_logic;

	TYPE test_case IS RECORD
		a : std_logic;
		not_a : std_logic;
	END RECORD;

	TYPE test_case_array IS ARRAY (NATURAL RANGE <>) OF test_case;

	CONSTANT time_span : TIME := 20 ns;
	CONSTANT test_cases : test_case_array := (
	('0', '1'),
	('1', '0')
	);

BEGIN

	UUT : ENTITY work.not_gate PORT MAP (a => a, not_a => not_a);

	main : PROCESS
	BEGIN

		test_runner_setup(runner, runner_cfg);

		FOR i IN test_cases'RANGE LOOP

			a <= test_cases(i).a;

			WAIT FOR time_span;
			ASSERT (not_a = test_cases(i).not_a)
			REPORT "test " & INTEGER'image(i) & " failed " SEVERITY error;

		END LOOP;

		WAIT FOR time_span;
		test_runner_cleanup(runner);
		WAIT;

	END PROCESS;

END tb;