LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
  
ENTITY TB_REG_ALU IS
END TB_REG_ALU;
  
ARCHITECTURE behavior OF TB_REG_ALU IS
  
 -- Component Declaration for the Unit Under Test (UUT)
  
COMPONENT ALU
 Port ( 
 A, B : in  std_logic_vector(3 downto 0);
 OP   : in std_logic_vector(2 downto 0);
 Cin  : in std_logic;
 Cout : out std_logic;
 F    : out std_logic_vector(3 downto 0));
 END COMPONENT;
  
 
 --Inputs
 signal A : std_logic_vector(3 downto 0) := (others => '0');
 signal B : std_logic_vector(3 downto 0) := (others => '0');
 signal OP: std_logic_vector(2 downto 0) := (others => '0');
 signal CIN : std_logic := '0';
 signal COUT : std_logic := '0';
 signal F : std_logic_vector(3 downto 0) := (others => '0');

  
BEGIN
 
 -- Instantiate your design under test here
 
 TEST_R_ALU: ALU PORT MAP(A => A, B => B, OP => OP, Cin => Cin, Cout => Cout, F => F);
  
 -- Stimulus Generation process
 Stimuli_Gen: process
 begin
 
 wait for 50 ns;
 
 A <= "1001";
 B <= "0001";
 
 CIN <= '0';
 OP <= "000";
 
 wait for 50 ns;
 
 A <= "1001";
 B <= "0001";

 CIN <= '0';
 OP <= "001";
 
 wait for 50 ns;
 
 A <= "1001";
 B <= "0001";
 
 CIN <= '0';
 OP <= "010";
 
 wait for 50 ns;
 
 A <= "0001";
 B <= "0001";
 
 CIN <= '0';
 OP <= "011";
 
 wait for 50 ns;
 
 A <= "1001";
 B <= "0001";

 CIN <= '0';
 OP <= "100";
 
 wait for 50 ns;
 
 A <= "1001";
 B <= "0001";

 CIN <= '0';
 OP <= "101";
 
 wait for 50 ns;
 
 A <= "1001";
 B <= "0001";

 CIN <= '0';
 OP <= "110";
 
 wait for 50 ns;
 
 A <= "1001";
 B <= "0001";

 CIN <= '0';
 OP <= "111";
 
 wait for 50 ns;

 end process;
 
END;