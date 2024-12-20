-------------------------------------->   SSD

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ssd is       -- facut dupa figura 2.2 din lab2
    Port(clk: in std_logic;
         an: out std_logic_vector(7 downto 0);
         cat: out std_logic_vector (6 downto 0);
         d0, d1, d2, d3, d4, d5, d6, d7, d8: in std_logic_vector(3 downto 0)  --cifrele individuale trimise pe fiecare afisor
    );
end ssd;

architecture Behavioral of ssd is
    signal count: STD_LOGIC_VECTOR(16 downto 0);
    signal digitSelected: std_logic_vector(3 downto 0);
    signal sigAn: std_logic_vector (7 downto 0);
    signal sigCat: std_logic_vector (6 downto 0);
begin
    process(clk) -- counter
    begin
        if rising_edge(clk) then
          count <= count + 1;
       end if;
    end process;

    process (count(16 downto 14), clk) -- mux de sus
    begin
       case count(16 downto 14) is
          when "000" => digitSelected <= d0;       --"0000";
          when "001" => digitSelected <= d1;       --"0001";
          when "010" => digitSelected <= d2;       --"0010";
          when "011" => digitSelected <= d3;       --"0011";
          when "100" => digitSelected <= d4;       --"0100";
          when "101" => digitSelected <= d5;       --"0101";
          when "110" => digitSelected <= d6;       --"0110";
          when "111" => digitSelected <= d7;       --"0111";
          when others => digitSelected <= d8;      --"1000";
       end case;
    end process;
    
    process (count(16 downto 14), clk) -- mux de jos
    begin
       case count(16 downto 14) is
          when "000" => sigAn <= "11111110";
          when "001" => sigAn <= "11111101";
          when "010" => sigAn <= "11111011";
          when "011" => sigAn <= "11110111";
          when "100" => sigAn <= "11101111";
          when "101" => sigAn <= "11011111";
          when "110" => sigAn <= "10111111";
          when "111" => sigAn <= "01111111";
          when others => sigAn <= "01111111";
       end case;
    end process;
    
    
    process(clk, digitSelected) -- hex to seven segment
    begin
        case digitSelected is
                when "0001" => sigCat <= "1111001";
                when "0010" => sigCat <= "0100100";
                when "0011" => sigCat <= "0110000";
                when "0100" => sigCat <= "0011001";
                when "0101" => sigCat <= "0010010";
                when "0110" => sigCat <= "0000010";
                when "0111" => sigCat <= "1111000";
                when "1000" => sigCat <= "0000000";
                when "1001" => sigCat <= "0010000";
                when "1010" => sigCat <= "0001000"; -- A
                when "1011" => sigCat <= "0000011"; -- B
                when "1100" => sigCat <= "1000110"; -- C
                when "1101" => sigCat <= "0100001"; -- D
                when "1110" => sigCat <= "0000110"; -- E
                when "1111" => sigCat <= "0001110"; -- F
                when others => sigCat <= "1000000";
          end case;
    end process;
    
    an <= sigAn;
    cat <= sigCat;
end Behavioral;