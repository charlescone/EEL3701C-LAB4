library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Entity Declaration for the ALU
ENTITY ALU IS
PORT( A, B : in std_logic_vector(3 downto 0);
		OP   : in std_logic_vector(2 downto 0);
		Cin  : in std_logic;
		F    : out std_logic_vector(3 downto 0);
		Cout : out std_logic);
END ALU;

ARCHITECTURE behavioral OF ALU IS
	-- temp output of the alu used mainly for the carry with addition.
	SIGNAL temp: std_logic_vector(4 downto 0);
	BEGIN
	
	PROCESS (OP, A, B, Cin)
	BEGIN
		
		if (OP = "000") then -- Two's Complement
			if (A(3) = '1') then --Check sign bit.
				temp(3 downto 0) <= not A + "0001"; -- Conversion
			else
				-- If sign bit is zero no conversion is needed.
				temp(3 downto 0) <= A;
			end if;
		elsif (OP = "001") then --Logical AND
			temp(3 downto 0) <= A and B;
		elsif (OP = "010") then --Logical OR
			temp(3 downto 0) <= A or B;
		elsif (OP = "011") then --Binary Addition
			temp <= ('0' & A) + ('0' & B) + ("0000" & Cin);
			-- sending the MSB to the carry out and all other bits to F (main output)
			
		elsif (OP = "100") then --Output A
			temp(3 downto 0) <= A;
		elsif (OP = "101") then --Output B
			temp(3 downto 0) <= B;
		elsif (OP = "110") then --Shift Left Logical
			temp(3 downto 0) <= A(2 downto 0) & '0';
		elsif (OP = "111") then -- Shift Right Logical
			temp(3 downto 0) <= '0' & A(3 downto 1);
		end if;
		
		
	END PROCESS;
	F <= temp(3 downto 0);
	COUT <= temp(4);
END behavioral;