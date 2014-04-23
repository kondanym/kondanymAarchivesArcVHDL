LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY LIB_CGARAGE;
-- USE LIB_CGARAGE.Garage_types.all;
use LIB_CGARAGE.CONV_PACK_Crypto_garage.all;

--library c35_CORELIB;
--use c35_CORELIB.vcomponents.all;


entity testGarage is 
end testGarage;

architecture test of testGarage is 
  component Crypto_garage 
    
  port(reset, clk, aes_key, authentication, reached_bottom, reached_top, ACSC, 
       bad_encryption, timeout: in std_logic;   
       switch: in Switches;
       command: in Commands;
       key_led, authentication_led, open_light, close_light: out std_logic);
  end component;

  signal switch_t : Switches := juice;
  signal command_t : Commands := no_command;

  signal reset_t, clk_t, aes_key_t, authentication_t, reached_bottom_t, 
         reached_top_t, ACSC_t, bad_encryption_t, timeout_t,
         key_led_t, authentication_led_t, open_light_t, close_light_t,
         key_led_b, authentication_led_b, open_light_b, close_light_b: std_logic:='0';
         --signaux avec t pour robot, b pour syn


begin 

       G1: Crypto_garage port map (reset_t, clk_t, aes_key_t, authentication_t, reached_bottom_t, reached_top_t, ACSC_t, 
       bad_encryption_t, timeout_t, switch_t, command_t, key_led_t, authentication_led_t, open_light_t, close_light_t);
     
       G2: Crypto_garage port map (reset_t, clk_t, aes_key_t, authentication_t, reached_bottom_t, reached_top_t, ACSC_t, 
       bad_encryption_t, timeout_t, switch_t, command_t, key_led_b, authentication_led_b, open_light_b, close_light_b);

       clk_t <= not clk_t after 10 ns;
       reset_t <= '1' after 1 ns, '0' after 20 ns;
       command_t <= no_command after 18 ns, deactivate after 25 ns, d_open after 300 ns, d_close after 315 ns, d_open after 395 ns;

       switch_t<= die after 18 ns, juice after 35 ns;
       aes_key_t <= '1' after 250 ns;
       authentication_t <= '1' after 78 ns;
       reached_bottom_t <= '1' after 175 ns, '0' after 197 ns;
       reached_top_t <= '1' after 197 ns;
       ACSC_t <= '1' after 218 ns, '0' after 248 ns;
       bad_encryption_t <= '1' after 255 ns, '0' after 355 ns;
       timeout_t <= '1' after 255 ns, '0' after 278 ns;

end test;

library LIB_CGARAGE;
--USE LIB_CGARAGE.Garage_types.all;
-- library LIB_CGARAGE_BENCH;
use LIB_CGARAGE.CONV_PACK_Crypto_garage.all;

configuration Config1 of testGarage is 
  for test 
    for G1: Crypto_garage use entity LIB_CGARAGE.Crypto_garage(Garage);
    end for;
    for G2: Crypto_garage use entity LIB_CGARAGE.Crypto_garage(SYN_Garage);
    end for;
 end for;
end Config1;


