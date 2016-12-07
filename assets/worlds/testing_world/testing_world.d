module testing_world;

import std.stdio;
import std.random;
import game;
import world;
import player;
import commoner;
import rocky_ground;
import agent;
import area;
import wall;
import timer;
import cactus1;
import fireball1;

Timer test_timer;

class Testing_world : World {
  static bool type_initialized = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      Rocky_ground.initialize_type;
      Cactus1.initialize_type;
      Fireball1.initialize_type;
    }
  }
  
  float spawn_timer = 0;
  
  override void generate_area(Area area){
    area.set_ground = new Rocky_ground(area.position);
  }
  override bool generate_adjacent_areas(){ return true; }
  
  override void generate_adjacent_area(Area area){
    area.set_ground = new Rocky_ground(area.position);
    if(uniform(0, 100) < 10)
      area.set_wall = new Cactus1(area.position);
  }
  
  this(){
    float R = 20;
    for(int x = 0; x < R; x++){
      for(int y = 0; y < R; y++){
        add_ground(new Rocky_ground(Vector2f(x, y)));
      }
    }
    
    //for(int x = 0; x < R; x++){
    //  int y = 0;
    //  Wall new_wall;
    //  new_wall = new Cactus1(Vector2f(x, y));
    //  new_wall.set_updating = true;
    //  add_wall(new_wall);
    //}
    for(int x = 0; x < R; x++){
      int y = cast(int)(R-1);
      Wall new_wall;
      new_wall = new Cactus1(Vector2f(x, y));
      new_wall.set_updating = true;
      add_wall(new_wall);
    }
    for(int y = 0; y < R; y++){
      int x = 0;
      Wall new_wall;
      new_wall = new Cactus1(Vector2f(x, y));
      new_wall.set_updating = true;
      add_wall(new_wall);
    }
    for(int y = 0; y < R; y++){
      int x = cast(int)(R-1);
      Wall new_wall;
      new_wall = new Cactus1(Vector2f(x, y));
      new_wall.set_updating = true;
      add_wall(new_wall);
    }
    place_agent(player_entity);
    
    Agent collider_entity = new Commoner(Vector2f(13, 13), 1);
    collider_entity.world = this;
    place_agent(collider_entity);
  }
  
  override void update(){
    super.update;
    if(spawn_timer <= 0){
      Fireball1 fireball = new Fireball1(Vector2f(10,10), 1);
      fireball.world = this;
      fireball.set_velocity = Vector2f(10.0, 0.0);
      spawn_timer += 0.5f;
    }
    else {
      spawn_timer -= frame_delta;
    }
  }
  
}