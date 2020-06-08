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

entity test_env is
Port ( clk : in STD_LOGIC;
btn : in STD_LOGIC_VECTOR (4 downto 0);
sw : in STD_LOGIC_VECTOR (15 downto 0);
led : out STD_LOGIC_VECTOR (15 downto 0);
an : out STD_LOGIC_VECTOR (3 downto 0);
cat : out STD_LOGIC_VECTOR (0 to 6));
end test_env;

architecture Behavioral of test_env is

signal sig: STD_LOGIC_VECTOR(7 downto 0):="00000000";
--signal Q1:STD_LOGIC;
--signal Q2:STD_LOGIC;
--signal Q3:STD_LOGIC;
signal en:STD_LOGIC;

--signal x: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";
--signal y: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";
--signal z: STD_LOGIC_VECTOR(15 downto 0) :="0000000000000000";

signal final: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

type memRom is array(0 to 255) of std_logic_vector(15 downto 0);
signal WD: std_logic_vector(15 downto 0);
signal INSTR1: std_logic_vector(15 downto 0);
signal PC1: std_logic_vector(15 downto 0);
signal RD1: std_logic_vector(15 downto 0);
signal RD2: std_logic_vector(15 downto 0);
signal RA1: std_logic_vector(3 downto 0):="0000";
signal RA2: std_logic_vector(3 downto 0):="0000";
signal WA: std_logic_vector(3 downto 0):="0000";
signal iesireRom: std_logic_vector(15 downto 0);
signal en1: std_logic;
signal en2: std_logic;
SIGNAL OPCODE: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL  REGDEST: STD_LOGIC:='0';
SIGNAL  REGW: STD_LOGIC:='0';
SIGNAL  EXTOP:STD_LOGIC:='0';
SIGNAL  ALUSRC: STD_LOGIC:='0';
SIGNAL  ALUCTRL: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL  B: STD_LOGIC:='0';
SIGNAL  J: STD_LOGIC:='0';
SIGNAL  MEMW: STD_LOGIC:='0';
SIGNAL  MEMR: STD_LOGIC:='0';
SIGNAL  SA: STD_LOGIC;
signal  EXTIMM: std_logic_vector(15 downto 0);
signal  FUNC: std_logic_vector(2 downto 0); 
signal regWrite:  std_logic:='0';
SIGNAL DOUT:STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ZERO: STD_LOGIC;
SIGNAL RES: STD_LOGIC_VECTOR(15 DOWNTO 0);

signal myRom : memRom:=(
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


component debounce
Port (
btn: in std_logic;
clk: in std_logic;
en: out std_logic
);
end component;

component SSD
Port (
digit: in std_logic_vector(15 downto 0);
clk: in std_logic;
-- rst: in std_logic;
an: out std_logic_vector(3 downto 0);
cat : out std_logic_vector(0 to 6)
);
end component;



COMPONENT UID is
Port (
    CLK: IN STD_LOGIC;
    REGWRITE: IN STD_LOGIC;
    INSTR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    REGDST: IN STD_LOGIC;
    WD: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    RD1: OUT STD_LOGIC_VECTOR(15DOWNTO 0);
    RD2: OUT STD_LOGIC_VECTOR(15DOWNTO 0);
    EXT_IMM: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    FUNC: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    SA: OUT STD_LOGIC;
    EXTOP: IN STD_LOGIC);
end COMPONENT;

COMPONENT IFE is
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
end COMPONENT;
COMPONENT MEM is
Port (
    CLK: IN STD_LOGIC;
    ADR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    DIN: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    DOUT: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    MEMWRITE: IN STD_LOGIC);
end COMPONENT;
COMPONENT Execute is
Port ( RD1: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    RD2: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    EXT_IMM: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    FUNC: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    SA: IN STD_LOGIC;
    ALUSRC: IN STD_LOGIC;
    ALUOP: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    ZERO: OUT STD_LOGIC;
    RES: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0));
end COMPONENT;
begin
REGWRITE<=en1 and REGW;
--WD<= RD1+RD2;
C1: debounce port map(btn(4),clk,en);
C11: debounce port map(btn(0),clk,en1);
C12: debounce port map(btn(1),clk,en2);

A1: UID PORT MAP (CLK,REGWRITE,INSTR1,REGDEST,WD,RD1,RD2,EXTIMM,FUNC,SA,EXTOP);
A2: IFE PORT MAP (CLK=>CLK,RST=>EN2,EN=> EN1,BR_SELECT=>B,J_SELECT=>J,BR_ADR=>"0000000000000110",J_ADR=>"0000000000000010",INSTR=>INSTR1,PC=>PC1);
A3: SSD port map(final, clk, an, cat);
A4: MEM PORT MAP(CLK,RES,RD2,DOUT,MEMW);
A5: EXECUTE PORT MAP(RD1,RD2,EXTIMM,FUNC,SA,ALUSRC,OPCODE,ZERO,RES);

OPCODE<=INSTR1(15 DOWNTO 13);
--led(15 DOWNTO 4) <= "111111111111";
--led(3 DOWNTO 1)<=func;
--led(0)<=sa;
--an<=btn(3 downto 0);
--cat<=(others=>'0');
PROCESS (MEMR)
BEGIN
    IF MEMR='1' THEN WD<=DOUT;
        ELSE WD<=RES;
    END IF;
END PROCESS;
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

--PROCESS(SW(7 DOWNTO 5),INSTR1,PC1,RD1,RD2,WD)
--BEGIN
--   IF SW(7 DOWNTO 5)="001" THEN
--       FINAL<=PC1;
--   ELSIF SW(7 DOWNTO 5)="010" THEN
--        FINAL<=INSTR1;
--        ELSIF SW(7 DOWNTO 5)="011" THEN
---        FINAL<=RD1;
--       ELSIF SW(7 DOWNTO 5)="100" THEN
--        FINAL<=RD2;
--        ELSIF SW(7 DOWNTO 5)="101" THEN
--        FINAL<=WD;
        -- END IF;
--    END IF;
--END PROCESS;
process (clk)
begin
if rising_edge(clk) then
    if en='1' then
        if sw(1)='1' then
            sig <= sig + 1;
        else
            sig <= sig - 1;
        end if;
    end if;
end if;
end process;

PROCESS(SW(0), CLK)
    BEGIN
        if(CLK = '1' AND CLK'EVENT) THEN
            if (SW(0) = '0' )then
                LED(7) <= REGDEST;
                LED(6) <= EXTOP;
                LED(5) <= ALUSRC;
                LED(4) <= B;
                LED(3) <= J;
                LED(2) <= MEMW;
                LED(1) <= MEMR;
                LED(0) <= REGWRITE;
            ELSE
                LED(7 DOWNTO 0) <= "00000" & OPCODE;
            END IF;  
        END IF;
    END PROCESS;

    PROCESS( SW(7 DOWNTO 5) )
    BEGIN
        CASE (SW(7 DOWNTO 5)) IS
            WHEN "000" => FINAL <= INSTR1; 
            WHEN "001" => FINAL <= PC1;
            WHEN "010" => FINAL <= RD1; 
            WHEN "011" => FINAL <= RD2;
            WHEN "100" => FINAL <= EXTIMM;
            WHEN "101" => FINAL <= RES;
            WHEN "110" => FINAL <= DOUT;            
            WHEN OTHERS => FINAL <= WD;
        END CASE;
    END PROCESS;

END Behavioral;