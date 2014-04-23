library IEEE;
use IEEE.std_logic_1164.all;

package CONV_PACK_Crypto_garage is
  
--   type Switches is (die, juice); -- interruptuer arret/marche
-- commandes pour la porte du garage:
  
--   type Commands is (no_command, deactivate, d_open, d_close);
  
-- types Switch et Command obtenu apres Synthese

-- define attributes
attribute ENUM_ENCODING : STRING;

type Switches is (die, juice);
attribute ENUM_ENCODING of Switches : type is "0 1";
type Commands is (no_command, deactivate, d_open, d_close);
attribute ENUM_ENCODING of Commands : type is "00 01 10 11";
   
-- Declarations for conversion functions.
   function Switches_to_std_logic(arg : in Switches) return std_logic;
   function Commands_to_std_logic_vector(arg : in Commands) return 
               std_logic_vector;
-- etats de l'automate:
   type States is (PowerUp, PowerDown, NoKey, Deactivated, Activated, Down,
                  Up, MovingOnDown, MovingOnUp, SafetyError, SecurityError);
  
-- a l'origine la porte est fermee (true) ou ouverte (false)
   constant init_closed: boolean:= true;


end CONV_PACK_Crypto_garage;




-- define any necessary types


package body CONV_PACK_Crypto_garage is
   
   -- enum type to std_logic function
   function Switches_to_std_logic(arg : in Switches) return std_logic is
   -- synopsys built_in SYN_FEED_THRU;
   begin
      case arg is
         when die => return '0';
         when juice => return '1';
         when others => assert FALSE -- this should not happen.
               report "un-convertible value"
               severity warning;
               return '0';
      end case;
   end;
   
   -- enum type to std_logic_vector function
   function Commands_to_std_logic_vector(arg : in Commands) return 
   std_logic_vector is
   -- synopsys built_in SYN_FEED_THRU;
   begin
      case arg is
         when no_command => return "00";
         when deactivate => return "01";
         when d_open => return "10";
         when d_close => return "11";
         when others => assert FALSE -- this should not happen.
               report "un-convertible value"
               severity warning;
               return "00";
       end case;
end;


end CONV_PACK_Crypto_garage;

