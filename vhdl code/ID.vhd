
------------------------------------------ ID

-- RF este implementat direct aici si nu am facut cu component si port map

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ID is
    Port(
        RegWrite: in std_logic;
        Instr : in std_logic_vector(25 downto 0);
        RegDst: in std_logic;
        clk : in std_logic;
        ExtOp : in std_logic;
        WD : in std_logic_vector(31 downto 0);
        RD1 : out std_logic_vector(31 downto 0);
        RD2 : out std_logic_vector(31 downto 0);
        Ext_Imm : out std_logic_vector(31 downto 0);
        func: out std_logic_vector(5 downto 0);
        sa : out std_logic_vector(4 downto 0);
        
        enable: in std_logic
    );
end ID;

architecture Behavioral of ID is

    type reg_array is array(0 to 31) of std_logic_vector(31 downto 0);
    signal reg_file : reg_array:= (
        others => X"00000000");
        
    signal wa : std_logic_vector(4 downto 0);

begin

    wa <= Instr(20 downto 16) when RegDst = '0' else Instr(15 downto 11);   -- muxul care decide Write Adress pt RF
    process(clk)
    begin
        if rising_edge(clk) then
            if RegWrite = '1' then
                if enable = '1' then 
                    reg_file(conv_integer(wa)) <= WD;
                end if;
            end if;
        end if;
    end process;
    RD1 <= reg_file(conv_integer(Instr(25 downto 21))); -- RD1 ia rs
    RD2 <= reg_file(conv_integer(Instr(20 downto 16))); -- RD2 ia rt
    
    Ext_Imm(15 downto 0) <= Instr(15 downto 0);
    Ext_Imm(31 downto 16) <= (others => Instr(15)) when ExtOp = '1' else (others => '0');
    
    func <= Instr(5 downto 0);
    sa <= Instr(10 downto 6);

end Behavioral;
