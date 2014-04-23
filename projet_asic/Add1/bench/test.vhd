LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.std_logic_unsigned.all;
USE work.Garage_types.all;
USE IEEE.NUMERIC_STD.ALL;

library LIB_ADD1;
use LIB_ADD1.Garage_types.all;



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

  signal switch_t: Switches; 
  signal command_t: Commands;
  signal reset_t, clk_t, aes_key_t, authentication_t, reached_bottom_t, reached_top_t, ACSC_t, bad_encryption_t, timeout_t,          key_led_t, authentication_led_t, open_light_t, close_light_t: std_logic:='0';
       

 
--       for    G:Crypto_garage use entity work.Garage_types(Garage);

begin 

       G: Crypto_garage port map (reset_t, clk_t, aes_key_t, authentication_t, reached_bottom_t, reached_top_t, ACSC_t, 
       bad_encryption_t, timeout_t, switch_t, command_t, key_led_t, authentication_led_t, open_light_t, close_light_t);


       clk_t <= not clk_t after 10 ns;
       reset_t <= '1' after 20 ns, '0' after 40 ns;
       aes_key_t <= '1' after 500 ns;
       authentication_t <= '1' after 160 ns, '0' after 190 ns;
       reached_bottom_t <= '1' after 170 ns, '0' after 190 ns;
       reached_top_t <= '1' after 190 ns;
       ACSC_t <= '1' after 240 ns, '0' after 250 ns, '1' after 525 ns;

end test;



--library LIB_CGARAGE;
--library LIB_CGARAGE_BENCH;
--use LIB_CGARAGE.Crypto_garage.types.all;

--configuration Config1 of testGarage is 
--for test 
    --for G: Crypto_garage use entity work.Crypto_garage
    --end for;
--end for;
--end Config1;


library LIB_ADD1;
library LIB_ADD1_BENCH;

configuration config1 of LIB_ADD1_BENCH.testgarage is 
    for test1 
      	for G: Crypto_garage use entity LIB_ADD1.Crypto_garage(Automate);
       end for;
    end for; 
end config1; 



 

 
