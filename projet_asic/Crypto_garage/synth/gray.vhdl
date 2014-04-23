
library IEEE;

use IEEE.std_logic_1164.all;

package CONV_PACK_Crypto_garage is

-- define attributes
attribute ENUM_ENCODING : STRING;

-- define any necessary types
type Switches is (die, juice);
attribute ENUM_ENCODING of Switches : type is "0 1";
type Commands is (no_command, deactivate, d_open, d_close);
attribute ENUM_ENCODING of Commands : type is "00 01 10 11";
   
   -- Declarations for conversion functions.
   function Switches_to_std_logic(arg : in Switches) return std_logic;
   function Commands_to_std_logic_vector(arg : in Commands) return 
               std_logic_vector;

end CONV_PACK_Crypto_garage;

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

library IEEE;

use IEEE.std_logic_1164.all;

use work.CONV_PACK_Crypto_garage.all;

entity Crypto_garage is

   port( reset, clk, aes_key, authentication, reached_bottom, reached_top, ACSC
         , bad_encryption, timeout : in std_logic;  switch : in Switches;  
         command : in Commands;  key_led, authentication_led, open_light, 
         close_light : out std_logic);

end Crypto_garage;

architecture SYN_Garage of Crypto_garage is

   component DFC1
      port( C, D, RN : in std_logic;  Q, QN : out std_logic);
   end component;
   
   component OAI210
      port( A, B, C : in std_logic;  Q : out std_logic);
   end component;
   
   component AOI310
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component CLKIN0
      port( A : in std_logic;  Q : out std_logic);
   end component;
   
   component OAI2110
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component NOR20
      port( A, B : in std_logic;  Q : out std_logic);
   end component;
   
   component IMUX20
      port( A, B, S : in std_logic;  Q : out std_logic);
   end component;
   
   component AOI220
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component OAI310
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component AOI210
      port( A, B, C : in std_logic;  Q : out std_logic);
   end component;
   
   component NAND20
      port( A, B : in std_logic;  Q : out std_logic);
   end component;
   
   component OAI220
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component NAND40
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component NAND30
      port( A, B, C : in std_logic;  Q : out std_logic);
   end component;
   
   component XNR20
      port( A, B : in std_logic;  Q : out std_logic);
   end component;
   
   signal switch_port, command_1_port, command_0_port, state_reg_3_q, 
      state_reg_2_q, state_reg_1_q, state_reg_0_q, state_reg_3_d, state_reg_2_d
      , state_reg_1_d, state_reg_0_d, n432, n433, n434, n435, n436, n437, n438,
      n439, n440, n441, n442, n443, n444, n445, n446, n447, n448, n449, n450, 
      n451, n452, n453, n454, n455, n456, n457, n458, n459, n460, n461, n462, 
      n463, n464, n465, n466, n467, n468, n469, n470, n471, n472, n473, n474, 
      n475, n476, n477, n478, n479, n480, n481, n482, n483, n484, n485, n486, 
      n487 : std_logic;

