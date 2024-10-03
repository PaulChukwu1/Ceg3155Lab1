
library IEEE; 

use IEEE.STD_LOGIC_1164.ALL; 

 

entity ControlUnit is 

    Port ( 

        GClock : in STD_LOGIC;            -- Global Clock 

        GReset : in STD_LOGIC;            -- Global Reset 

        Left, Right : in STD_LOGIC;        -- Switch inputs 

        state_out : out STD_LOGIC_VECTOR(3 downto 0) -- State output (4 states for one-hot encoding) 

    ); 

end ControlUnit; 

 

architecture Structural of ControlUnit is 

    -- State encoding 

    signal state_reg, state_next : STD_LOGIC_VECTOR(3 downto 0); 

 

    -- State flip-flop components 

    component D_FF is 

        Port ( 

            D : in STD_LOGIC;        -- Data input 

            CLK : in STD_LOGIC;      -- Clock 

            RST : in STD_LOGIC;      -- Reset 

            Q : out STD_LOGIC        -- Output 

        ); 

    end component; 

 

    -- Internal signals for D flip-flops 

    signal idle_ff, shift_left_ff, shift_right_ff, shift_both_ff : STD_LOGIC; 

 

    -- Combinational logic for next state 

    signal next_idle, next_shift_left, next_shift_right, next_shift_both : STD_LOGIC; 

 

begin 

    -- Instantiate D flip-flops for each state 

    U0: D_FF Port Map(D => next_idle, CLK => GClock, RST => GReset, Q => idle_ff); 

    U1: D_FF Port Map(D => next_shift_left, CLK => GClock, RST => GReset, Q => shift_left_ff); 

    U2: D_FF Port Map(D => next_shift_right, CLK => GClock, RST => GReset, Q => shift_right_ff); 

    U3: D_FF Port Map(D => next_shift_both, CLK => GClock, RST => GReset, Q => shift_both_ff); 

 

    -- Combine flip-flop outputs into a single state vector 

    state_reg <= idle_ff & shift_left_ff & shift_right_ff & shift_both_ff; 

 

    -- Next state logic based on current state and inputs 

    next_idle <= '1' when (state_reg = "0001" and Left = '0' and Right = '0') else '0'; 

    next_shift_left <= '1' when (state_reg = "0001" and Left = '1' and Right = '0') else 

                          '1' when (state_reg = "0010" and Left = '1') else '0'; 

    next_shift_right <= '1' when (state_reg = "0001" and Left = '0' and Right = '1') else 

                           '1' when (state_reg = "0100" and Right = '1') else '0'; 

    next_shift_both <= '1' when (state_reg = "0001" and Left = '1' and Right = '1') else 

                          '1' when (state_reg = "1000" and Left = '1' and Right = '1') else '0'; 

 

    -- Output state encoding 

    state_out <= state_reg; -- Direct state encoding output 

 

end Structural; 