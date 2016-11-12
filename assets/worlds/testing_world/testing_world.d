module testing_world;

import std.stdio;
import world;
import player;
import commoner;
import physical;
import rocky_ground;

class Testing_world : World {
  static bool type_initialized = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      Rocky_ground.initialize_type;
    }
  }
  
  this(){
    for(int x = 0; x < 10; x++){
      for(int y = 0; y < 10; y++){
        Physical ground = new Rocky_ground(Vector2f(x, y), 0); 
        add_stationary(ground);
      }
    }
  }
  
}