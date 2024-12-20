

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;


entity UC is
  Port ( 
        Instr : in std_logic_vector(5 downto 0);
        RegDst : out std_logic;
        ExtOp : out std_logic;
        ALUSrc : out std_logic;
        Branch : out std_logic;
        Jump : out std_logic;
        AluOp : out std_logic_vector(2 downto 0);
        MemWrite : out std_logic;
        MemtoReg : out std_logic;
        RegWrite : out std_logic;
        bgez: out std_logic  
  );
end UC;

architecture Behavioral of UC is
begin
    process(Instr)
    begin
        RegDst <= '0';
        ExtOp <= '0';
        ALUSrc <= '0';
        Branch <= '0';
        Jump <= '0';
        AluOp <= "000";
        MemWrite <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';
        bgez <= '0';
        case Instr is
            when "000000" =>        -- tip R
                RegDst <= '1';
                RegWrite <= '1';
                AluOp <= "000";
            when "101011" =>        -- sw
                ALUSrc <= '1';
                ExtOp <= '1';
                MemWrite <= '1';
                AluOp <= "001";
            when "100011" =>        -- lw
                RegWrite <= '1';
                ALUSrc <= '1';
                ExtOp <= '1';
                MemtoReg <= '1';
                AluOp <= "010";
            when "001000" =>        -- addi
                RegWrite <= '1';
                ALUSrc <= '1';
                ExtOp <= '1';
                AluOp <= "011";
            when "001101" =>        -- ori
                RegWrite <= '1';
                ALUSrc <= '1';
                ExtOp <= '1';
                AluOp <= "100";
            when "000100" =>        -- beq
                ExtOp <= '1';
                Branch <= '1';
                AluOp <= "101";
            when "000001" =>        -- bgez
                ExtOp <= '1';
                Branch <= '1';
                bgez <= '1';
                AluOp <= "110";
            when "000010" =>        -- j
                Jump <= '1';
                AluOp <= "111";
            when others =>
        end case;
    end process;

end Behavioral;
