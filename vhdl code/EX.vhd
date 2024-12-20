library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity EX is
    Port(
            RD1 : in std_logic_vector(31 downto 0);
            ALUSrc : in std_logic;
            RD2 : in std_logic_vector(31 downto 0);
            Ext_Imm : in std_logic_vector(31 downto 0);
            sa : in std_logic_vector(4 downto 0);
            func : in std_logic_vector(5 downto 0);
            ALUOp : in std_logic_vector(2 downto 0);
            PC_4 : in std_logic_vector(31 downto 0);
            Zero : out std_logic;
            ALURes : out std_logic_vector(31 downto 0);
            BranchAddress : out std_logic_vector(31 downto 0);
            
            SRV: in std_logic -- reprezinta Instr(0); adaugat de mine         
    );
end EX;

architecture Behavioral of EX is
    signal ALUCtrl : std_logic_vector(2 downto 0);
    signal ALUin2 : std_logic_vector(31 downto 0);
    signal ALUResAux : std_logic_vector(31 downto 0);
begin 
    ALUin2 <= RD2 when ALUSrc = '0' else Ext_Imm;   -- muxul pentru a doua intrare de la ALU
    
    process(ALUOp, func)    --ALU control
    begin
        case ALUOp is           
            when "000" =>   --tip R
                case func is
                    when b"100_000" => ALUCtrl <= "000";    -- add (+)
                    when b"100_010" => ALUCtrl <= "001";    -- sub (-)
                    when b"100_101" => ALUCtrl <= "010";    -- or (OR)
                    when b"100_100" => ALUCtrl <= "011";    -- and (AND)
                    when b"100_110" => ALUCtrl <= "100";    -- xor (XOR)
                    when b"000_000" => ALUCtrl <= "101";    -- sll (Shift LEFT)
                    when b"000_010" => ALUCtrl <= "110";    -- srl (Shift RIGHT logic)
                    when b"000_011" => ALUCtrl <= "111";    -- sra (Shift RIGHT aritmetic)
                    when others => ALUCtrl <= "000";
                end case;
            when "001" => ALUCtrl <= "000"; -- sw (+)
            when "010" => ALUCtrl <= "000"; -- lw (+)
            when "011" => ALUCtrl <= "000"; -- addi (+)
            when "100" => ALUCtrl <= "010"; -- ori (OR)
            when "101" => ALUCtrl <= "001"; -- beq (-)
            when "110" => ALUCtrl <= "001"; -- bgez (-)
            when "111" => ALUCtrl <= "111"; -- j (don't care)
            when others => ALUCtrl <= "000"; -- va lua + 
        end case;  
      end process;
      
      process(RD1, ALUin2, SRV, sa, ALUCtrl)        -- ALU
      begin
        case ALUCtrl is
            when "000" => ALUResAux <= RD1 + ALUin2;   -- +
            when "001" => ALUResAux <= RD1 - ALUin2;   -- -
            when "010" => ALUResAux <= RD1 or ALUin2;   -- OR
            when "011" => ALUResAux <= RD1 and ALUin2;   -- AND
            when "100" => ALUResAux <= RD1 xor ALUin2;   -- XOR
            when "101" => ALUResAux <=  to_stdlogicvector(to_bitvector(ALUin2) sll conv_integer(sa));   -- shift LEFT
            when "110" => ALUResAux <= to_stdlogicvector(to_bitvector(ALUin2) srl conv_integer(sa));   -- shift RIGHT logic
            when "111" => ALUResAux <= to_stdlogicvector(to_bitvector(ALUin2) sra conv_integer(sa));   -- shift RIGHT aritmetic
            when others => ALUResAux <= RD1;   -- DON'T CARE
        end case;      
      end process; 
    
    BranchAddress <= PC_4 + (Ext_Imm(29 downto 0) & "00");  -- suma dintre PC+4 si Ext_Imm shiftat cu 2 pozitii la stanga

    Zero <= '1' when ALUResAux = x"00000000" else '0';
    
    ALURes <= ALUResAux;
end Behavioral;