
LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE work.Garage_types.ALL;

LIBRARY LIB_CGARAGE;
use LIB_CGARAGE.CONV_PACK_Crypto_garage.all;






entity Crypto_garage is 
  
  port (reset, clk, aes_key, authentication, reached_bottom, reached_top, ACSC, 
        bad_encryption, timeout: in std_logic;
        switch: in Switches;
        command: in Commands;
        key_led, authentication_led, open_light, close_light: out std_logic;

	LEDR: out std_logic_vector(9 downto 0); --pour leds rouges
	seg_val_hex3: out INTEGER range 0 to 127; --pour affichage "command"
	LEDR: out std_logic_vector(7 downto 0);	-- pour leds vertes
	seg_val_hex0: out INTEGER range 0 to 127; --pour affichage etat 
	seg_val_hex1: out INTEGER range 0 to 127; --pour affichage etat
       );
  end Crypto_garage;

Architecture Garage of Crypto_garage is

attribute chip_pin: string ;
attribute chip_pin of reset : signal is "R22"; -- bouton poussior de droite 
attribute chip_pin of clk : signal is "L1"; -- 50 MHz internal quartz

-- attribute de entrees aux switches (par ex ici de ganche a droite):
attribute chip_pin of aes_key : signal is "M2";
attribute chip_pin of authentication : signal is "U11";
attribute chip_pin of reache _bottom : signal is "U12";
attribute chip_pin of reached_top : signal is "W22";
attribute chip_pin of ACSC : signal is "V12";
attribute chip_pin of bad_encryption : signal is "M22";
attribute chip_pin of timeout : signal is "L21";
attribute chip_pin of switch : signal is "L22";

-- descriptif des afficheurs 7 segments :
attribute chip_pin of seg_val_hex0 : signal is "J2, J1, H2, H1, F2, F1, E2";
attribute chip_pin of seg_val_hex1 : signal is "E1, H6, H5, H4, G3, D2, D1";
attribute chip_pin of seg_val_hex3 : signal is "F4, D5, D6, J4, L8, F3, D4";

-- attribution des sortie LEDR et LEDG aux leds 
attribute chip_pin of LEDR : signal is "R17, R18, U18, Y18, V19, T18, Y19 U19, R19, R20";
attribute chip_pin of LEDR : signal is "Y21, Y22, W21, W22, V21, V22, U21, U22";


seg_val_hex0 <= 2#0000001#; --0
seg_val_hex0 <= 2#1001111#; --1
seg_val_hex0 <= 2#0010010#; --2
seg_val_hex0 <= 2#0000110#; --3
seg_val_hex0 <= 2#1001100#; --4
seg_val_hex0 <= 2#0100100#; --5
seg_val_hex0 <= 2#0100000#; --6
seg_val_hex0 <= 2#0001111#; --7
seg_val_hex0 <= 2#0000000#; --8
seg_val_hex0 <= 2#0000100#; --9




--etats de l'automate
type States is (PowerUp, PowerDown, NoKey, Deactivated, Activated, Down,
                Up, MovingOnDown, MovingOnUp, SafetyError, SecurityError);

signal state, nextstate: States;

