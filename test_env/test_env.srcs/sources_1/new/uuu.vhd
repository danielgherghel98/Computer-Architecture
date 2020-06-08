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

signal sig: STD_LOGIC_VECTOR(3 downto 0):="0000";
signal en:STD_LOGIC;

component reg_file is
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
end component;



signal final: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";

type memRom is array(0 to 15) of std_logic_vector(15 downto 0);
signal WD: std_logic_vector(15 downto 0);
signal RD1: std_logic_vector(15 downto 0);
signal my_instr: std_logic_vector(15 downto 0);
signal my_pc: std_logic_vector(15 downto 0);
signal RD2: std_logic_vector(15 downto 0);
signal RA1: std_logic_vector(3 downto 0):="0000";
signal RA2: std_logic_vector(3 downto 0):="0000";
signal WA: std_logic_vector(3 downto 0):="0000";
signal en1: std_logic;
signal en2: std_logic;
signal myRom : memRom:=(
B"000_010_011_001_0_000", --add 1 2 3 
B"000_001_010_011_0_001", --sub 3 1 2
B"000_010_001_100_1_010", --sll 4 2 1
B"000_100_100_101_1_011", --srl 5 6 4
B"000_100_101_000_0_100", --and 0 4 5
B"000_101_110_111_0_101", --or 7 5 6
B"000_000_111_010_0_110", --xor 2 0 7
B"000_111_000_101_0_111", --slt 5 7 0

B"001_010_001_0000001", --addi 1 2 1
B"010_011_010_0001000", --lw 2 offset(3)
B"011_110_101_0000100", --sw 5 offset(4)
B"100_001_011_0010010", --beq 1, 3, offset
B"101_101_100_0100100", --bgez 5, offset
B"110_110_111_0001010", --bne 6, 7, offset

B"111_0000000000010", --j 2
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

component IFE is
  Port ( 
    clk: in std_logic;
    rst:in std_logic;
    en: in std_logic;
    br_select: in std_logic;
    j_select: in std_logic;
    j_adr: in std_logic_vector(15 downto 0);
    br_adr: in std_logic_vector(15 downto 0);
    instr: OUT std_logic_vector(15 downto 0);
    pc: OUT std_logic_vector(15 downto 0)
  );
end component;

component UC is
  Port (
    opcode:in std_logic_vector(2 downto 0);
    rdst: out std_logic:='0';
    eop: out std_logic:='0';
    asrc: out std_logic:='0';
    b: out std_logic:='0';
    j: out std_logic:='0';
    aop: out std_logic_vector(1 downto 0):="00";
    regw: out std_logic:='0';
    memW: out std_logic:='0';
    m2r: out std_logic:='0'
   );
end component;
    
    signal rdst:  std_logic:='0';
    signal eop:  std_logic:='0';
    signal asrc:  std_logic:='0';
    signal b:  std_logic:='0';
    signal j:  std_logic:='0';
    signal aop:  std_logic_vector(1 downto 0):="00";
    signal regw:  std_logic:='0';
    signal memW:  std_logic:='0';
    signal m2r:  std_logic:='0';
     signal regWrite:  std_logic:='0';
    
       signal regDst: std_logic;
       signal  extOp: std_logic;  
       signal  extImm: std_logic_vector(15 downto 0);
       signal  func: std_logic_vector(2 downto 0);  
        signal sa:  std_logic;
    
    component ID is
      Port (
      clk:in std_logic;
        regWrite: in std_logic; 
        instr: in std_logic_vector(15 downto 0);
        regDst:in std_logic;
        extOp:in std_logic;  
        wd:in std_logic_vector(15 downto 0);
        rd1:out std_logic_vector(15 downto 0);
        rd2: out std_logic_vector(15 downto 0);
        extImm:out std_logic_vector(15 downto 0);
        func:out std_logic_vector(2 downto 0);  
        sa: out std_logic
       );
    end component;
begin

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
regWrite<=en1 and regW;
WD<= rd1+rd2;

--final<=myRom(conv_integer(sig));
C1: debounce port map(btn(4),clk,en);
C11: debounce port map(btn(0),clk,en1);
C12: debounce port map(btn(1),clk,en2);
c3: IFE port map(clk=>clk,rst=>en2,en => en1, br_select => sw(1), j_select => sw(0),j_adr=>"0000000000000010", br_adr=> "0000000000000110", instr=>my_instr,pc=>my_pc);
c31: UC port map(my_instr(15 downto 13),rdst,eop,asrc,b,j,aop,regW,memW,m2r);
c32: ID port map(clk,regWrite,my_instr,regDst,extOp,wd,rd1,rd2,extImm,func,sa);
C2: SSD port map(final, clk, an, cat);



led(15 downto 4) <= "111111111111";
led(3 downto 1)<=func;
led(0)<=sa;
process(sw(7 downto 5),my_instr,my_pc,rd1,rd2,regWrite,extImm)
begin
    case sw(7 downto 5) is
        when "000" => final <= my_instr;
        when "001" => final <= my_pc;
        when "010" => final <= my_pc;
        when "011" => final <= my_pc;
        when others  => final <= my_pc;
    end case;
end process;
--an<=btn(3 downto 0);
--cat<=(others=>'0');

end Behavioral;