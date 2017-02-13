module island_world;

import std.stdio;
import std.random;
import game;
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
      make.initialize_type!"Island_mountain_cliff_1";
      make.initialize_type!"Oasis_sand_1";
      make.initialize_type!"Oasis_water_1";
      make.initialize_type!"Giant_sea_turtle_1";
    }
  }
  
  Vector2f boss_point;
  Vector2f entrance_point;
  
  this(){
    float load_position_max = 6.0f;
    float load_position = 0.0f;
    
    int R = 125;
    int r = cast(int)(cast(float)R*0.9f);
    // float rsqr = r*r;
    
    // Ocean
    /*
      Set the boundary to deep water walls
      and the interior to shallow water grounds
    */
    for(float x = -R; x < R; x += 1.0f){
      for(float y = -R; y < R; y += 1.0f){
        if(x*x + y*y >= r*r)
          add_wall(make_wall!"Deep_ocean_water_1", Vector2f(x, y));
        else
          add_ground(make_ground!"Shallow_ocean_water_1", Vector2f(x, y));
      }
    }
    load_position = 1;
    writeln("load position: ", load_position / load_position_max);
    
    // Land
    /*
      The island(s) are composed of globules of 'island points' centered around 'land points'
    */
    int island_points_number = 20;
    int island_point_r = 25;
    int land_points_number_per_island = 25;
    int land_point_beach_r = 15;
    int land_point_island_r = 13;
    Vector2f_list island_points = new Vector2f_list;
    Vector2f_list land_points = new Vector2f_list;
    for(int i = 0; i < island_points_number; i++){
      // Island point
      Vector2f island_point = rvector(r);
      island_points.add(island_point);
      // Land points
      for(int j = 0; j < land_points_number_per_island; j++){
        Vector2f land_point = island_point + rvector(island_point_r);
        land_points.add(land_point);
      }
    }
    // Creating Land from land points
    // Beach
    for(int x = -land_point_beach_r; x < land_point_beach_r; x++)
      for(int y = -land_point_beach_r; y < land_point_beach_r; y++)
        if(x*x + y*y <= land_point_beach_r * land_point_beach_r)
          foreach(Vector2f land_point; land_points){
            add_ground(make_ground!"Sand_1", Vector2f(x, y) + land_point);
          }
    // Island
    for(int x = -land_point_beach_r; x < land_point_beach_r; x++)
      for(int y = -land_point_beach_r; y < land_point_beach_r; y++)
        if(x*x + y*y <= land_point_beach_r * land_point_beach_r)
          foreach(Vector2f land_point; land_points){
            add_ground(make_ground!"Grass_1", Vector2f(x, y) + land_point);
          }
    load_position = 2;
    writeln("load position: ", load_position / load_position_max);
    
    // Trees
    /*
      Trees are scattered around land points randomly with spread the same size as the
      island point radius
    */
    int trees_number_per_land_point = 30;
    int land_point_has_trees_probability = 3; // out of 100
    foreach(Vector2f land_point; land_points){
      if(uniform!"[]"(0, 100) < land_point_has_trees_probability){
        for(int i = 0; i < trees_number_per_land_point; i++){
          Vector2f tree_point = land_point + rvector(island_point_r);
          // Could check if tree_point is over water ground/wall
          add_wall(make_wall!"Tropical_tree_1", tree_point);
        }
      }
    }
    load_position = 3;
    writeln("load position: ", load_position / load_position_max);
    
    // Mountains
    /*
      Mountains are globules just the same as land points are
    */
    int mountain_number_per_land_point = 30;
    int land_point_has_mountains_probability = 2;
    int mountain_point_r = 7;
    foreach(Vector2f land_point; land_points){
      if(uniform!"[]"(0, 100) < land_point_has_mountains_probability){
        Vector2f mountain_point = land_point + rvector(land_point_beach_r);
        for(int x = -mountain_point_r; x < mountain_point_r; x++){
          for(int y = -mountain_point_r; y < mountain_point_r; y++){
            if(x*x + y*y < mountain_point_r * mountain_point_r){
              Vector2f mountain_tile_point = mountain_point + Vector2f(cast(float)x, cast(float)y);
              add_wall(make_wall!"Island_mountain_cliff_1", mountain_tile_point);
            }
          }
        }
      }
    }
    load_position = 4;
    writeln("load position: ", load_position / load_position_max);
    
    // Oases
    /*
      Oases are marshy ponds centered at an island point which may contain a boss
      They always have trees around them
    */
    int oasis_number = 3;
    int oasis_sand_r = 8;
    int oasis_water_r = 7;
    int oasis_tree_number = 50;
    int oasis_tree_r = 25;
    Vector2f_list oasis_points = land_points.random_sample(oasis_number);
    // Sand around pond
    for(int x = -oasis_sand_r; x < oasis_sand_r; x++){
      for(int y = -oasis_sand_r; y < oasis_sand_r; y++){
        if(x*x + y*y < oasis_sand_r * oasis_sand_r)
          foreach(Vector2f oasis_point; oasis_points)
            add_ground(make_ground!"Oasis_sand_1", oasis_point);
      }
    }
    // Oasis water
    for(int x = -oasis_water_r; x < oasis_water_r; x++){
      for(int y = -oasis_water_r; y < oasis_water_r; y++){
        if(x*x + y*y < oasis_water_r * oasis_water_r)
          foreach(Vector2f oasis_point; oasis_points)
            add_ground(make_ground!"Oasis_water_1", oasis_point);
      }
    }
    foreach(Vector2f oasis_point; oasis_points){
      for(int i = 0; i < oasis_tree_number; i++){
        Vector2f tree_point = oasis_point + rvector(oasis_tree_r);
        add_wall(make_wall!"Tropical_tree_1", tree_point);
      }
    }
    load_position = 5;
    writeln("load position: ", load_position / load_position_max);
    
    // Boss
    Vector2f_list temp = oasis_points.random_sample(1);
    if(temp.first !is null)
      boss_point = temp.first.value;
    Entity boss = make_entity!"Giant_sea_turtle_1";
    boss.position = boss_point;
    place_agent(boss);
    load_position = 6;
    writeln("load position: ", load_position / load_position_max);
    
    temp = island_points.random_sample(1);
    if(temp.first !is null)
      entrance_point = temp.first.value;
    while(oasis_points.contains(entrance_point)){
      temp = island_points.random_sample(1);
      if(temp.first !is null)
        entrance_point = temp.first.value;
    }
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