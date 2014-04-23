package Garage_types is
  
  type Switches is (die, juice); -- interruptuer arret/marche
  -- commandes pour la porte du garage:
  
  type Commands is (no_command, deactivate, d_open, d_close);
  
  -- etats de l'automate:
  type States is (PowerUp, PowerDown, NoKey, Deactivated, Activated, Down,
                  Up, MovingOnDown, MovingOnUp, SafetyError, SecurityError);
  
  -- a l'origine la porte est fermee (true) ou ouverte (false)
  constant init_closed: boolean:= true;
end Garage_types;
