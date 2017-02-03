module dead_world;

import std.stdio;
import std.math;
import std.random;
import dbg;
import game;
import world;
import player;
import commoner;
import dead_dirt;
import dead_stone_wall;
import kernel_portal;
import agent;
import area;
import vector;
import wall;
import timer;

Timer test_timer;

/*
  The world the player goes to after dying but before reviving in the entry world
*/
class Dead_world : World {
  static bool type_initialized = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      Dead_dirt_1.initialize_type;
      Dead_stone_wall_1.initialize_type;
      Kernel_portal_1.initialize_type;
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
            if(uniform(0.0f, 100.0f) < 10.0f)
              add_ground(new Dead_dirt_1(Vector2f(x, y)));
            else
              add_wall(new Dead_stone_wall_1(Vector2f(x, y)));
          }
        }
        else {
          float prob = uniform(0.0f, 100.0f)*sqrt(x*x + y*y);
          if(prob < 400.0f){
            add_ground(new Dead_dirt_1(Vector2f(x, y)));
          }
          else {
            add_wall(new Dead_stone_wall_1(Vector2f(x, y)));
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
      Kernel_portal_1 portal = new Kernel_portal_1;
      portal.position = Vector2f(0, 5);
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
            area.set_wall = new Dead_stone_wall_1(adj_pos);
          }
        }
      }
    }
    center_area = new_area(position.floor);
    center_area.set_ground = new Dead_dirt_1(center_area.position);
    return center_area;
  }
  
}