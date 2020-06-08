----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2019 01:23:35 PM
-- Design Name: 
-- Module Name: MEM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


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

entity MEM is
Port (
    CLK: IN STD_LOGIC;
    ADR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    DIN: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    DOUT: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    MEMWRITE: IN STD_LOGIC);
end MEM;

architecture Behavioral of MEM is
TYPE RAM1 IS ARRAY (0 TO 255) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL RAM:RAM1:=(OTHERS => X"0000");

begin
PROCESS (CLK)
BEGIN
IF (RISING_EDGE(CLK)) THEN     
    IF (MEMWRITE='1') THEN 
        RAM(CONV_INTEGER(ADR))<=DIN;
     ELSIF (MEMWRITE='0') THEN
        DOUT<=RAM(CONV_INTEGER(ADR));
     END IF;
END IF;
END PROCESS;

end Behavioral;
