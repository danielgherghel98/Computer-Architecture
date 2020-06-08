library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
Port (
digit: in std_logic_vector(15 downto 0);
clk: in std_logic;
-- rst: in std_logic;
an: out std_logic_vector(3 downto 0);
cat : out std_logic_vector(0 to 6)
);
end SSD;

architecture Behavioral of SSD is
signal out_mux1: std_logic_vector(3 downto 0);
Signal out_dec:std_logic_vector(6 downto 0);
signal out_counter: std_logic_vector(15 downto 0);

begin
process(clk)
begin
if rising_edge(clk) then
       out_counter<=out_counter+1;
end if;
end process;

process(clk)
begin 

case out_counter(15 downto 14) is
when "00" => an <= "1110";
when "01" => an <= "1101";
when "11" => an <= "1011";
when "10" => an <= "0111";
end case;
end process;

process(clk)
begin 
case out_counter(15 downto 14) is
when "00" => out_mux1 <= digit(3 downto 0);
when "01" => out_mux1 <= digit(7 downto 4);
when "11" => out_mux1 <= digit(11 downto 8);
when "10" => out_mux1 <= digit(15 downto 12);
end case;
end process;



process(out_mux1)
begin 
case out_mux1 is
when "0000" => cat<=  "0000001"; -- "0"    
when "0001" => cat<=  "1001111"; -- "1" 
when "0010" => cat<=  "0010010"; -- "2"
when "0011" => cat<=  "0000110"; -- "3"
when "0100" => cat<=  "1001100"; -- "4" 
when "0101" => cat<=  "0100100"; -- "5" 
when "0110" => cat<=  "0100000"; -- "6" 
when "0111" => cat<=  "0001111"; -- "7"
when "1000" => cat<=  "0000000"; -- "8"  
when "1001" => cat<=  "0000100"; -- "9"
when "1010" => cat<=  "0000010"; -- a
when "1011" => cat <= "1100000"; -- b
when "1100" => cat <= "0110001"; -- C
when "1101" => cat <= "1000010"; -- d
when "1110" => cat <= "0110000"; -- E
when "1111" => cat <= "0111000"; -- F
when others => cat <= "1111111";
end case;
end process;
end Behavioral;




