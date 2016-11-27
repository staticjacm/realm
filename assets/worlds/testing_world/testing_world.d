module testing_world;

import std.stdio;
import world;
import player;
import commoner;
import rocky_ground;
import agent;
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
    float R = 50;
    for(int x = 0; x < R; x++){
      for(int y = 0; y < R; y++){
        add_ground(new Rocky_ground(Vector2f(x, y)));
      }
    }
    for(int x = 0; x < R; x++){
      int y = 0;
      add_wall(new Cactus1(Vector2f(x, y)));
    }
    for(int x = 0; x < R; x++){
      int y = cast(int)(R-1);
      add_wall(new Cactus1(Vector2f(x, y)));
    }
    for(int y = 0; y < R; y++){
      int x = 0;
      add_wall(new Cactus1(Vector2f(x, y)));
    }
    for(int y = 0; y < R; y++){
      int x = cast(int)(R-1);
      add_wall(new Cactus1(Vector2f(x, y)));
    }
    place_agent(player_entity);
    
    Agent collider_entity = new Commoner(Vector2f(13, 13), 1);
    collider_entity.world = this;
    place_agent(collider_entity);
  }
  
}