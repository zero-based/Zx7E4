LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE operation IS

  CONSTANT OP_SIZE : NATURAL := 4;
  SUBTYPE operation_t IS std_logic_vector (OP_SIZE - 1 DOWNTO 0);

  CONSTANT AND_OP  : operation_t := "0000";
  CONSTANT OR_OP   : operation_t := "0001";
  CONSTANT ADD_OP  : operation_t := "0010";
  CONSTANT NADD_OP : operation_t := "1010";
  CONSTANT SUB_OP  : operation_t := "0110";
  CONSTANT NSUB_OP : operation_t := "1110";
  CONSTANT SLT_OP  : operation_t := "0111";
  CONSTANT NOR_OP  : operation_t := "1100";

END PACKAGE;