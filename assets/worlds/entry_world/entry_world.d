module entry_world;

import std.string;
import std.stdio;
import std.random;
import sgogl;
import make;
import game;
import world;
import player;
import agent;
import area;
import vector;
import wall;
import ground;
import timer;
import portal;
import kernel;
import brazier;

Timer test_timer;

Tmr[] tilemap_data = mixin(import("entry_world_tilemap_data.txt"));

class Entry_world_1 : World {
  static bool type_initialized = false;
  static Vector2f spawn_location = Vector2f(10.5, 4.5);
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      make.initialize_type!"Kernel";
      make.initialize_type!"Blue_carpet_1";
      make.initialize_type!"Marble_floor_1";
      make.initialize_type!"Marble_wall_1";
      make.initialize_type!"Marble_column_1";
      make.initialize_type!"Checkered_white_black_floor_1";
      make.initialize_type!"Token_generator_1";
      make.initialize_type!"Brass_brazier_1";
      make.initialize_type!"Character_generator_portal_1";
    }
  }
  
  this(){
    float number_of_maps = cast(float)tilemap_data.length;
    float current_map = 0;
    
    /*
      128 128 128 marble floor
      255 255 255 marble wall
      255   0   0 marble column w/ marble floor
        0   0 255 blue carpet
        0   0 128 blue carpet w/ character generator portal
      255   0 255 checkered white black floor
      128   0 128 checkered white black floor w/ commoner token generator
      255 255   0 marble floor w/ burning brass brazier
      
    */
    foreach(Tmr tmr; tilemap_data){
      current_map++;
      if(cast(int)current_map % 100 == 0)
        game_render_loading_screen(loading_image, current_map / number_of_maps);
      if(tmr.r == 128 && tmr.g == 128 && tmr.b == 128){
        Ground ground = make_ground!"Marble_floor_1";
        ground.set_position = Vector2f(tmr.x, tmr.y);
        add_ground(ground);
      }
      else if(tmr.r == 255 && tmr.g == 255 && tmr.b == 255){
        Wall wall = make_wall!"Marble_wall_1";
        wall.set_position(tmr.x, tmr.y);
        add_wall(wall);
      }
      else if(tmr.r == 255 && tmr.g == 0 && tmr.b == 0){
        Ground ground = make_ground!"Marble_floor_1";
        ground.set_position(tmr.x, tmr.y);
        add_ground(ground);
        Wall wall = make_wall!"Marble_column_1";
        wall.set_position(tmr.x, tmr.y);
        add_wall(wall);
      }
      else if(tmr.r == 0 && tmr.g == 0 && tmr.b == 255){
        Ground ground = make_ground!"Blue_carpet_1";
        ground.set_position(tmr.x, tmr.y);
        add_ground(ground);
      }
      else if(tmr.r == 0 && tmr.g == 0 && tmr.b == 128){
        Ground ground = make_ground!"Blue_carpet_1";
        ground.set_position(tmr.x, tmr.y);
        add_ground(ground);
        Portal portal = make_portal!"Character_generator_portal_1";
        portal.position = Vector2f(tmr.x + 0.5, tmr.y + 0.5);
        portal.exit_position = Kernel.center_spawn;
        portal.exit_world = game.kernel_world; // from module game
        place_agent(portal);
      }
      else if(tmr.r == 255 && tmr.g == 0 && tmr.b == 255){
        Ground ground = make_ground!"Checkered_white_black_floor_1";
        ground.set_position(tmr.x, tmr.y);
        add_ground(ground);
      }
      else if(tmr.r == 128 && tmr.g == 0 && tmr.b == 128){
        Ground ground = make_ground!"Checkered_white_black_floor_1";
        ground.set_position(tmr.x, tmr.y);
        add_ground(ground);
        Agent generator = make_agent!"Token_generator_1";
        generator.position = Vector2f(tmr.x + 0.5, tmr.y + 0.5);
        place_agent(generator);
      }
      else if(tmr.r == 255 && tmr.g == 255 && tmr.b == 0){
        Ground ground = make_ground!"Marble_floor_1";
        ground.set_position(tmr.x, tmr.y);
        add_ground(ground);
        Brass_brazier_1 brazier = new Brass_brazier_1;
        brazier.position = Vector2f(tmr.x + 0.5, tmr.y + 0.5);
        brazier.lit = true;
        place_agent(cast(Agent)brazier);
      }
    }
  }
    
 override string name(){ return "Entry"; }
 override string description(){ return "Welcome"; }
 override string standard_article(){ return "the"; }
  
  override Area generate_area(Vector2f position){
    Area center_area;
    for(int x = -2; x <= 2; x++){
      for(int y = -2; y <= 2; y++){
        if(x != 0 || y != 0){
          Vector2f adj_pos = (position + Vector2f(x, y)).floor;
          Area area = get_area(adj_pos);
          if(area is null){
            area = new_area!"careless"(adj_pos);
            Ground ground = make_ground!"Marble_floor_1";
            ground.set_position(position.x + x, position.y +  y);
            add_ground(ground);
            Wall wall = make_wall!"Marble_wall_1";
            ground.set_position(position.x + x, position.y +  y);
            add_wall(wall);
          }
        }
      }
    }
    center_area = new_area(position.floor);
    Ground ground = make_ground!"Marble_floor_1";
    ground.set_position(position);
    add_ground(ground);
    return center_area;
  }
  
}