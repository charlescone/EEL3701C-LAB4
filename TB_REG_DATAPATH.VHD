LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
  
ENTITY TB_REG_DATAPATH IS
END TB_REG_DATAPATH;
  
ARCHITECTURE structural OF TB_REG_DATAPATH IS
  
 -- Component Declaration for the Unit Under Test (UUT)
  
component REG_DATAPATH is
	Port ( 
		CLK, RESET_L : in  std_logic;
		SEL1, SEL2   : in std_logic_vector(1 downto 0);
		LDA, LDB : in std_logic;
		CIN: in std_logic;
		BUS_IN  : in  std_logic_vector(3 downto 0);
		OP: in std_logic_vector(2 downto 0);
		COUT : out  std_logic;
		BUS_OUT : buffer std_logic_vector(3 downto 0)
	);
end component;
  
 
 signal CLK    : std_logic:= '0';
 signal RESET_L  : std_logic:= '0';
 signal SEL1, SEL2	: std_logic_vector(1 downto 0):= (others => '0');
 signal LDA, LDB : std_logic := '0';
 signal CIN, COUT	   : std_logic:= '0';
 signal OP : std_logic_vector(2 downto 0) := (others => '0');
 signal BUS_IN, BUS_OUT: std_logic_vector(3 downto 0):= (others => '0');
 
BEGIN
  
-- Instantiate your datapath component here
 
TEST_DATAPATH: REG_DATAPATH PORT MAP(CLK => CLK, 
									    RESET_L => RESET_L,
										 BUS_IN  => BUS_IN,
										 CIN => CIN,
										 SEL1 =>	SEL1,
										 SEL2	=> SEL2,
										 LDA	=> LDA, 
										 LDB	=> LDB,
										 OP  => OP,
										 COUT => COUT,
										 BUS_OUT => BUS_OUT   
									 ); 
  
  
 PROCESS    -- clock process for clk
        BEGIN
            CLOCK_LOOP : LOOP
                clk <= '0';
                WAIT FOR 20 ns;
                clk <= '1';
                WAIT FOR 20 ns;
            END LOOP CLOCK_LOOP;
        END PROCESS;
  
 -- Stimulus Generation process
 
 Stimuli_Gen: process
 begin
 
 wait for 10 ns;
 RESET_L <= '1';
 wait for 10 ns;
 RESET_L <= '0';
 
 wait for 40 ns;
 --- load first number (A)
 BUS_IN <= "1001";
 SEL1 <= "01"; -- value from the inbus
 LDA <= '1';
 LDB <= '0';
 CIN <= '0';
 OP <= "100";
 wait for 40 ns;
 
 --- load second number(B)
 BUS_IN <= "0001";
 -- prevent any writing in reg a or reg b
 SEL2 <= "01";
 LDA <= '0';
 LDB <= '1';
 
 --- Do some operations by feeding the ALU
 CIN <= '0';
 OP <= "101";
 wait for 40 ns;
 
 BUS_IN <= "1001";
 SEL1 <= "01";
 SEL2 <= "10";
 
 LDA <= '1';
 LDB <= '1';
 
 CIN <= '0';
 OP <= "001";
 
 wait for 40 ns;
 
 BUS_IN <= "0010";
 SEL2 <= "01";
 LDA <= '0';
 LDB <= '1';
 
 CIN <= '0';
 OP <= "011";

 wait for 40 ns;
 
 SEL1 <= "10";
 LDA <= '1';
 
 CIN <= '0';
 OP <= "000";

 wait for 40 ns;

 end process;
 
END;