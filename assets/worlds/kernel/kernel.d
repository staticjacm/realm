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
  static Vector2f center_spawn    = Vector2f(150, 187);
  static Vector2f beach_portal    = Vector2f(37, 107);
  static Vector2f forest_portal   = Vector2f(150, 35);
  static Vector2f mountain_portal = Vector2f(266, 106);
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      Rocky_ground_1.initialize_type;
      Grass_1.initialize_type;
      Matted_grass_1.initialize_type;
      Makeshift_brick_path_1.initialize_type;
      Dirt_1.initialize_type;
      Sand_1.initialize_type;
      Grass_with_flowers_1.initialize_type;
      Kernel_house_short_1.initialize_type;
      Brick_path_1.initialize_type;
      Fountain_water_1.initialize_type;
      Fountain_wall_1.initialize_type;
      Blank_impassable.initialize_type;
      White_fence_1.initialize_type;
      Red_carpet_1.initialize_type;
      Kernel_house_tall_1.initialize_type;
      Portal_carpet_1.initialize_type;
      Stability_boundary_1.initialize_type;
      Stone_ground_1.initialize_type;
      Stone_wall_1.initialize_type;
      Cactus1.initialize_type;
      Fireball1.initialize_type;
      Twinkle1.initialize_type;
    }
  }
  
  float spawn_next_time = 0;
  float spawn_delay = 300;
  
  
  this(){
    float R = 20;
    
    /*
      (000, 255, 000) -> grass
      (042, 069, 000) -> damaged/matted grass
      (130, 074, 000) -> nice dirt
      (245, 235, 048) -> sand
      (124, 102, 094) -> rocky
      (119, 255, 000) -> grass with flowers
      (031, 058, 031) -> grass with tree decoration
      (104, 104, 104) -> stone wall
      (166, 166, 166) -> stone path
      (200, 134, 157) -> brick path
      (138, 080, 100) -> makeshift brick path
      (105, 215, 215) -> realm portal carpet
      (104, 091, 179) -> fountain water
      (067, 064, 090) -> fountain wall
      (177, 061, 086) -> red carpet
      (171, 040, 157) -> kernel house tall left
      (157, 171, 040) -> kernel house tall right
      (097, 021, 089) -> kernel house short left
      (105, 114, 027) -> kernel house short right
      (021, 081, 082) -> blank impassable
      (148, 120, 054) -> white fence horizontal
      (082, 066, 028) -> white fence corner upper-left
      (166, 143, 087) -> white fence vertical
      (186, 019, 164) -> kernel stability boundary
    */
    foreach(Tmr tmr; tilemap_data){
      if(tmr.r == 00 && tmr.g == 255 && tmr.b == 00){
        add_ground(new Grass_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 42 && tmr.g == 69 && tmr.b == 00){
        add_ground(new Matted_grass_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 130 && tmr.g == 74 && tmr.b == 00){
        add_ground(new Dirt_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 245 && tmr.g == 235 && tmr.b == 48){
        add_ground(new Sand_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 124 && tmr.g == 102 && tmr.b == 94){
        add_ground(new Rocky_ground_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 119 && tmr.g == 255 && tmr.b == 00){
        add_ground(new Grass_with_flowers_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 31 && tmr.g == 58 && tmr.b == 31){
        add_ground(new Grass_1(Vector2f(tmr.x, tmr.y)));
        /* Add tree decoration here */
      }
      else if(tmr.r == 104 && tmr.g == 104 && tmr.b == 104){
        add_ground(new Rocky_ground_1(Vector2f(tmr.x, tmr.y)));
        add_wall(new Stone_wall_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 166 && tmr.g == 166 && tmr.b == 166){
        add_ground(new Stone_ground_1(Vector2f(tmr.x, tmr.y), 0));
      }
      else if(tmr.r == 200 && tmr.g == 134 && tmr.b == 157){
        add_ground(new Brick_path_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 138 && tmr.g == 80 && tmr.b == 100){
        add_ground(new Makeshift_brick_path_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 42 && tmr.g == 69 && tmr.b == 00){
        add_ground(new Matted_grass_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 150 && tmr.g == 215 && tmr.b == 215){
        add_ground(new Portal_carpet_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 177 && tmr.g == 61 && tmr.b == 86){
        add_ground(new Red_carpet_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 104 && tmr.g == 91 && tmr.b == 179){
        add_ground(new Fountain_water_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 67 && tmr.g == 64 && tmr.b == 90){
        add_ground(new Fountain_wall_1(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 171 && tmr.g == 40 && tmr.b == 157){
        add_wall(new Kernel_house_tall_1(Vector2f(tmr.x, tmr.y), 0));
      }
      else if(tmr.r == 157 && tmr.g == 171 && tmr.b == 40){
        add_wall(new Kernel_house_tall_1(Vector2f(tmr.x, tmr.y), 1));
      }
      else if(tmr.r == 97 && tmr.g == 21 && tmr.b == 89){
        add_wall(new Kernel_house_short_1(Vector2f(tmr.x, tmr.y), 0));
      }
      else if(tmr.r == 105 && tmr.g == 114 && tmr.b == 27){
        add_wall(new Kernel_house_short_1(Vector2f(tmr.x, tmr.y), 1));
      }
      else if(tmr.r == 21 && tmr.g == 81 && tmr.b == 82){
        add_wall(new Blank_impassable(Vector2f(tmr.x, tmr.y)));
      }
      else if(tmr.r == 148 && tmr.g == 120 && tmr.b == 54){
        add_ground(new Grass_1(Vector2f(tmr.x, tmr.y)));
        add_wall(new White_fence_1(Vector2f(tmr.x, tmr.y), 0)); // horizontal
      }
      else if(tmr.r == 89 && tmr.g == 66 && tmr.b == 28){
        add_ground(new Grass_1(Vector2f(tmr.x, tmr.y)));
        add_wall(new White_fence_1(Vector2f(tmr.x, tmr.y), 2)); // corner ul
      }
      else if(tmr.r == 166 && tmr.g == 143 && tmr.b == 87){
        add_ground(new Grass_1(Vector2f(tmr.x, tmr.y)));
        add_wall(new White_fence_1(Vector2f(tmr.x, tmr.y), 1)); // vertical
      }
      else if(tmr.r == 186 && tmr.g == 19 && tmr.b == 164){
        add_wall(new Stability_boundary_1(Vector2f(tmr.x, tmr.y)));
      }
      // else if(tmr.r == 0 && tmr.g == 0 && tmr.b == 255){
        // add_ground(new Rocky_ground_1(Vector2f(tmr.x, tmr.y)));
      // }
    }
    
    // player_entity.position = center_spawn;
    // place_agent(player_entity);
    
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