module testing_world;

import std.stdio;
import std.random;
import sgogl;
import dbg;
import make;
import game;
import world;
import player;
import agent;
import area;
import vector;
import renderable;
import ground;
import decoration;
import wall;
import timer;
import rocky_ground;
import stone_ground;

Timer test_timer;

Tmr[] tilemap_data = mixin(import("testing_world_tilemap_data.txt"));

class Testing_world_1 : World {
  static bool type_initialized = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      make.initialize_type!"Rocky_ground_1";
      make.initialize_type!"Stone_ground_1";
      make.initialize_type!"Portal_carpet_1";
      make.initialize_type!"Stone_wall_1";
      make.initialize_type!"Cactus_1";
      make.initialize_type!"Fireball_1";
      make.initialize_type!"Twinkle_1";
    }
  }
  
  float spawn_next_time = 0;
  float spawn_delay = 300;
  
  this(){
    // float R = 20;
    
    foreach(Tmr tmr; tilemap_data){
      if(tmr.r == 255 && tmr.g == 255 && tmr.b == 255){
        Stone_ground_1 ground = cast(Stone_ground_1)make_ground!"Stone_ground_1";
        ground.position = Vector2f(tmr.x, tmr.y);
        ground.set_type = 0;
        add_ground(ground);
      }
      else if(tmr.r == 0 && tmr.g == 255 && tmr.b == 0){
        Stone_ground_1 ground = cast(Stone_ground_1)make_ground!"Stone_ground_1";
        ground.position = Vector2f(tmr.x, tmr.y);
        ground.set_type = 1;
        add_ground(ground);
      }
      else if(tmr.r == 255 && tmr.g == 0 && tmr.b == 0){
        Wall wall = make_wall!"Stone_wall_1";
        wall.set_position = Vector2f(tmr.x, tmr.y);
        wall.set_updating = true;
        add_wall(wall);
      }
      else if(tmr.r == 0 && tmr.g == 0 && tmr.b == 255){
        Ground ground = make_ground!"Portal_carpet_1";
        ground.set_position(Vector2f(tmr.x, tmr.y));
        add_ground(ground);
      }
    }
    /*
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
    */
    
  }
  
  override string name(){ return "World o' Testing"; }
  override string description(){ return "For testing things out"; }
  override string standard_article(){ return "a"; }
  
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
            ground.set_position(adj_pos);
            area.set_ground = ground;
            if(uniform(0, 100) < 60){
              Wall wall = make_wall!"Cactus_1";
              wall.set_position = adj_pos;
              area.set_wall = wall;
            }
          }
        }
      }
    }
    center_area = new_area(position.floor);
    Ground ground = make_ground!"Rocky_ground_1";
    ground.set_position(center_area.position);
    center_area.set_ground = ground;
    return center_area;
  }
  
  // override void render_area_default(Vector2f position){
  //   gr_color(0.611765f, 0.45098f, 0.215686f, 1.0f);
  //   gr_draw_partial(Rocky_ground_1.image_1, position.x, position.y, 1.0f, 1.0f, position.x, position.y, Renderable.default_render_depth, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f);
  //   gr_color_alpha(1.0f);
  // }
  
}