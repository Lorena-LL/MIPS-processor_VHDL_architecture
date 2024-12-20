
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;


entity MEM is
      Port ( 
            clk : in std_logic;
            MemWrite : in std_logic;
            AluResin : in std_logic_vector(31 downto 0);
            RD2 : in std_logic_vector(31 downto 0);
            MemData : out std_logic_vector(31 downto 0);
            AluResout : out std_logic_vector(31 downto 0);
            enable: in std_logic
      );
end MEM;

architecture Behavioral of MEM is

    type ram_type is array (0 to 63) of std_logic_vector(31 downto 0);
    signal ram : ram_type := (
                        X"00000000", -- 0   se va scrie count
                        X"00000005", -- 4   N=5
                        X"fffffff9", -- 8   -7
                        X"00000003", -- 12  3
                        X"00000002", -- 16  2
                        X"ffffffff", -- 20  -1
                        X"ffffffef", -- 24  -17
                        others => X"00000000");


begin
    process(clk)
    begin
    -- scriere sincrona
        if rising_edge(clk) then
            if enable = '1' then 
                if MemWrite = '1' then
                    ram(conv_integer(ALUResin(7 downto 2))) <= RD2;
                end if;
            end if;
        end if;
    end process;
    
    -- citire asincrona:
    MemData <= ram(conv_integer(ALUResin(7 downto 2)));
    
    ALUResout <= ALUResin;

end Behavioral;
