----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2019 12:59:18 PM
-- Design Name: 
-- Module Name: UC - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UC is
 Port (
        OPCODE: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        REGDEST:OUT STD_LOGIC:='0';
        REGW:OUT STD_LOGIC:='0';
        EXTOP:OUT STD_LOGIC:='0';
        ALUSRC:OUT STD_LOGIC:='0';
        ALUCTRL:OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        B:OUT STD_LOGIC:='0';
        J:OUT STD_LOGIC:='0';
        MEMW:OUT STD_LOGIC:='0';
        MEMR:OUT STD_LOGIC:='0' );
end UC;

architecture Behavioral of UC is
BEGIN
PROCESS (OPCODE)
BEGIN
    CASE OPCODE IS
    WHEN "000"=>REGDEST<='1';
                REGW<='1';
    WHEN "001"=>REGW<='1';
                ALUSRC<='1';
                EXTOP<='1';
    WHEN "010"=>REGW<='1';
                ALUSRC<='1';
                EXTOP<='1'; 
                MEMR<='1';
    WHEN "011"=>ALUSRC<='1';
                EXTOP<='1';          
                MEMW<='1';
    WHEN "100"=>EXTOP<='1';
                B<='1';
    WHEN OTHERS=>J<='1';
    END CASE;
END PROCESS;                                    



end Behavioral;
