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

entity debounce is
Port (
btn: in std_logic;
clk: in std_logic;
en: out std_logic
);
end debounce;

architecture Behavioral of debounce is
signal q1: std_logic;
signal q2: std_logic;
signal q3: std_logic;
signal count_int: std_logic_vector(15 downto 0);

begin

en<=q2 and (not q3);

process (clk)
begin
if clk'event and clk='1' then
count_int <= count_int + 1;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
if count_int(15 downto 0) = "1111111111111111" then
q1<=btn;
end if;
end if;
end process;

process(clk)
begin
if rising_edge(clk) then
q2<=q1;
q3<=q2;
end if;
end process;



end Behavioral;