----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 12:40:26 PM
-- Design Name: 
-- Module Name: IFE - Behavioral
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

entity IFE is
 Port (
    CLK: IN STD_LOGIC;
    RST: IN STD_LOGIC;
    EN: IN STD_LOGIC;
    BR_SELECT: IN STD_LOGIC;
    J_SELECT: IN STD_LOGIC;
    J_ADR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    BR_ADR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    PC: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    --PC1: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    INSTR: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
end IFE;

architecture Behavioral of IFE is
    SIGNAL PC_OUT: STD_LOGIC_VECTOR(15 DOWNTO 0); 
    SIGNAL PC_IN: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ROM_OUT: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MUX1: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ADR: STD_LOGIC_VECTOR(15 DOWNTO 0);
    type Rom is array(0 to 255) of std_logic_vector(15 downto 0);
    signal MYROM : Rom:=(
    B"000_000_000_001_0_000",--0010
    B"001_000_100_0001010",--220A
    B"000_000_000_010_0_000",--0020
    B"000_000_000_101_0_000",--0050
    B"100_001_100_0000111",--8607
    B"010_010_011_0101000",--49A8
    B"001_011_011_1111110",--2DFE
    B"011_010_011_0101000",--69A8
    B"000_101_011_101_0_000",--15D0
    B"001_010_010_0000100",--2904
    B"001_001_001_0000001",--2481
    B"111_0000000000100",--E004
    B"011_000_101_1010000",--62D0
    others=>"0000000000000000"
    );
begin
process (clk)
begin
if rising_edge(clk) then
    if RST='1' then
       PC_OUT<=(OTHERS=>'0');
    ELSIF  RST='0' THEN
        IF EN='1' THEN
            PC_OUT<=PC_IN;
        end if;
    end if;
end if;
end process;

PROCESS(J_SELECT)
BEGIN 
    IF (J_SELECT='1') THEN 
        PC_IN<=J_ADR;
    ELSE 
        PC_IN<=MUX1;
    END IF;
END PROCESS;

PROCESS(BR_SELECT)
BEGIN 
    IF (BR_SELECT='1') THEN 
        MUX1<=BR_ADR;
    ELSE 
        MUX1<=PC_OUT+1;
    END IF;
END PROCESS;

INSTR<=MYROM(CONV_INTEGER(PC_OUT(7 DOWNTO 0)));
PC<=PC_OUT+1;
end Behavioral;
