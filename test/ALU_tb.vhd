LIBRARY ieee;
LIBRARY vunit_lib;

USE ieee.std_logic_1164.ALL;
CONTEXT vunit_lib.vunit_context;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

ENTITY ALUTest IS
	GENERIC (runner_cfg : STRING);
END ALUTest;

ARCHITECTURE behavior OF ALUTest IS

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT ALU
		PORT (
			data1 : IN std_logic_vector(31 DOWNTO 0);
			data2 : IN std_logic_vector(31 DOWNTO 0);
			aluop : IN std_logic_vector(3 DOWNTO 0);
			cin : IN std_logic;
			dataout : OUT std_logic_vector(31 DOWNTO 0);
			cflag : OUT std_logic;
			zflag : OUT std_logic;
			oflag : OUT std_logic
		);
	END COMPONENT;
	--Inputs
	SIGNAL data1 : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL data2 : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL aluop : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL cin : std_logic := '0';

	--Outputs
	SIGNAL dataout : std_logic_vector(31 DOWNTO 0);
	SIGNAL cflag : std_logic;
	SIGNAL zflag : std_logic;
	SIGNAL oflag : std_logic;
	-- No clocks detected in port list. Replace <clock> below with 
	-- appropriate port name 
BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : ALU PORT MAP(
		data1 => data1,
		data2 => data2,
		aluop => aluop,
		cin => cin,
		dataout => dataout,
		cflag => cflag,
		zflag => zflag,
		oflag => oflag
	);
	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		test_runner_setup(runner, runner_cfg);
		-- hold reset state for 100 ns.
		WAIT FOR 10 ns;
		--AND testcase
		data1 <= "11000000000000000000000000000000";
		data2 <= "10100000000000000000000000000000";
		aluop <= "0000";
		WAIT FOR 10 ns;
		REPORT "Test1";
		ASSERT(dataout = "10000000000000000000000000000000" AND zflag = '0') REPORT "1:Fail" SEVERITY error;

		WAIT FOR 1 ns;

		--OR testcase
		data1 <= "11000000000000000000000000000000";
		data2 <= "10100000000000000000000000000000";
		aluop <= "0001";
		WAIT FOR 10 ns;
		REPORT "Test2";
		ASSERT(dataout = "11100000000000000000000000000000" AND zflag = '0') REPORT "2:Fail" SEVERITY error;

		WAIT FOR 1 ns;

		--ADD testcase1 (overflow = 1, cout = 0)
		data1 <= "01110000000000000000000000000000";
		data2 <= "01100000000000000000000000000000";
		aluop <= "0010";
		WAIT FOR 10 ns;
		REPORT "Test3";
		ASSERT(dataout = "11010000000000000000000000000000" AND oflag = '1' AND cflag = '0' AND zflag = '0') REPORT "3:Fail" SEVERITY error;

		WAIT FOR 1 ns;

		--ADD testcase2 (zero = 1, cout = 1)
		data1 <= "11110000000000000000000000000000";
		data2 <= "00010000000000000000000000000000";
		aluop <= "0010";
		WAIT FOR 10 ns;
		REPORT "Test4";
		ASSERT(dataout = "00000000000000000000000000000000" AND oflag = '0' AND cflag = '1' AND zflag = '1') REPORT "4:Fail" SEVERITY error;

		WAIT FOR 1 ns;

		--SUB testcase1 (cout = 1)
		data1 <= "00000000000000000000000000000111"; --a = 7
		data2 <= "00000000000000000000000000000110"; --b = 6
		cin <= '1';
		aluop <= "0110";
		WAIT FOR 10 ns;
		REPORT "Test5";
		ASSERT(dataout = "00000000000000000000000000000001" AND oflag = '0' AND cflag = '1' AND zflag = '0') REPORT "5:Fail" SEVERITY error;

		WAIT FOR 1 ns;

		--SUB testcase2 (cout = 0)
		data1 <= "00000000000000000000000000000110"; --a = 6
		data2 <= "00000000000000000000000000000111"; --b = 7
		cin <= '1';
		aluop <= "0110";
		WAIT FOR 10 ns;
		REPORT "Test6";
		ASSERT(dataout = "11111111111111111111111111111111" AND oflag = '0' AND cflag = '0' AND zflag = '0') REPORT "6:Fail" SEVERITY error;

		WAIT FOR 1 ns;

		--SUB testcase3 (overflow = 1)
		data1 <= "11111111111111111111111111111000"; --a = -8
		data2 <= "00000000000000000000000000000001"; --b = 1
		cin <= '1';
		aluop <= "0110";
		WAIT FOR 10 ns;
		REPORT "Test7";
		ASSERT(dataout = "11111111111111111111111111110111" AND oflag = '0' AND cflag = '1' AND zflag = '0') REPORT "7:Fail" SEVERITY error;

		WAIT FOR 1 ns;

		REPORT "Test Complete";
		test_runner_cleanup(runner);

		WAIT;
	END PROCESS;

END;