----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2019 12:02:43 PM
-- Design Name: 
-- Module Name: UID - Behavioral
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

entity UID is
Port (
    CLK: IN STD_LOGIC;
    REGWRITE: IN STD_LOGIC;
    INSTR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    REGDST: IN STD_LOGIC;
    WD: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    RD1: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    RD2: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    EXT_IMM: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    FUNC: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    SA: OUT STD_LOGIC;
    EXTOP: IN STD_LOGIC);
end UID;

architecture Behavioral of UID is
SIGNAL ADR1,ADR2:STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL WA:STD_LOGIC_VECTOR(2 DOWNTO 0);

COMPONENT reg_file is
port (
clk : in std_logic;
ra1 : in std_logic_vector (2 downto 0);
ra2 : in std_logic_vector (2 downto 0);
wa : in std_logic_vector (2 downto 0);
wd : in std_logic_vector (15 downto 0);
wen : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0)
);
end COMPONENT;
begin
ADR1<=INSTR(12 DOWNTO 10);
ADR2<=INSTR(9 DOWNTO 7);
C1:REG_FILE PORT MAP(CLK,ADR1,ADR2,WA,WD,REGWRITE,RD1,RD2);
PROCESS(INSTR,WA,REGDST)
BEGIN
    IF(REGDST='1') THEN
        WA<=ADR2;
        ELSE 
            WA<=INSTR(9 DOWNTO 7);
            END IF;
END PROCESS;

PROCESS(EXTOP)
BEGIN
    IF(EXTOP='0') THEN 
        EXT_IMM<=INSTR(6 DOWNTO 0)&"000000000";
        ELSE 
            IF(INSTR(6)='0') THEN
               EXT_IMM<=INSTR(6 DOWNTO 0)&"000000000";
               ELSE 
                    EXT_IMM<=INSTR(6 DOWNTO 0)&"111111111";
                    END IF;
       END IF;
END PROCESS;
SA<=INSTR(3);
FUNC<=INSTR(2 DOWNTO 0);
end Behavioral;


