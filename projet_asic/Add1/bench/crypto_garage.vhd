LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE work.Garage_types.all;
USE IEEE.NUMERIC_STD.ALL;


entity Crypto_garage is 
  
  port (reset, clk, aes_key, authentication, reached_bottom, reached_top, ACSC, 
        bad_encryption, timeout: in std_logic;
        
        switch: in Switches;
        command: in Commands;
        
        key_led, authentication_led, open_light, close_light: out std_logic);

  end Crypto_garage;



Architecture Garage of Crypto_garage is
--etats de l'automate
type States is (PowerUp, PowerDown, NoKey, Deactivated, Activated, Down,
                Up, MovingOnDown, MovingOnUp, SafetyError, SecurityError);

signal state, nextstate: States;



begin
-- calcul de l'etat suivant
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
        elsif (command = d_close and reached_top = '1') then nextstate <= Up;
        elsif (command = d_close and reached_top = '0') then nextstate <= Down;
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
        elsif (ACSC = '0' and command = d_open) then nextstate <= MovingOnDown;
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


        
-- mise a jour de l'etat
    process (reset, clk)
        begin       
      -- si reset asynchrone
           if (reset = '1') then state <= PowerUp;
      -- si evenement de clk    
           elsif (clk'event and clk = '1') then state <= nextstate;
        end if;
    end process;



-- mise a jour des sorties (process equivalent)
    
      process (state, authentication, aes_key, reached_bottom, reached_top, ACSC, 
         bad_encryption, timeout, switch, command)      
         begin
           if (state = Deactivated) and (aes_key = '1') then key_led <= '1';
	   else key_led <= '0';
	   end if;

           if (state = Activated) and (authentication = '1') then authentication_led <= '1';
	   else authentication_led <= '0';
	   end if;

           if (state = MovingOnUp and command = d_open) then open_light <= '1';
	   else open_light <= '0';
	   end if;

           if (state = MovingOnDown and command = d_close) then close_light <= '1';
	   else close_light <= '0';
	   end if;

     end process;
end Garage;
