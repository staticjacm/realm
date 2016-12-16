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
import vector;
import wall;
import timer;
import cactus1;
import fireball1;
import twinkle1;

Timer test_timer;

class Testing_world : World {
  static bool type_initialized = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      Rocky_ground.initialize_type;
      Cactus1.initialize_type;
      Fireball1.initialize_type;
      Twinkle1.initialize_type;
    }
  }
  
  float spawn_next_time = 0;
  float spawn_delay = 300;
  
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
    
    Agent collider_entity = new Commoner;
    collider_entity.position = Vector2f(13, 13);
    collider_entity.faction_id = 1;
    collider_entity.world = this;
    place_agent(collider_entity);
  }
  
  override void update(){
    super.update;
    // if(spawn_next_time < game_time){
      // spawn_next_time = game_time + spawn_delay;
      // Fireball1 fireball = new Fireball1;
      // fireball.position = Vector2f(10, 10);
      // fireball.world = this;
      // fireball.set_velocity = Vector2f(10.0, 0.0);
    // }
      Twinkle1 twinkle = new Twinkle1;
      twinkle.position = Vector2f(9, 10) + rvector(1.0);
      place_decoration(twinkle);
  }
  
  override Area generate_area(Vector2f position){
    Area center_area;
    for(int x = -2; x <= 2; x++){
      for(int y = -2; y <= 2; y++){
        if(x != 0 || y != 0){
          Vector2f adj_pos = (position + Vector2f(x, y)).floor;
          Area area = get_area(adj_pos);
          if(area is null){
            area = new_area!"careless"(adj_pos);
            area.set_ground = new Rocky_ground(adj_pos);
            if(uniform(0, 100) < 60)
              area.set_wall = new Cactus1(adj_pos);
          }
        }
      }
    }
    center_area = new_area(position.floor);
    center_area.set_ground = new Rocky_ground(center_area.position);
    return center_area;
  }
  
}