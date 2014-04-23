library IEEE;
use IEEE.std_logic_1164.all;

library LIB_CGARAGE;
use LIB_CGARAGE.CONV_PACK_Crypto_garage.all;


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
   
   component OAI2110
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component AOI220
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component OAI220
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component AOI210
      port( A, B, C : in std_logic;  Q : out std_logic);
   end component;
   
   component OAI210
      port( A, B, C : in std_logic;  Q : out std_logic);
   end component;
   
   component NOR20
      port( A, B : in std_logic;  Q : out std_logic);
   end component;
   
   component OAI310
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component NAND30
      port( A, B, C : in std_logic;  Q : out std_logic);
   end component;
   
   component NAND20
      port( A, B : in std_logic;  Q : out std_logic);
   end component;
   
   component CLKIN0
      port( A : in std_logic;  Q : out std_logic);
   end component;
   
   component NOR30
      port( A, B, C : in std_logic;  Q : out std_logic);
   end component;
   
   component AOI310
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component NAND40
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   component IMUX20
      port( A, B, S : in std_logic;  Q : out std_logic);
   end component;
   
   component MUX21
      port( A, B, S : in std_logic;  Q : out std_logic);
   end component;
   
   component NOR40
      port( A, B, C, D : in std_logic;  Q : out std_logic);
   end component;
   
   signal switch_port, command_1_port, command_0_port, state_reg_3_q, 
      state_reg_2_q, state_reg_1_q, state_reg_0_q, state_reg_3_d, state_reg_2_d
      , state_reg_1_d, state_reg_0_d, authentication_led_port, n305, n306, n307
      , n308, n309, n310, n311, n312, n313, n314, n315, n316, n317, n318, n319,
      n320, n321, n322, n323, n324, n325, n326, n327, n328, n329, n330, n331, 
      n332, n333, n334, n335, n336, n337, n338, n339, n340, n341, n342, n343, 
      n344, n345, n346, n347, n348, n349, n350, n351, n352, n353, n354, n355, 
      n356, n357, n358, n359, n360, n361, n362, n363, n364, n365, n366, n367 : 
      std_logic;

