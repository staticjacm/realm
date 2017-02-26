module kernel;

import std.string;
import std.stdio;
import std.random;
import dbg;
import sgogl;
import make;
import game;
import world;
import player;
import agent;
import decoration;
import area;
import vector;
import wall;
import timer;
import white_fence;
import kernel_house_short;
import kernel_house_tall;
import ground;

Timer test_timer;

Tmr[] tilemap_data = mixin(import("kernel_tilemap_data.txt"));

class Kernel : World {
  static bool type_initialized    = false;
  static Vector2f center_spawn    = Vector2f(150, 187);
  static Vector2f beach_portal    = Vector2f(37, 107);
  static Vector2f forest_portal   = Vector2f(150, 35);
  static Vector2f mountain_portal = Vector2f(266, 106);
  static uint loading_image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      loading_image = gr_load_image("assets/worlds/kernel/loading_screen_image.png".toStringz, 0);
      // writefln("loading image: %d", loading_image);
      make.initialize_type!"Rocky_ground_1";
      make.initialize_type!"Grass_1";
      make.initialize_type!"Matted_grass_1";
      make.initialize_type!"Makeshift_brick_path_1";
      make.initialize_type!"Dirt_1";
      make.initialize_type!"Sand_1";
      make.initialize_type!"Grass_with_flowers_1";
      make.initialize_type!"Kernel_house_short_1";
      make.initialize_type!"Brick_path_1";
      make.initialize_type!"Fountain_water_1";
      make.initialize_type!"Fountain_wall_1";
      make.initialize_type!"Blank_impassable_wall_1";
      make.initialize_type!"White_fence_1";
      make.initialize_type!"Red_carpet_1";
      make.initialize_type!"Kernel_house_tall_1";
      make.initialize_type!"Portal_carpet_1";
      make.initialize_type!"Stability_boundary_1";
      make.initialize_type!"Stone_ground_1";
      make.initialize_type!"Stone_wall_1";
      make.initialize_type!"Cactus_1";
      make.initialize_type!"Fireball_1";
      make.initialize_type!"Twinkle_1";
    }
  }
  
  float spawn_next_time = 0;
  float spawn_delay = 300;
  
  
  this(){
    game_render_loading_screen(loading_image, 0.0f);
    float R = 20;
    
    entrance_position = center_spawn;
    
    float number_of_maps = cast(float)tilemap_data.length;
    float current_map = 0;
    
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
      game.update_events;
      if(!game.running)
        break;
      current_map++;
      if(tmr.x)
      if(cast(int)current_map % 100 == 0)
        game_render_loading_screen(loading_image, current_map / number_of_maps);
      // writefln("%f", current_map / number_of_maps);
      if(tmr.r == 00 && tmr.g == 255 && tmr.b == 00){
        add_ground(make_ground!"Grass_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 42 && tmr.g == 69 && tmr.b == 00){
        add_ground(make_ground!"Matted_grass_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 130 && tmr.g == 74 && tmr.b == 00){
        add_ground(make_ground!"Dirt_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 245 && tmr.g == 235 && tmr.b == 48){
        add_ground(make_ground!"Sand_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 124 && tmr.g == 102 && tmr.b == 94){
        add_ground(make_ground!"Rocky_ground_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 119 && tmr.g == 255 && tmr.b == 00){
        add_ground(make_ground!"Grass_with_flowers_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 31 && tmr.g == 58 && tmr.b == 31){
        add_ground(make_ground!"Grass_with_flowers_1", Vector2f(tmr.x, tmr.y));
        add_wall(make_wall!"Tropical_tree_1", Vector2f(tmr.x, tmr.y));
        /* Add tree decoration here */
      }
      else if(tmr.r == 104 && tmr.g == 104 && tmr.b == 104){
        add_ground(make_ground!"Rocky_ground_1", Vector2f(tmr.x, tmr.y));
        add_wall(make_wall!"Stone_wall_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 166 && tmr.g == 166 && tmr.b == 166){
        add_ground(make_ground!"Rocky_ground_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 200 && tmr.g == 134 && tmr.b == 157){
        add_ground(make_ground!"Brick_path_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 138 && tmr.g == 80 && tmr.b == 100){
        add_ground(make_ground!"Makeshift_brick_path_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 42 && tmr.g == 69 && tmr.b == 00){
        add_ground(make_ground!"Matted_grass_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 150 && tmr.g == 215 && tmr.b == 215){
        add_ground(make_ground!"Portal_carpet_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 177 && tmr.g == 61 && tmr.b == 86){
        add_ground(make_ground!"Red_carpet_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 104 && tmr.g == 91 && tmr.b == 179){
        add_ground(make_ground!"Fountain_water_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 67 && tmr.g == 64 && tmr.b == 90){
        add_ground(make_ground!"Fountain_wall_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 171 && tmr.g == 40 && tmr.b == 157){
        Kernel_house_tall_1 wall = new Kernel_house_tall_1;
        wall.set_type(0);
        add_wall(wall, Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 157 && tmr.g == 171 && tmr.b == 40){
        Kernel_house_tall_1 wall = new Kernel_house_tall_1;
        wall.set_type(1);
        add_wall(wall, Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 97 && tmr.g == 21 && tmr.b == 89){
        Kernel_house_short_1 wall = new Kernel_house_short_1;
        wall.set_type(0);
        add_wall(wall, Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 105 && tmr.g == 114 && tmr.b == 27){
        Kernel_house_short_1 wall = new Kernel_house_short_1;
        wall.set_type(1);
        add_wall(wall, Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 21 && tmr.g == 81 && tmr.b == 82){
        add_wall(make_wall!"Blank_impassable_wall_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 148 && tmr.g == 120 && tmr.b == 54){
        White_fence_1 wall = new White_fence_1; // horizontal
        wall.set_type(0);
        add_wall(wall, Vector2f(tmr.x, tmr.y));
        add_ground(make_ground!"Grass_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 89 && tmr.g == 66 && tmr.b == 28){
        White_fence_1 wall = new White_fence_1; // corner ul
        wall.set_type(1);
        add_wall(wall, Vector2f(tmr.x, tmr.y));
        add_ground(make_ground!"Grass_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 166 && tmr.g == 143 && tmr.b == 87){
        White_fence_1 wall = new White_fence_1; // vertical
        wall.set_type(2);
        add_wall(wall, Vector2f(tmr.x, tmr.y));
        add_ground(make_ground!"Grass_1", Vector2f(tmr.x, tmr.y));
      }
      else if(tmr.r == 186 && tmr.g == 19 && tmr.b == 164){
        add_wall(make_wall!"Stability_boundary_1", Vector2f(tmr.x, tmr.y));
      }
      // else if(tmr.r == 0 && tmr.g == 0 && tmr.b == 255){
        // add_ground(new Rocky_ground_1(Vector2f(tmr.x, tmr.y)));
      // }
    }
    
    // player_entity.position = center_spawn;
    // place_agent(player_entity);
    
    Agent collider_entity = make_agent!"Commoner_1";
    collider_entity.position = Vector2f(13, 13);
    collider_entity.faction_id = 1;
    collider_entity.world = this;
    place_agent(collider_entity);
  }
    
 override string name(){ return "Kernel"; }
 override string description(){ return "There once was a large realm just like the others. Many generations ago the destroyer came and ate that realm. We fight all the time to keep it from consuming the only thing left."; }
 override string standard_article(){ return "the"; }
  
  override void update(){
    super.update;
      Decoration twinkle = make_decoration!"Twinkle_1";
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
            Ground ground = make_ground!"Rocky_ground_1";
            ground.position = adj_pos;
            area.set_ground = ground;
            if(uniform(0, 100) < 60){
              Wall wall = make_wall!"Cactus_1";
              wall.position = adj_pos;
              area.set_wall = wall;
            }
          }
        }
      }
    }
    center_area = new_area(position.floor);
    Ground ground = make_ground!"Rocky_ground_1";
    ground.position = center_area.position;
    center_area.set_ground = ground;
    
    return center_area;
  }
  
}