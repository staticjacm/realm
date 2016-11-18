module world;

import std.stdio;
import std.math;
import grid;
import vector;
import wall;
import ground;
import agent;
import entity;
import area;

alias world_grid_type = Dict_grid2;

class World : world_grid_type!(Area, float) {
  
  void destroy(){
    foreach(Area area; this){
      area.destroy;
    }
    object.destroy(this);
  }
  
  void update(long time, float dt){
    foreach(Area area; this){
      area.update(time, dt);
    }
  }
  
  void initialize(){}
  
  /// For generating new stationaries when an agent is present but no stationaries are
  void generate(Area area){}
  
  void render(long time){
    foreach(Area area; this){
      area.render(time);
    }
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
  
  Area new_area(Vector2f position){
    Area area = new Area(Vector2f(position.x.floor, position.y.floor));
    area.world = this;
    connect_area_to_surroundings(area);
    set(area, position);
    return area;
  }
  
  Area get_area(Vector2f position){
    Area* areap = get(Vector2f(position.x.floor, position.y.floor));
    if(areap !is null)
      return *areap;
    else
      return null;
  }
  
  Area get_or_new_area(Vector2f position){
    Area area = get_area(position);
    if(area is null)
      return new_area(position);
    else
      return area;
  }
  
  void add_wall(Wall wall){
    wall.position.x = floor(wall.position.x);
    wall.position.y = floor(wall.position.y);
    get_or_new_area(wall.position).set_wall(wall);
  }
  
  void add_ground(Ground ground){
    ground.position.x = floor(ground.position.x);
    ground.position.y = floor(ground.position.y);
    get_or_new_area(ground.position).set_ground(ground);
  }
  
  void place_agent(Agent agent){
    Area area = get_area(agent.position);
    if(area !is null){
      if(area !is agent.area){
        agent.area_index.remove;
        area.add_agent(agent);
      }
    }
    else{
      agent.area_index.remove;
    }
  }
  
}