-- PSL default clock is (clk'event and clk = '1');
-- PSL property assert1 is 
--     always ((state=PowerUp) or (state=PowerDown))->next(state/=Activated) until aes_key = '1';
-- PSL property assert2 is 
--     always ((state=PowerUp) or (state=PowerDown) or (state=SecurityError))->next(state/=Activated) until authentication='1';
-- PSL property assert3 is 
--     always(state=Down) -> ((open_light='1' )= ( (ACSC='0') and (bad_encryption = '0')and (command=d_open)))until state=Up; 
   
-- PSL assert assert1;
-- PSL assert assert2;
-- PSL assert assert3;

begin
--calcul de l'etat suivant
  process (state, aes_key, authentication, reached_bottom, reached_top, ACSC, 
           bad_encryption, timeout, switch, command)
  begin
    case state is
      when PowerUp => 
        if switch = die then nextstate <= PowerDown;
        elsif aes_key = '1' then nextstate <= Deactivated;
        else nextstate <= NoKey;
      end if;
      
      when Deactivated =>
        if switch = die then nextstate <= PowerDown;
        elsif authentication = '1' then nextstate <= Activated;  
        else nextstate <= state;
      end if;
    
      when Activated =>
        if init_closed = true then nextstate <= Down;
        elsif (command = deactivate or timeout = '1') then nextstate <= Deactivated;
        else nextstate <= Up;
      end if;
      
      when Down =>
        if switch = die then nextstate <= PowerDown;
        elsif bad_encryption = '1' then nextstate <= SecurityError;
        elsif command = d_open then nextstate <= MovingOnUp;
        else nextstate <= state;  
      end if;
      
      when MovingOnUp =>
        if ACSC = '1' then nextstate <= SafetyError;
        elsif bad_encryption = '1' then nextstate <= SecurityError;
        elsif command=d_close then nextstate<=MovingOnDown;
        elsif reached_top = '1' then nextstate <= Up;
        else nextstate <= state;
      end if;
        
      when Up => 
        if switch = die then nextstate <= PowerDown;
        elsif bad_encryption = '1' then nextstate <= SecurityError;
        elsif command = d_close then nextstate <= MovingOnDown;
	else nextstate <= state;
      end if;
  
      when MovingOnDown =>
        if bad_encryption = '1' then nextstate <= SecurityError;  
        elsif  ACSC = '1' then nextstate <= SafetyError;
        elsif reached_bottom = '1' then nextstate <= Down;
        elsif (command = d_open and reached_bottom = '0') then nextstate <= MovingOnUp;
	else nextstate <= state; 
      end if;
          
      when SafetyError =>
        if (ACSC = '0' and command = d_open) then nextstate <= MovingOnUp;
        elsif (ACSC = '0' and command = d_close) then nextstate <= MovingOnDown;
	else nextstate <= state;
       end if;

      when SecurityError => nextstate <= Deactivated;
        
      when Nokey =>
        if Switch = die then nextstate <= PowerDown;
        elsif aes_key = '1' then nextstate <= Deactivated;
	else nextstate <= state;
        end if;
      
      when PowerDown =>
        if switch = juice then nextstate <= PowerUp;
	else nextstate <= state;
        end if;
    end case;
   end process;

--Diviseur Quartz 50Mhz
process (clk)
	variable cnt : INTERGER RANGE 0 TO 67108863;
        constant verrou_t : INTEGER := 50000000;
begin 
   if (clk'EVENT AND clk = '1') then 
	if (reset = '0') or (cnt = verrou_t) then cnt := 0;
	else cnt := cnt + 1;
	end if;
   end if ;
  
   if (cnt = verrou_t) then ck_1Hz <= '1'; -- ck_1Hz signal local
   else ck_1Hz <= '0';
   end if ;

end process;                



-- mise a jour de l'etat
    --process (reset, clk)
        --begin       
      -- si reset asynchrone
           --if (reset = '1') then state <= PowerUp;
      -- si evenement de clk    
           --elsif (clk'event and clk = '1') then state <= nextstate;
        --end if;
    --end process;

-- mise a jour des sorties (process equivalent)
    
    process (state, authentication, aes_key, reached_bottom, reached_top, ACSC, 
             bad_encryption, timeout, switch, command)      
         begin
           if (state = Nokey) and (aes_key = '1') then key_led <= '1';
	   elsif(state = PowerUp) and (aes_key = '1') then key_led <= '1';
           elsif(state = SecurityError) then key_led <= '1';
           elsif(state = Activated) and (timeout = '1' or command = deactivate) then key_led <= '1';
           else key_led <= '0';
	   end if;

           if (state = Deactivated) and (authentication = '1') then authentication_led <= '1';
	   else authentication_led <= '0';
	   end if;

           if (state = Down) and (command = d_open and bad_encryption ='0') then open_light <= '1';
           elsif (state = SafetyError) and (ACSC = '0' and command = d_open) then open_light <= '1';
           elsif (state = MovingOnDown) and  (command = d_open) then open_light <= '1';    
           elsif (state = MovingOnUp) then open_light <= '1';
	   else open_light <= '0';
	   end if;

           if (state = SafetyError) and (ACSC = '0' and command = d_close) then close_light <= '1';
           elsif (state = MovingOnUp) and (command = d_close and reached_bottom='0') then close_light <= '1';
           elsif (state = Up) and (command = d_close) then close_light <= '1';
           elsif (state = MovingOnDown) then close_light <= '1';
	   else close_light <= '0';
	   end if;

    end process;

end Garage;

