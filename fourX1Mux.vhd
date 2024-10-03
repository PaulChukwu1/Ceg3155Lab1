library IEEE; 

use IEEE.STD_LOGIC_1164.ALL; 

 

-- Entity for 4-to-1 MUX 

entity mux_4to1 is 

    Port ( 

        A : in std_logic; -- Input A 

        B : in std_logic; -- Input B 

        C : in std_logic; -- Input C 

        D : in std_logic; -- Input D 

        sel : in std_logic_vector(1 downto 0); -- 2-bit select line 

        Y : out std_logic  -- Output 

    ); 

end mux_4to1; 

architecture structural of mux_4to1 is 

    -- Internal signals for NOT gates 

    signal sel_not_0, sel_not_1 : std_logic; 

    -- Internal signals for AND gates 

    signal and_A, and_B, and_C, and_D : std_logic; 

 

begin 

    -- NOT gates for select lines 

    sel_not_0 <= not sel(0); 

    sel_not_1 <= not sel(1); 

 

    -- AND gates for each input 

    and_A <= A and sel_not_1 and sel_not_0;  -- Select "00" 

    and_B <= B and sel_not_1 and sel(0);     -- Select "01" 

    and_C <= C and sel(1) and sel_not_0;     -- Select "10" 

    and_D <= D and sel(1) and sel(0);        -- Select "11" 

 

    -- OR gate to combine the outputs 

    Y <= and_A or and_B or and_C or and_D; 

 

end structural; 

 