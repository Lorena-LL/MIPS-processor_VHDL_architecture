library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity test_env is
    Port (  clk : in STD_LOGIC;
            btn : in STD_LOGIC_VECTOR (4 downto 0);
            sw : in STD_LOGIC_VECTOR (15 downto 0);
            led : out STD_LOGIC_VECTOR (15 downto 0);
            an : out STD_LOGIC_VECTOR (7 downto 0);
            cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
    signal count_int: std_logic_vector(4 downto 0);    -- pe cati biti numara counterul
    signal mpg_out: std_logic;
    signal ssd_data: std_logic_vector(31 downto 0);
    signal instruction: std_logic_vector(31 downto 0);
    signal PC_4: std_logic_vector(31 downto 0);
    signal RegWrite: std_logic;
    signal RegDst: std_logic;
    signal ExtOp: std_logic;
    signal WD: std_logic_vector(31 downto 0);
    signal RD1: std_logic_vector(31 downto 0);
    signal RD2: std_logic_vector(31 downto 0);
    signal Ext_Imm: std_logic_vector(31 downto 0);
    signal func: std_logic_vector(5 downto 0);
    signal sa: std_logic_vector(4 downto 0);
    signal ALUSrc: std_logic;
    signal Branch: std_logic;
    signal Jump: std_logic;
    signal AluOp: std_logic_vector(2 downto 0);
    signal MemWrite: std_logic;
    signal MemtoReg: std_logic;
    signal bgez: std_logic;
    signal Zero: std_logic;
    signal ALURes: std_logic_vector(31 downto 0);
    signal ALUResout: std_logic_vector(31 downto 0);
    signal BranchAddress: std_logic_vector(31 downto 0);
    signal JumpAddress: std_logic_vector(31 downto 0);
    signal PCSrc: std_logic;
    signal MemData: std_logic_vector(31 downto 0);
    signal beq_andout: std_logic;
    signal bgez_andout: std_logic;
    
    signal mpg_outRFwrite: std_logic;
    signal mpg_outMEMwrite: std_logic;
    signal selectionSSD: std_logic_vector(2 downto 0);
    
    component mpg
       Port( en: out STD_LOGIC;     
             button: in STD_LOGIC;  
             clock: in STD_LOGIC);
    end component;
    component ssd
    Port(clk: in std_logic;
         an: out std_logic_vector(7 downto 0);
         cat: out std_logic_vector (6 downto 0);
         d0, d1, d2, d3, d4, d5, d6, d7, d8: in std_logic_vector(3 downto 0));
    end component;
    component IFetch is
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
    end component;
    component ID is
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
        end component;
    component UC is
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
    end component;
    component EX is
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
    end component;
    component MEM is
      Port ( 
            clk : in std_logic;
            MemWrite : in std_logic;
            AluResin : in std_logic_vector(31 downto 0);
            RD2 : in std_logic_vector(31 downto 0);
            MemData : out std_logic_vector(31 downto 0);
            AluResout : out std_logic_vector(31 downto 0);
            enable: in std_logic
      );
    end component;
    
begin

    mpg_inst: mpg port map(en => mpg_out, button => btn(0), clock => clk);
    mpg_inst_RFwrite: mpg port map(en => mpg_outRFwrite, button => btn(2), clock => clk);
    mpg_inst_MEMwrite: mpg port map(en => mpg_outMEMwrite, button => btn(3), clock => clk);
    ssd_inst: ssd port map(clk => clk, an => an, cat => cat, d7=>ssd_data(31 downto 28), d6=>ssd_data(27 downto 24), d5=>ssd_data(23 downto 20), d4=>ssd_data(19 downto 16), d3=>ssd_data(15 downto 12), d2=>ssd_data(11 downto 8), d1=>ssd_data(7 downto 4), d0=>ssd_data(3 downto 0), d8=>"0000");
    iFetch_inst: IFetch port map(   clk => clk,
                                    branch_address => BranchAddress,
                                    PCSrc => PCSrc,
                                    jump_address => JumpAddress,
                                    jump => Jump,
                                    instruction => instruction,
                                    PC_4 => PC_4,
                                    pc_enable => mpg_out,
                                    pc_reset => btn(1));
     ID_inst: ID port map(  RegWrite => RegWrite,
                            Instr => instruction(25 downto 0),
                            RegDst => RegDst,
                            clk => clk,
                            ExtOp => ExtOp,
                            WD => WD,
                            RD1 => RD1,
                            RD2 => RD2,
                            Ext_Imm => Ext_Imm,
                            func => func,
                            sa =>sa,
                            enable => mpg_outRFwrite);
      UC_inst: UC port map( Instr => instruction(31 downto 26),
                            RegDst => RegDst,
                            ExtOp => ExtOp,
                            ALUSrc => ALUSrc,
                            Branch => Branch,
                            Jump => Jump,
                            AluOp => AluOp, 
                            MemWrite => MemWrite,
                            MemtoReg => MemtoReg,
                            RegWrite => RegWrite,
                            bgez => bgez);
      EX_inst: EX port map( RD1 => RD1,
                            ALUSrc => ALUSrc,
                            RD2 => RD2,
                            Ext_Imm => Ext_Imm,
                            sa => instruction(10 downto 6),
                            func => instruction(5 downto 0),
                            ALUOp => ALUOp,
                            PC_4 => PC_4,
                            Zero => Zero,
                            ALURes => ALURes,
                            BranchAddress => BranchAddress,
                            SRV => instruction(0));
     MEM_INST: mem PORT MAP(    clk => clk,
                                MemWrite => MemWrite,
                                AluResin => ALURes,
                                RD2 => RD2,
                                MemData => MemData,
                                AluResout => ALUResout,
                                enable => mpg_outMEMwrite);
                            
     JumpAddress <= PC_4(31 downto 28) & instruction(25 downto 0) & "00";   -- intrarea 1 in muxul Jump din IFetch
     
     
     
     beq_andout <= Branch and Zero;                         -- poarta AND de dupa ALU pentru beq
     bgez_andout <= bgez and Branch and (not ALURes(31));   -- poarta AND de dupa ALU pentru bgez
     PCSrc <= beq_andout or bgez_andout;                    -- selectia PCSrc pentru muxul 1 de la salt
     
     WD <= MemData when MemtoReg = '1' else ALUResout;     -- muxul cu selectia MemtoReg de dupa memorie
                            
                                  
     selectionSSD <= sw(7) & sw(6) & sw(5);
     process(selectionSSD)  -- mux pt SSD
     begin
        case selectionSSD is
            when "000" => ssd_data <=instruction;
            when "001" => ssd_data <= BranchAddress;
            when "010" => ssd_data <= RD1;
            when "011" => ssd_data <= RD2;
            when "100" => ssd_data <= Ext_Imm;
            when "101" => ssd_data <= ALURes;
            when "110" => ssd_data <= MemData;
            when "111" => ssd_data <= pc_4; --WD;
            when others => ssd_data <= x"AAAAAAAA";
        end case;
     end process;
     
     
     led(15) <= RegDst;
     led(14) <= ExtOp;
     led(13) <= ALUSrc;
     led(12) <= Branch;
     led(11) <= Jump;
     led(10) <= MemWrite;
     led(9) <= MemtoReg;
     led(8) <= RegWrite;
     led(7) <= ALUOp(0);
     led(6) <= ALUOp(1);
     led(5) <= ALUOp(2);
     
     --leduri care imi arata salturile conditionate 
     led(3) <=zero;
     led(2) <= beq_andout;
     led(1) <=bgez_andout;
     led(0) <=PCSrc;
    
end Behavioral;


