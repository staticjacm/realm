module kernel;

import std.stdio;
import std.random;
import game;
import world;
import player;
import commoner;
import grass_1;
import matted_grass_1;
import dirt_1;
import sand_1;
import grass_with_flowers_1;
import rocky_ground_1;
import stone_ground_1;
import portal_carpet_1;
import fountain_water_1;
import kernel_house_tall_1;
import kernel_house_short_1;
import blank_impassable;
import stone_wall_1;
import brick_path_1;
import makeshift_brick_path_1;
import fountain_wall_1;
import red_carpet_1;
import white_fence_1;
import stability_boundary_1;
import agent;
import area;
import vector;
import wall;
import timer;
import cactus1;
import fireball1;
import twinkle1;

Timer test_timer;

Tmr[] tilemap_data = mixin(import("kernel_tilemap_data.txt"));

class Kernel : World {
  static bool type_initialized    = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
    }
  }
  
  this(){
    int r = 100;
    int R = 125;
    // float rsqr = r*r;
    // Set the boundary to deep water walls
    for(float x = -R; x < R; x += 1.0f){
      for(float y = -R; y < R; y += 1.0f){
        if(x*x + y*y >= r*r){
          Area area = new_area!"careless"(Vector2f(x, y));
          // area.set_wall = new Deep_water_1
        }
        else {
          // area.set_ground = new Shallow_water_1
        }
      }
    }
  }
  
  override void update(){
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
            area.set_ground = new Rocky_ground_1(adj_pos);
            if(uniform(0, 100) < 60)
              area.set_wall = new Cactus1(adj_pos);
          }
        }
      }
    }
    center_area = new_area(position.floor);
    center_area.set_ground = new Rocky_ground_1(center_area.position);
    return center_area;
  }
  
}