library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--Provided entity declaration
entity REG_DATAPATH is
	Port ( 
		CLK, RESET_L : in  std_logic;
		SEL1, SEL2   : in std_logic_vector(1 downto 0);
		LDA, LDB : in std_logic;
		CIN: in std_logic;
		BUS_IN  : in  std_logic_vector(3 downto 0);
		OP: std_logic_vector(2 downto 0);
		COUT : out  std_logic;
		BUS_OUT : buffer std_logic_vector(3 downto 0)
	);
end REG_DATAPATH;
 
architecture arch of REG_DATAPATH is

	component ALU
		-- Declare your ALU component here
		port( A, B : in std_logic_vector(3 downto 0);
				OP   : in std_logic_vector(2 downto 0);
				Cin  : in std_logic;
				F    : out std_logic_vector(3 downto 0);
				Cout : out std_logic);
	end component;

	-- Declare any necessary signals here
	-- Remember, any wires that start AND end within the circuit (internal wires) must have a signal.
	-- MUX1, REGA, and BUS_IN Signals (all 0000)
	signal MUX1_TO_REGA, REGA_TO_ALU : std_logic_vector(3 downto 0) := (others => '0');
	-- MUX2, REGB signals (all 0000)
	signal MUX2_TO_REGB, REGB_TO_ALU : std_logic_vector(3 downto 0) := (others => '0');
	-- All signals that are interactions between REGA, REGB, MUX1, MUX2 (0000)
	signal REGA_TO_MUX1, REGA_TO_MUX2 : std_logic_vector(3 downto 0) := (others => '0');
	signal REGB_TO_MUX1, REGB_TO_MUX2 : std_logic_vector(3 downto 0) := (others => '0');
	-- output bus signal (0000)
	--signal BUS_OUT_signal : std_logic_vector(3 downto 0) := (others => '0');
begin
	-- Instantiate your ALU component and create the portmap for it.
	
	-- Process for determining the value of REGA on the clock edge
	REGA: process( CLK, RESET_L, MUX1_TO_REGA, REGA_TO_ALU, LDA)
	begin
		if (RESET_L = '1') then -- Check for reset
			REGA_TO_ALU <= "0000";
		elsif (rising_edge(CLK) and LDA = '1') then -- Check for rising edge
			-- This case statement here represents MUX1
        		case SEL1 is
		    		when "00" => 
		     			MUX1_TO_REGA <= REGA_TO_ALU;
				when "01" => 
					MUX1_TO_REGA <= BUS_IN;
				when "10" =>
					MUX1_TO_REGA <= BUS_OUT;
				when "11" =>
					MUX1_TO_REGA <= REGB_TO_ALU;
				when others => NULL; -- A NULL statement is a no-op.
			end case;
		end if;
		REGA_TO_ALU <= MUX1_TO_REGA;
	end process;
	
	--BUS_OUT <= BUS_OUT_SIGNAL;

	-- Next make your own process for REGB
	REGB: process( CLK, RESET_L, REGB_TO_ALU, MUX2_TO_REGB, LDB)
	begin
		if (RESET_L = '1') then -- Check for reset
			REGB_TO_ALU <= "0000";
		elsif (rising_edge(CLK) and LDB = '1') then -- Check for rising edge
			-- This case statement here represents MUX2
			case SEL2 is
				when "00" => 
		     		MUX2_TO_REGB <= REGA_TO_ALU;
				when "01" => 
					MUX2_TO_REGB <= BUS_IN;
				when "10" =>
					--BUS_OUT_signal <= BUS_OUT;
					MUX2_TO_REGB <= BUS_OUT;
				when "11" =>
					MUX2_TO_REGB <= REGB_TO_ALU;
				when others => NULL; -- A NULL statement is a no-op.
			end case;
			
		end if;
		REGB_TO_ALU <= MUX2_TO_REGB;
	end process;
	

	ALU0: ALU
		PORT MAP (A => REGA_TO_ALU, B=> REGB_TO_ALU, OP => OP, CIN => Cin, COUT => Cout, F => BUS_OUT);
end;
