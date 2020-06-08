----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2019 12:32:49 PM
-- Design Name: 
-- Module Name: Execute - Behavioral
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

entity Execute is
Port ( RD1: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    RD2: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    EXT_IMM: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    FUNC: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    SA: IN STD_LOGIC;
    ALUSRC: IN STD_LOGIC;
    ALUOP: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    ZERO: OUT STD_LOGIC;
    RES: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0));
end Execute;

architecture Behavioral of Execute is
SIGNAL MUX: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ALUCTRL: STD_LOGIC_VECTOR(2 DOWNTO 0);
begin
PROCESS(RD2,EXT_IMM,MUX)
BEGIN
    IF(ALUSRC='0') THEN
        MUX<=RD2;
    ELSE 
        MUX<=EXT_IMM;
    END IF;
END PROCESS;
PROCESS(ALUOP,FUNC,ALUCTRL)
BEGIN 
CASE ALUOP IS
    WHEN "000" => CASE FUNC IS
                        WHEN "000" => ALUCTRL<="000";  --ADD
                        WHEN "001" => ALUCTRL<="001";  --SUB 
                        WHEN "010" => ALUCTRL<="010";  --SLL
                        WHEN "011" => ALUCTRL<="011";  --SLR
                        WHEN "100" => ALUCTRL<="100";  --AND
                        WHEN "101" => ALUCTRL<="101";  --OR
                        WHEN "110" => ALUCTRL<="110";  --XOR
                        WHEN OTHERS => ALUCTRL<="111";  --NOR
                        END CASE;
     WHEN "001" => ALUCTRL<="000";  --ADDI
     WHEN "010" => ALUCTRL<="001";  --LW
     WHEN "011" => ALUCTRL<="010";  --SW
     WHEN "100" => ALUCTRL<="011";  --BEQ
     WHEN "101" => ALUCTRL<="100";  --ANDI
     WHEN "110" => ALUCTRL<="101";  --ORI
     WHEN "111" => ALUCTRL<="110";  --J
     
     END CASE;
END PROCESS;

PROCESS(ALUCTRL,MUX,RD1,SA)
BEGIN
    CASE ALUCTRL IS
        WHEN "000" => RES<=MUX+RD1;
        WHEN "001" => RES<=RD1-MUX;
        WHEN "010" => RES<=RD1(14 DOWNTO 0)&SA;
        WHEN "011" => RES<=SA&RD1(15 DOWNTO 1);
        WHEN "100" => RES<=MUX AND RD1;
        WHEN "101" => RES<=MUX OR RD1;
        WHEN "110" => RES<=MUX XOR RD1;
        WHEN "111" => RES<=MUX NOR RD1;
        END CASE;
END PROCESS;
PROCESS(RES)
BEGIN
    IF (RES=x"0000") THEN ZERO<='1';
    ELSE ZERO<='0';
    END IF;
END PROCESS;

end Behavioral;