begin
   switch_port <= Switches_to_std_logic(switch);
   (command_1_port, command_0_port) <= Commands_to_std_logic_vector(command);
   authentication_led <= authentication_led_port;
   
   state_reg_0_label : DFC1 port map( C => clk, D => state_reg_0_d, RN => n305,
                           Q => state_reg_0_q, QN => n306);
   state_reg_1_label : DFC1 port map( C => clk, D => state_reg_1_d, RN => n305,
                           Q => state_reg_1_q, QN => n307);
   state_reg_2_label : DFC1 port map( C => clk, D => state_reg_2_d, RN => n305,
                           Q => state_reg_2_q, QN => n309);
   state_reg_3_label : DFC1 port map( C => clk, D => state_reg_3_d, RN => n305,
                           Q => state_reg_3_q, QN => n308);
   U310 : OAI2110 port map( A => n310, B => n311, C => n312, D => n313, Q => 
                           state_reg_3_d);
   U311 : AOI220 port map( A => state_reg_3_q, B => n314, C => n315, D => 
                           switch_port, Q => n313);
   U312 : OAI220 port map( A => n316, B => n306, C => state_reg_1_q, D => n317,
                           Q => n314);
   U313 : AOI210 port map( A => n318, B => n319, C => ACSC, Q => n317);
   U314 : OAI210 port map( A => n320, B => ACSC, C => n321, Q => n312);
   U315 : NOR20 port map( A => n322, B => n323, Q => n310);
   U316 : OAI310 port map( A => n324, B => n309, C => n307, D => n325, Q => 
                           n323);
   U317 : OAI2110 port map( A => n326, B => n324, C => n327, D => n328, Q => 
                           state_reg_2_d);
   U318 : OAI210 port map( A => n329, B => n330, C => n331, Q => n327);
   U319 : AOI210 port map( A => n332, B => n333, C => n308, Q => n330);
   U320 : NAND30 port map( A => n311, B => n307, C => n334, Q => n333);
   U321 : NAND20 port map( A => n316, B => state_reg_0_q, Q => n332);
   U322 : CLKIN0 port map( A => n318, Q => n316);
   U323 : NOR30 port map( A => n335, B => bad_encryption, C => n320, Q => n329)
                           ;
   U324 : AOI310 port map( A => n336, B => n311, C => state_reg_2_q, D => 
                           authentication_led_port, Q => n326);
   U325 : OAI210 port map( A => state_reg_1_q, B => n337, C => state_reg_0_q, Q
                           => n336);
   U326 : OAI2110 port map( A => n338, B => n324, C => n339, D => n340, Q => 
                           state_reg_1_d);
   U327 : AOI220 port map( A => state_reg_3_q, B => n341, C => bad_encryption, 
                           D => n322, Q => n340);
   U328 : OAI210 port map( A => n342, B => n324, C => n335, Q => n322);
   U329 : OAI210 port map( A => ACSC, B => n343, C => n307, Q => n341);
   U330 : AOI210 port map( A => bad_encryption, B => n306, C => n334, Q => n343
                           );
   U331 : OAI210 port map( A => state_reg_0_q, B => n319, C => n318, Q => n334)
                           ;
   U332 : CLKIN0 port map( A => reached_top, Q => n319);
   U333 : NAND40 port map( A => n321, B => n344, C => n331, D => n345, Q => 
                           n339);
   U334 : CLKIN0 port map( A => switch_port, Q => n324);
   U335 : AOI210 port map( A => n346, B => n306, C => n347, Q => n338);
   U336 : OAI210 port map( A => state_reg_3_q, B => state_reg_2_q, C => n307, Q
                           => n346);
   U337 : NAND40 port map( A => n348, B => n349, C => n350, D => n351, Q => 
                           state_reg_0_d);
   U338 : OAI310 port map( A => n352, B => n353, C => n354, D => n311, Q => 
                           n351);
   U339 : CLKIN0 port map( A => bad_encryption, Q => n311);
   U340 : AOI210 port map( A => n308, B => n309, C => n318, Q => n354);
   U341 : AOI210 port map( A => n345, B => n331, C => n335, Q => n353);
   U342 : CLKIN0 port map( A => n321, Q => n335);
   U343 : NOR20 port map( A => n307, B => n342, Q => n321);
   U344 : CLKIN0 port map( A => reached_bottom, Q => n345);
   U345 : NOR20 port map( A => command_1_port, B => n342, Q => n352);
   U346 : AOI210 port map( A => n347, B => state_reg_0_q, C => n355, Q => n350)
                           ;
   U347 : NOR30 port map( A => authentication, B => state_reg_2_q, C => n307, Q
                           => n347);
   U348 : IMUX20 port map( A => n356, B => n357, S => n308, Q => n348);
   U349 : AOI210 port map( A => state_reg_1_q, B => n358, C => switch_port, Q 
                           => n357);
   U350 : OAI210 port map( A => n337, B => n306, C => n331, Q => n356);
   U351 : CLKIN0 port map( A => ACSC, Q => n331);
   U352 : NAND30 port map( A => n359, B => n325, C => n360, Q => open_light);
   U353 : AOI220 port map( A => n361, B => n337, C => n320, D => n358, Q => 
                           n360);
   U354 : NOR20 port map( A => n344, B => reached_bottom, Q => n320);
   U355 : CLKIN0 port map( A => n315, Q => n359);
   U356 : NOR30 port map( A => n342, B => state_reg_1_q, C => n344, Q => n315);
   U357 : CLKIN0 port map( A => n337, Q => n344);
   U358 : NOR20 port map( A => n362, B => command_0_port, Q => n337);
   U359 : CLKIN0 port map( A => n358, Q => n342);
   U360 : NOR20 port map( A => n309, B => n306, Q => n358);
   U361 : CLKIN0 port map( A => reset, Q => n305);
   U362 : OAI210 port map( A => n363, B => n328, C => n349, Q => key_led);
   U363 : MUX21 port map( A => n307, B => n364, S => n308, Q => n349);
   U364 : NAND30 port map( A => n306, B => n309, C => aes_key, Q => n364);
   U365 : CLKIN0 port map( A => n355, Q => n328);
   U366 : NOR30 port map( A => state_reg_0_q, B => state_reg_1_q, C => n309, Q 
                           => n355);
   U367 : AOI210 port map( A => command_0_port, B => n362, C => timeout, Q => 
                           n363);
   U368 : CLKIN0 port map( A => command_1_port, Q => n362);
   U369 : AOI310 port map( A => n365, B => n325, C => n366, D => n318, Q => 
                           close_light);
   U370 : NAND20 port map( A => command_0_port, B => command_1_port, Q => n318)
                           ;
   U371 : NAND30 port map( A => state_reg_2_q, B => n306, C => state_reg_1_q, Q
                           => n366);
   U372 : NAND30 port map( A => n306, B => n307, C => state_reg_3_q, Q => n325)
                           ;
   U373 : CLKIN0 port map( A => n361, Q => n365);
   U374 : NOR30 port map( A => n306, B => ACSC, C => n308, Q => n361);
   U375 : NOR40 port map( A => n367, B => n307, C => n306, D => state_reg_2_q, 
                           Q => authentication_led_port);
   U376 : CLKIN0 port map( A => authentication, Q => n367);

end SYN_Garage;
