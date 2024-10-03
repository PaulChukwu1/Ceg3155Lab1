library IEEE; 

use IEEE.STD_LOGIC_1164.ALL; 

 

-- Entity for the D Flip-Flop using structural modeling 

entity D_FF is 

    Port ( 

        D : in STD_LOGIC;        -- Data input 

        CLK : in STD_LOGIC;      -- Clock input 

        Q : out STD_LOGIC        -- Output 

    ); 

end D_FF; 

 

-- Structural architecture of the D Flip-Flop 

architecture Structural of D_FF is 

    -- Internal signals to connect components 

    signal D_gated, Q_int, Q_int_bar : STD_LOGIC; 

 

    -- Component declarations for basic gates 

    component AND2 is 

        Port ( 

            A, B : in STD_LOGIC; 

            Y : out STD_LOGIC 

        ); 

    end component; 

 

    component OR2 is 

        Port ( 

            A, B : in STD_LOGIC; 

            Y : out STD_LOGIC 

        ); 

    end component; 

 

    component NOT1 is 

        Port ( 

            A : in STD_LOGIC; 

            Y : out STD_LOGIC 

        ); 

    end component; 

 

begin 

    -- Gate-level implementation of D flip-flop 

    -- NOT gate to invert the clock signal 

    U0: NOT1 Port Map(A => CLK, Y => D_gated); 

 

    -- Internal D latch using AND and OR gates 

    -- This latch will be transparent when the clock is low 

    -- Q_int_bar (complementary) logic 

    U1: OR2 Port Map(A => D_gated, B => Q_int, Y => Q_int_bar); 

     

    -- Output Q logic 

    U2: OR2 Port Map(A => D, B => Q_int_bar, Y => Q_int); 

 

    -- Final Output Assignment 

    Q <= Q_int; 

 

end Structural; 