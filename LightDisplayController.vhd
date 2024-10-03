library IEEE; 

use IEEE.STD_LOGIC_1164.ALL; 

 

entity LightDisplayController is 

    Port ( 

        Left, Right : in STD_LOGIC;               -- Left and Right switches 

        GClock, GReset : in STD_LOGIC;            -- Global Clock and Reset 

        DisplayOut : out STD_LOGIC_VECTOR(7 downto 0) -- 8-bit LED display output 

    ); 

end LightDisplayController; 

 

architecture Structural of LightDisplayController is 

    -- Internal signals 

    signal LMASK, RMASK, display : std_logic_vector(7 downto 0); 

    signal mux_out : std_logic_vector(7 downto 0); 

    signal state_out : std_logic_vector(3 downto 0); -- State from control unit 

 

    -- Control signals for the datapath 

    signal load_left, load_right, display_enable : std_logic; 

 

    -- Component Declarations 

    component datapath 

        Port ( 

            Left, Right : in STD_LOGIC; 

            GClock, GReset : in STD_LOGIC; 

            DisplayOut : out STD_LOGIC_VECTOR(7 downto 0)      -- 8-bit display output 

        ); 

    end component; 

 

    component ControlUnit 

        Port ( 

            GClock : in STD_LOGIC; 

            GReset : in STD_LOGIC; 

            Left, Right : in STD_LOGIC; 

            state_out : out STD_LOGIC_VECTOR(3 downto 0) 

        ); 

    end component; 

 

begin 

    -- Instantiate the Control Unit 

    CU: ControlUnit 

        Port Map ( 

            GClock => GClock, 

            GReset => GReset, 

            Left => Left, 

            Right => Right, 

            state_out => state_out 

        ); 

 

    -- Control Signal Generation based on states 

    -- State Encoding: "0001" = IDLE, "0010" = SHIFT_LEFT, "0100" = SHIFT_RIGHT, "1000" = SHIFT_BOTH 

    load_left <= state_out(1);  -- Active when SHIFT_LEFT or SHIFT_BOTH 

    load_right <= state_out(2); -- Active when SHIFT_RIGHT or SHIFT_BOTH 

    display_enable <= state_out(1) or state_out(2) or state_out(3); -- Enable display on active states 

 

    -- Instantiate the Datapath Unit 

    DP: datapath 

        Port Map ( 

            Left => Left, 

            Right => Right, 

            GClock => GClock, 

            GReset => GReset, 

            DisplayOut => DisplayOut 

        ); 

 

end Structural; 