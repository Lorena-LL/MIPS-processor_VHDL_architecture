

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;


entity IFetch is
      Port ( 
            clk: in std_logic;
            branch_address: in std_logic_vector(31 downto 0);
            PCSrc: in std_logic;
            jump_address: in std_logic_vector(31 downto 0);
            jump: in std_logic;
            instruction: out std_logic_vector(31 downto 0);
            PC_4: out std_logic_vector(31 downto 0);
            pc_enable: in std_logic;
            pc_reset: in std_logic
      );
end IFetch;

architecture Behavioral of IFetch is


    signal pc_in: std_logic_vector(31 downto 0);
    signal pc_out: std_logic_vector(31 downto 0);
    signal mux1_out: std_logic_vector(31 downto 0);
    signal adder_out: std_logic_vector(31 downto 0);
   
    
    type rom32x32 is array(0 to 31) of std_logic_vector(31 downto 0);
    signal rom1: rom32x32 := (
        B"001000_00000_00001_0000000000000001",     -- addi $1, $0, 1       hex: 2001 0001
        B"001000_00000_00101_0000000000000000",     -- addi $5, $0, 0       hex: 2005 0000
        B"001000_00000_00011_0000000000000100",     -- addi $3, $0, 4       hex: 2003 0004
        B"100011_00011_00010_0000000000000000",     -- lw $2, 0($3)         hex: 8C62 0000
        B"001000_00000_00011_0000000000001000",     -- addi $3, $0, 8       hex: 2003 0008
        
        B"000100_00010_00000_0000000000000110",     -- beq $2, $0, 6        hex: 1040 0006
        B"100011_00011_00100_0000000000000000",     -- lw $4, 0($3)         hex: 8C64 0000
        B"001000_00011_00011_0000000000000100",     -- addi $3, $3, 4       hex: 2063 0004
        
        B"000001_00100_00000_0000000000000001",     -- bgez $4, 1           hex: 0480 0001
        B"001000_00101_00101_0000000000000001",     -- addi $5, $5, 1       hex: 20A5 0001
        B"000000_00010_00001_00010_00000_100010",   -- sub $2, $2, $1       hex: 0041 1022
        B"000010_00000000000000000000000101",       -- j 5                  hex: 0800 0005
        B"101011_00000_00101_0000000000000000",     -- sw $5, 0($0)         hex: AC05 0000
        
        -- de urmatoarea insrtuctiune nu mai am nevoie pt ca pot vedea ca se stocheaza ce trebuie in memorie cuu MemData
        --B"100011_00000_00110_0000000000000000",     -- lw $5, 0($0)         hex: 8C06 0000
        others => x"00000000");

begin
    
    process(clk)    ------------ PC 
    begin
        if pc_reset = '1' then --reset
            pc_out <= x"00000000";
        end if;
        if rising_edge(clk) then --load
            if pc_enable = '1' then 
                pc_out <= pc_in;
            end if;
        end if;
    end process;
    
    instruction <= rom1(conv_integer(pc_out(6 downto 2)));  -- memoria rom
    
    mux1_out <= adder_out when PCSrc = '0' else branch_address; -- mux jos
    pc_in <= mux1_out when jump = '0' else jump_address;    -- mux sus

    adder_out <= pc_out + 4;    -- adder
    PC_4 <= adder_out;
end Behavioral;
