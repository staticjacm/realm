module island_world;

import std.stdio;
import std.random;
import misc;
import game;
import grid;
import sllist;
import make;
import world;
import player;
import entity;
import agent;
import area;
import vector;
import wall;
import timer;

Timer test_timer;

class Island_world_1 : World {
  static bool type_initialized = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      make.initialize_type!"Deep_ocean_water_1";
      make.initialize_type!"Shallow_ocean_water_1";
      make.initialize_type!"Sand_1";
      make.initialize_type!"Grass_1";
      make.initialize_type!"Tropical_tree_1";
      make.initialize_type!"Bush_1";
      make.initialize_type!"Island_mountain_cliff_1";
      make.initialize_type!"Oasis_sand_1";
      make.initialize_type!"Oasis_water_1";
      make.initialize_type!"River_water_1";
      make.initialize_type!"Giant_sea_turtle_1";
    }
  }
  
  Vector2f boss_point;
  Vector2f entrance_point;
  
  
  this(){
    string[Vector2f] world;
    test_timer.start;
    
    writeln("Deep water");
    float R = 75;
    float r = cast(int)(cast(float)R*0.6f);
    for(float x = -R; x <= R; x++){
      for(float y = -R; y <= R; y++){
        if(x*x + y*y <= R*R){
          world[Vector2f(x, y)] = "Deep_water";
        }
      }
    }
    writeln("Shallow water");
    for(float x = -r; x <= r; x++){
      for(float y = -r; y <= r; y++){
        if(x*x + y*y <= r*r){
          world[Vector2f(x, y)] = "Shallow_water";
        }
      }
    }
    
    writeln("Islands");
    float land_points_number = r * 0.2;
    writeln(" land points number ", land_points_number);
    Vector2f_list land_points = new Vector2f_list;
    for(int i = 0; i < land_points_number; i++){
      land_points.add(
        cs2d(uniform!"[]"(0, 360)) * (1 + uniform!"[]"(-1.0f, 1.0f)*0.1) * r
      );
    }
    float island_points_number = 10;
    float island_points_range = r * 0.3f;
    float island_points_size_base = r * 0.4;
    float island_water_r = island_points_size_base * 1.0f;
    float island_beach_r = island_points_size_base * 0.8f;
    float island_grass_r = island_points_size_base * 0.5f;
    Vector2f_list island_points = new Vector2f_list;
    foreach(Vector2f land_point; land_points){
      for(int i = 0; i < island_points_number; i++){
        island_points.add(
          land_point + Vector2f(uniform!"[]"(-1.0f, 1.0f), uniform!"[]"(-1.0f, 1.0f)) * island_points_range
        );
      }
    }
    writeln("Islands construction");
    float i = 0;
    foreach(Vector2f island_point; island_points){
      writeln("  ", i++ / island_points.length, "%");
      for(float x = -island_water_r; x <= island_water_r; x++){
        for(float y = -island_water_r; y <= island_water_r; y++){
          float norm = x*x + y*y;
          Vector2f point = floor(Vector2f(x, y) + island_point);
          string* value = (point in world);
          if(norm <= island_water_r * island_water_r){
            if(norm <= island_beach_r * island_beach_r){
              if(norm <= island_grass_r * island_grass_r){
                world[point] = "Grass";
              }
              else {
                if(value is null || value !is null && *value != "Grass"){
                  world[point] = "Sand";
                }
              }
            }
            else {
              if(value is null || value !is null && *value == "Deep_water"){
                world[point] = "Shallow_water";
              }
            }
          }
        }
      }
    }
    
    writeln("Island trees");
    float island_trees_chance = 0.2;
    float island_trees_range = island_points_size_base;
    float island_trees_number = island_points_size_base * island_points_size_base * 0.1f;
    foreach(Vector2f island_point; island_points){
      if(uniform(0.0f, 1.0f) < island_trees_chance){
        for(int i = 0; i < island_trees_number; i++){
          Vector2f point = floor(
            island_point + Vector2f(uniform(-1.0f, 1.0f), uniform(-1.0f, 1.0f)) * island_trees_range
          );
          string* value = (point in world);
          if(value !is null && *value == "Grass"){
            world[point] = "Tree";
          }
        }
      }
    }
    
    writeln("Bushes");
    float bush_chance = 0.03;
    for(float x = -r; x <= r; x++){
      for(float y = -r; y <= r; y++){
        if(uniform(0.0f, 1.0f) < bush_chance && world[Vector2f(x, y)] == "Grass"){
          world[Vector2f(x, y)] = "Bush";
        }
      }
    }
    
    writeln("Mountains");
    float mountain_chance = 0.3;
    float mountain_number = 120;
    float mountain_range = r * 0.1;
    foreach(Vector2f land_point; land_points){
      if(uniform(0.0f, 1.0f) < mountain_chance){
        for(int i = 0; i < mountain_number; i++){
          world[floor(
            land_point + Vector2f(uniform(-1.0f, 1.0f), uniform(-1.0f, 1.0f)) * mountain_range
          )] = "Mountain";
        }
      }
    }
    
    writeln("Rivers");
    float river_chance = 1.0f / land_points_number;
    float river_max_range = r * 1.0f;
    Vector2f_2_list river_choices = new Vector2f_2_list;
    foreach(Vector2f land_point_1; land_points){
      foreach(Vector2f land_point_2; land_points){
        if(land_point_1 != land_point_2){
          river_choices.add(Vector2f_2(land_point_1, land_point_2));
        }
      }
    }
    float[] river_extents = [1.0f, 0.0f, 2.0f];
    string[] river_pass_tiles = ["Grass", "Tree", "Bush", "Sand", "Mountain"];
    foreach(Vector2f_2 choice; river_choices){
      if(uniform(0.0f, 1.0f) <= river_chance){
        float ext = misc.random_choice(river_extents, 0.5f);
        Vector2f loc = floor(choice.x); // where the river currently is
        Vector2f target = floor(choice.y); // what it is going towards
        float range = 0.0f;
        while(river_pass_tiles.contains(world[loc]) && (target - loc).norm > 1 && range < river_max_range){
          for(float x = -ext; x <= ext; x++){
            for(float y = -ext; y <= ext; y++){
              world[floor(loc + Vector2f(x, y))] = "River";
            }
          }
          loc = loc + round((target - loc).normalize * (1 + ext));
          range += 1.0f;
        }
      }
    }
    
    writeln("Oasis");
    float oasis_number = 3;
    Vector2f_list oasis_points = island_points.random_sample(cast(int)oasis_number);
    float oasis_size_base = r * 0.1;
    float oasis_water_r = oasis_size_base * 0.8f;
    float oasis_beach_r = oasis_size_base * 1.0f;
    float oasis_tree_r  = oasis_size_base * 2.0f;
    float oasis_tree_chance = 0.05;
    
    writeln("Oasis beach");
    foreach(Vector2f oasis_point; oasis_points){
      for(float x = -oasis_beach_r; x <= oasis_beach_r; x++){
        for(float y = -oasis_beach_r; y <= oasis_beach_r; y++){
          float norm = x*x + y*y;
          if(norm <= oasis_beach_r * oasis_beach_r){
            if(norm <= oasis_water_r * oasis_water_r){
              world[floor(Vector2f(x, y) + oasis_point)] = "Oasis_water";
            }
            else{
              world[floor(Vector2f(x, y) + oasis_point)] = "Oasis_beach";
            }
          }
        }
      }
    }
    
    writeln("Oasis trees");
    foreach(Vector2f oasis_point; oasis_points){
      for(float x = -oasis_tree_r; x <= oasis_tree_r; x++){
        for(float y = -oasis_tree_r; y <= oasis_tree_r; y++){
          if(uniform(0.0f, 1.0f) <= oasis_tree_chance && x*x + y*y <= oasis_tree_r * oasis_tree_r){
            Vector2f point = floor(Vector2f(x, y) + oasis_point);
            string* value = (point in world);
            if(value !is null && *value == "Grass"){
              world[point] = "Tree";
            }
          }
        }
      }
    }
    
    writeln("Building");
    for(float x = -R-r; x <= R+r; x++){
      writeln("  ", (x + (R+r))/(2*(R+r)), "%");
      for(float y = -R-r; y <= R+r; y++){
        Vector2f point = Vector2f(x, y);
        string* value = (point in world);
        if(value !is null){
          switch(*value){
            default:
            case "Deep_water":
              add_or_replace_ground(make_ground!"Shallow_ocean_water_1", point);
              add_or_replace_wall(make_wall!"Deep_ocean_water_1", point);
              break;
            case "Shallow_water":
              add_or_replace_ground(make_ground!"Shallow_ocean_water_1", point);
              break;
            case "Sand":
              add_or_replace_ground(make_ground!"Sand_1", point);
              break;
            case "Grass":
              add_or_replace_ground(make_ground!"Grass_1", point);
              break;
            case "Oasis_water":
              add_or_replace_ground(make_ground!"Oasis_water_1", point);
              break;
            case "Oasis_beach":
              add_or_replace_ground(make_ground!"Sand_1", point);
              break;
            case "Tree":
              add_or_replace_ground(make_ground!"Grass_1", point);
              add_or_replace_wall(make_wall!"Tropical_tree_1", point);
              break;
            case "Bush":
              add_or_replace_ground(make_ground!"Grass_1", point);
              add_or_replace_wall(make_wall!"Bush_1", point);
              break;
            case "Mountain":
              add_or_replace_ground(make_ground!"Grass_1", point);
              add_or_replace_wall(make_wall!"Island_mountain_cliff_1", point);
              break;
            case "River":
              add_or_replace_ground(make_ground!"River_water_1", point);
              break;
          }
        }
      }
    }
  
    // Vector2f boss_point;
    entrance_point = land_points.random_choice;
    
    test_timer.report("time:");
    
  }
  
  override void create_grid(){
    grid = new Array_grid2!(Area, float);
  }
  
  override string name(){ return "Island Paradise"; }
  override string description(){ return "The old realm used to have incredible beaches that stretched for many miles on magnificent green islands. All of this world's creatures have been corrupted by the destroyer -- the oldest among them more so"; }
  override string standard_article(){ return "a"; }
  
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
            area.set_wall = make_wall!"Deep_ocean_water_1";
          }
        }
      }
    }
    center_area = new_area(position.floor);
    center_area.set_ground = make_ground!"Shallow_ocean_water_1";
    return center_area;
  }
  
}