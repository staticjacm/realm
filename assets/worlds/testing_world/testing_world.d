module testing_world;

import std.stdio;
import world;
import player;
import commoner;
import rocky_ground;
import cactus1;

class Testing_world : World {
  static bool type_initialized = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      Rocky_ground.initialize_type;
      Cactus1.initialize_type;
    }
  }
  
  this(){
    for(int x = 0; x < 30; x++){
      for(int y = 0; y < 30; y++){
        add_ground(new Rocky_ground(Vector2f(x, y)));
      }
    }
    for(int x = 0; x < 30; x++){
      int y = 0;
      add_wall(new Cactus1(Vector2f(x, y)));
    }
    for(int x = 0; x < 30; x++){
      int y = 29;
      add_wall(new Cactus1(Vector2f(x, y)));
    }
    for(int y = 0; y < 30; y++){
      int x = 0;
      add_wall(new Cactus1(Vector2f(x, y)));
    }
    for(int y = 0; y < 30; y++){
      int x = 30;
      add_wall(new Cactus1(Vector2f(x, y)));
    }
    place_agent(player_entity);
  }
  
}