begin
   switch_port <= Switches_to_std_logic(switch);
   (command_1_port, command_0_port) <= Commands_to_std_logic_vector(command);
   
   state_reg_0_label : DFC1 port map( C => clk, D => state_reg_0_d, RN => n432,
                           Q => state_reg_0_q, QN => n433);
   state_reg_1_label : DFC1 port map( C => clk, D => state_reg_1_d, RN => n432,
                           Q => state_reg_1_q, QN => n434);
   state_reg_2_label : DFC1 port map( C => clk, D => state_reg_2_d, RN => n432,
                           Q => state_reg_2_q, QN => n435);
   state_reg_3_label : DFC1 port map( C => clk, D => state_reg_3_d, RN => n432,
                           Q => state_reg_3_q, QN => n436);
   U457 : OAI210 port map( A => state_reg_1_q, B => n437, C => n438, Q => 
                           state_reg_3_d);
   U458 : AOI310 port map( A => state_reg_3_q, B => n439, C => n440, D => n441,
                           Q => n438);
   U459 : CLKIN0 port map( A => n442, Q => n441);
   U460 : OAI2110 port map( A => bad_encryption, B => n443, C => switch_port, D
                           => n444, Q => n442);
   U461 : NOR20 port map( A => n434, B => n445, Q => n443);
   U462 : IMUX20 port map( A => state_reg_1_q, B => reached_top, S => n433, Q 
                           => n440);
   U463 : AOI220 port map( A => n446, B => n447, C => ACSC, D => n448, Q => 
                           n437);
   U464 : CLKIN0 port map( A => n449, Q => n448);
   U465 : OAI310 port map( A => n445, B => state_reg_3_q, C => reached_bottom, 
                           D => n450, Q => n447);
   U466 : CLKIN0 port map( A => n451, Q => state_reg_2_d);
   U467 : AOI210 port map( A => n452, B => switch_port, C => n453, Q => n451);
   U468 : NAND20 port map( A => n454, B => n455, Q => n452);
   U469 : OAI210 port map( A => n449, B => n434, C => n456, Q => state_reg_1_d)
                           ;
   U470 : AOI220 port map( A => n446, B => n457, C => switch_port, D => n458, Q
                           => n456);
   U471 : OAI2110 port map( A => n459, B => n434, C => n460, D => n461, Q => 
                           n458);
   U472 : NAND20 port map( A => bad_encryption, B => n462, Q => n461);
   U473 : OAI210 port map( A => state_reg_1_q, B => n433, C => n435, Q => n460)
                           ;
   U474 : OAI220 port map( A => state_reg_3_q, B => n450, C => ACSC, D => n463,
                           Q => n457);
   U475 : NOR20 port map( A => state_reg_3_q, B => n446, Q => n449);
   U476 : NAND40 port map( A => n464, B => n465, C => n466, D => n467, Q => 
                           state_reg_0_d);
   U477 : NAND20 port map( A => ACSC, B => n453, Q => n467);
   U478 : OAI210 port map( A => state_reg_1_q, B => n436, C => n468, Q => n453)
                           ;
   U479 : AOI220 port map( A => state_reg_1_q, B => n469, C => n470, D => n435,
                           Q => n466);
   U480 : OAI210 port map( A => aes_key, B => n471, C => switch_port, Q => n470
                           );
   U481 : OAI210 port map( A => n455, B => n472, C => n468, Q => n469);
   U482 : CLKIN0 port map( A => command_0_port, Q => n472);
   U483 : IMUX20 port map( A => n473, B => n474, S => n433, Q => n465);
   U484 : CLKIN0 port map( A => n475, Q => n474);
   U485 : NAND30 port map( A => state_reg_3_q, B => n439, C => reached_top, Q 
                           => n475);
   U486 : OAI210 port map( A => switch_port, B => state_reg_3_q, C => n476, Q 
                           => n473);
   U487 : AOI220 port map( A => n477, B => n434, C => n462, D => n478, Q => 
                           n476);
   U488 : OAI220 port map( A => command_1_port, B => n435, C => command_0_port,
                           D => n455, Q => n477);
   U489 : CLKIN0 port map( A => n479, Q => n464);
   U490 : OAI220 port map( A => n468, B => n463, C => n450, D => n455, Q => 
                           n479);
   U491 : CLKIN0 port map( A => bad_encryption, Q => n450);
   U492 : AOI210 port map( A => n436, B => reached_bottom, C => bad_encryption,
                           Q => n463);
   U493 : OAI220 port map( A => state_reg_0_q, B => n436, C => n445, D => n480,
                           Q => open_light);
   U494 : IMUX20 port map( A => n444, B => n481, S => n434, Q => n480);
   U495 : OAI220 port map( A => ACSC, B => n436, C => reached_bottom, D => n468
                           , Q => n481);
   U496 : CLKIN0 port map( A => n459, Q => n445);
   U497 : NOR20 port map( A => n478, B => command_0_port, Q => n459);
   U498 : CLKIN0 port map( A => reset, Q => n432);
   U499 : OAI310 port map( A => n482, B => state_reg_2_q, C => n471, D => n483,
                           Q => key_led);
   U500 : NAND20 port map( A => state_reg_1_q, B => n484, Q => n483);
   U501 : OAI210 port map( A => n485, B => n468, C => n436, Q => n484);
   U502 : CLKIN0 port map( A => n446, Q => n468);
   U503 : NOR20 port map( A => n435, B => state_reg_0_q, Q => n446);
   U504 : AOI210 port map( A => command_0_port, B => n478, C => timeout, Q => 
                           n485);
   U505 : CLKIN0 port map( A => command_1_port, Q => n478);
   U506 : XNR20 port map( A => n434, B => state_reg_0_q, Q => n471);
   U507 : CLKIN0 port map( A => aes_key, Q => n482);
   U508 : NOR20 port map( A => n486, B => n439, Q => close_light);
   U509 : NAND20 port map( A => command_0_port, B => command_1_port, Q => n439)
                           ;
   U510 : AOI220 port map( A => n444, B => n434, C => state_reg_3_q, D => n487,
                           Q => n486);
   U511 : OAI210 port map( A => state_reg_1_q, B => ACSC, C => state_reg_0_q, Q
                           => n487);
   U512 : NOR20 port map( A => n433, B => n455, Q => n444);
   U513 : CLKIN0 port map( A => n462, Q => n455);
   U514 : NOR20 port map( A => n435, B => state_reg_3_q, Q => n462);
   U515 : NOR20 port map( A => state_reg_2_q, B => n454, Q => 
                           authentication_led);
   U516 : NAND30 port map( A => state_reg_1_q, B => n433, C => authentication, 
                           Q => n454);

end SYN_Garage;
