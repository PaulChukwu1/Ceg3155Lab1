library IEEE; 

use IEEE.STD_LOGIC_1164.ALL; 

  

entity and_gate is 

    Port ( a : in  STD_LOGIC; 

           b : in  STD_LOGIC; 

           result : out  STD_LOGIC); 

end and_gate; 

  

architecture structural of and_gate is 

begin 

    result <= a AND b; 

end structural; 

 