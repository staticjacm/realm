module world;

import std.stdio;
import std.math;
import grid;
import game;
import vector;
import wall;
import ground;
import agent;
import entity;
import area;
import timer;

Timer test_timer;

alias world_grid_type = Dict_grid2;

class World : world_grid_type!(Area, float) {
  
  void destroy(){
    foreach(Area area; this){
      area.destroy;
    }
    object.destroy(this);
  }
  
  void update(){
  //  test_timer.start;
  //  foreach(Area area; this){
  //    // .003 ms 20x20
  //    // if(area.updates)
  //      area.update;
  //  }
  //  writefln("foreach area %f", test_timer.hnsecsf*1000.0f);
  }
  
  void initialize(){}
  
  void render(){
    // foreach(Area area; this){
      // test_timer.start;
      // area.render;
      // writefln("render: %f", test_timer.hnsecsf*1000.0f);
    // }
  }
  
  void connect_area_to_surroundings(Area area){
    Vector2f position = area.position;
    area.adjacent_ul  = get_area(position + Vector2f(-1, 1));
    area.adjacent_u   = get_area(position + Vector2f(0, 1));
    area.adjacent_ur  = get_area(position + Vector2f(1, 1));
    area.adjacent_l   = get_area(position + Vector2f(-1, 0));
    area.adjacent_r   = get_area(position + Vector2f(1, 0));
    area.adjacent_bl  = get_area(position + Vector2f(-1, -1));
    area.adjacent_b   = get_area(position + Vector2f(0, -1));
    area.adjacent_br  = get_area(position + Vector2f(1, -1));
  }
  
  /// Procedurally generates a new area. Usually used with areas generated at the location of agents
  void generate_area(Area area){}
  bool generate_adjacent_areas(){ return false; }
  /// Procedurally generates a new area. Usually used with areas adjacent to generate_area's area
  void generate_adjacent_area(Area area){}
  
  Area new_area(Vector2f position){
    Area area = new Area(Vector2f(position.x.floor, position.y.floor));
    integrate_area(area);
    return area;
  }
  
  void integrate_area(Area area){
    if(area !is null){
      if(area.world !is this){
        if(area.world !is null)
          area.world.remove(area.position);
        area.world = this;
      }
      area.position.x = area.position.x.floor;
      area.position.y = area.position.y.floor;
      set(area, area.position);
      connect_area_to_surroundings(area);
    }
  }
  
  Area get_area(Vector2f position){
    Area* areap = get(Vector2f(position.x.floor, position.y.floor));
    if(areap !is null)
      return *areap;
    else
      return null;
  }
  
  Area get_or_new_area_single(Vector2f position){
    Area area = get_area(position);
    if(area is null){
      Area generated_area = new Area(position);
      integrate_area(generated_area);
      generate_area(generated_area);
      return generated_area;
    }
    else
      return area;
  }
  
  Area get_or_new_area(Vector2f position){
    Area area = get_area(position);
    if(area is null){
      Area generated_area = new Area(position);
      integrate_area(generated_area);
      generate_area(generated_area);
      // Generate adjacent areas around this one
      if(generate_adjacent_areas){
        Vector2f[] adj_position_list = [Vector2f(-1, 1), Vector2f(0, 1), Vector2f(1, 1), Vector2f(-1, 0), Vector2f(1, 0), Vector2f(-1, -1), Vector2f(0, -1), Vector2f(1, -1)];
        for(int i = 0; i < adj_position_list.length; i++){
          Vector2f adj_position = generated_area.position + adj_position_list[i];
          Area adj_area = get_area(adj_position);
          if(adj_area is null){
            adj_area = new Area(adj_position);
            integrate_area(adj_area);
            generate_adjacent_area(adj_area);
          }
        }
      }
      return generated_area;
    }
    else
      return area;
  }
  
  void add_wall(Wall wall){
    wall.position.x = floor(wall.position.x);
    wall.position.y = floor(wall.position.y);
    get_or_new_area_single(wall.position).set_wall(wall);
  }
  
  void add_ground(Ground ground){
    ground.position.x = floor(ground.position.x);
    ground.position.y = floor(ground.position.y);
    get_or_new_area_single(ground.position).set_ground(ground);
  }
  
  void place_agent(Agent agent){
    Area area = get_or_new_area(agent.position);
    if(area !is null){
      if(area !is agent.area){
        if(agent.area !is null)
          agent.area.remove_agent(agent);
        agent.area_index.remove;
        area.add_agent(agent);
      }
    }
    else {
      agent.area_index.remove;
    }
  }
  
}