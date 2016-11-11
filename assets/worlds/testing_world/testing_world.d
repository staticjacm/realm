module testing_world;

import world;
import player;
import commoner;
import physical;
import rocky_ground;

class Testing_world : World {
  
  this(){
    for(int x = 0; x < 10; x++){
      for(int y = 0; y < 10; y++){
        Physical ground = new rocky_ground(Vector2f(x, y), 0); 
        set(ground)
      }
    }
  }
  
}