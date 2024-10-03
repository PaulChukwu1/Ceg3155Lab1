library IEEE; 

use IEEE.STD_LOGIC_1164.ALL; 

use IEEE.STD_LOGIC_ARITH.ALL; 

use IEEE.STD_LOGIC_UNSIGNED.ALL; 

 

entity datapath is 

    Port( 

        Left, Right : in STD_LOGIC; -- Control signals for selecting mux input 

        GClock, GReset : in STD_LOGIC; -- Global Clock and Reset 

        DisplayOut : out STD_LOGIC_VECTOR(7 downto 0) -- Final output 

    ); 

end datapath; 

 

architecture structural of datapath is 

    -- Internal signals to connect components 

    signal my_zero : std_LOGIC_VECTOR(7 downto 0) := (others => '0'); 

    signal LMASK, RMASK, displayl, displayr, display, mux_out : std_logic_vector(7 downto 0);  

    signal comparator_GT, comparator_LT, comparator_EQ : std_logic; -- Comparator outputs 

    signal mux_select : std_logic_vector(1 downto 0); -- Mux select line 

 

    -- Component declarations 

    COMPONENT dFF_1 

        PORT( 

            i_d : IN  STD_LOGIC; 

            i_clock : IN  STD_LOGIC; 

            o_q, o_qBar : OUT STD_LOGIC 

        ); 

    end component; 

 

    Component eightBitShiftLRegister 

        PORT( 

            i_resetBar, i_load : IN  STD_LOGIC; 

            i_clock            : IN  STD_LOGIC; 

            i_Value            : IN  STD_LOGIC_VECTOR(7 downto 0); 

            o_Value           : OUT STD_LOGIC_VECTOR(7 downto 0) 

        ); 

    end component; 

 

    Component eightBitShiftRRegister 

        PORT( 

            i_resetBar, i_load : IN  STD_LOGIC; 

            i_clock            : IN  STD_LOGIC; 

            i_Value            : IN  STD_LOGIC_VECTOR(7 downto 0); 

            o_Value           : OUT STD_LOGIC_VECTOR(7 downto 0) 

        ); 

    end component; 

 

    component mux_4to1 

        Port( 

            A, B, C, D : in std_logic_vector(7 downto 0); -- Inputs 

            sel        : in std_logic_vector(1 downto 0); -- 2-bit select line 

            Y          : out std_logic_vector(7 downto 0) -- Output 

        ); 

    end component; 

 

    component displayBitRegister 

        PORT( 

            i_resetBar, i_load : IN  STD_LOGIC; 

            i_clock            : IN  STD_LOGIC; 

            i_Value            : IN  STD_LOGIC_VECTOR(7 downto 0); 

            o_Value           : OUT STD_LOGIC_VECTOR(7 downto 0) 

        ); 

    end component; 

 

    component eightBitComparator 

        PORT( 

            i_Ai, i_Bi : IN  STD_LOGIC_VECTOR(7 downto 0); 

            o_GT, o_LT, o_EQ : OUT STD_LOGIC 

        ); 

    end component; 

 

begin  

    -- Left Shift Register: Shifts data left based on control inputs 

    U1: eightBitShiftLRegister  

        PORT MAP( 

            i_clock => GClock, 

            i_resetBar => GReset, 

            i_load => '1', -- Always load in this configuration 

            i_Value => LMASK, 

            o_Value => displayl 

        ); 

 

    -- Right Shift Register: Shifts data right based on control inputs 

    U2: eightBitShiftRRegister  

        PORT MAP( 

            i_clock => GClock, 

            i_resetBar => GReset, 

            i_load => '1', -- Always load in this configuration 

            i_Value => RMASK, 

            o_Value => displayr 

        ); 

 

    -- Display Register: Stores the output of the mux for display purposes 

    U3: displayBitRegister  

        PORT MAP( 

            i_clock => GClock, 

            i_resetBar => GReset, 

            i_load => '1', -- Always load in this configuration 

            i_Value => mux_out, 

            o_Value => display 

        ); 

 

    -- Comparator: Compares left and right shift register values 

    U4: eightBitComparator  

        PORT MAP( 

            i_Ai => LMASK, 

            i_Bi => RMASK, 

            o_GT => comparator_GT, 

            o_LT => comparator_LT, 

            o_EQ => comparator_EQ 

        ); 

 

    -- 4-to-1 Multiplexer: Selects between the zero vector, left shift, right shift, and display register 

    U5: mux_4to1  

        PORT MAP( 

            A => my_zero,        -- Zero Vector 

            B => displayr,       -- Right shift register output 

            C => displayl,       -- Left shift register output 

            D => display,        -- Display register output 

            sel => Left & Right, -- 2-bit select line from inputs 

            Y => mux_out         -- Output to display register 

        ); 

 

    -- Output assignment 

    DisplayOut <= display; -- Connect final display output to DisplayOut 

 

    -- Additional Control Signal Logic 

    -- `LMASK` and `RMASK` would be driven from another source or control logic in a complete design 

    LMASK <= "00000001"; -- Example pattern for left register (static value) 

    RMASK <= "10000000"; -- Example pattern for right register (static value) 

 

end structural; 