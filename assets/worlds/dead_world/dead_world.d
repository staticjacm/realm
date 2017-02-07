module dead_world;

import std.stdio;
import std.math;
import std.random;
import dbg;
import make;
import game;
import world;
import player;
import portal;
import ground;
import agent;
import area;
import vector;
import wall;
import timer;
import entry_world;

Timer test_timer;

/*
  The world the player goes to after dying but before reviving in the entry world
*/
class Dead_world_1 : World {
  static bool type_initialized = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      make.initialize_type!"Dead_dirt_1";
      make.initialize_type!"Dead_stone_wall_1";
      make.initialize_type!"Entry_world_1";
      make.initialize_type!"Kernel_portal_1";
    }
  }
  
  float portal_spawn_time = 0;
  float portal_spawn_delay = 5 * 1000;
  bool portal_placed = false;
  
  this(){
    // float R = 20;
    
    float R = 20.0f;
    float r = 10.0f;
    for(float x = -R; x < R; x++){
      for(float y = -R; y < R; y++){
        if( (x < -r) || (r < x) || (y < -r) || (r < y) ){
          if(uniform(0.0f, 100.0f)*sqrt(x*x + y*y) < 100.0f){
            if(uniform(0.0f, 100.0f) < 10.0f){
              Ground ground = make_ground!"Dead_dirt_1";
              ground.set_position(Vector2f(x, y));
              add_ground(ground);
            }
            else {
              Wall wall = make_wall!"Dead_stone_wall_1";
              wall.set_position(Vector2f(x, y));
              add_wall(wall);
            }
          }
        }
        else {
          float prob = uniform(0.0f, 100.0f)*sqrt(x*x + y*y);
          if(prob < 400.0f){
            Ground ground = make_ground!"Dead_dirt_1";
            ground.set_position(Vector2f(x, y));
            add_ground(ground);
          }
          else {
            Wall wall = make_wall!"Dead_stone_wall_1";
            wall.set_position(Vector2f(x, y));
            add_wall(wall);
          }
        }
      }
    }
    
    portal_spawn_time = game_time + portal_spawn_delay;
  }
  
  override string name(){ return "..."; }
  override string description(){ return "Game over"; }
  override string standard_article(){ return ""; }
  
  override void update(){
    if(!portal_placed && portal_spawn_time < game_time){
      portal_placed = true;
      Portal portal = make_portal!"Kernel_portal_1";
      portal.position = Vector2f(0, 5);
      portal.exit_world = game.entry;
      portal.exit_position = Entry_world_1.spawn_location;
      place_agent(portal);
    }
    super.update;
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
            Wall wall = make_wall!"Dead_stone_wall_1";
            wall.set_position(Vector2f(x, y));
            area.set_wall = wall;
          }
        }
      }
    }
    center_area = new_area(position.floor);
    Ground ground = make_ground!"Dead_dirt_1";
    ground.set_position(position);
    center_area.set_ground = ground;
    return center_area;
  }
  
}