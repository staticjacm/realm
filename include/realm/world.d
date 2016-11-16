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
  
  Area new_area(Vector2f position){
    Area area = new Area(position);
    area.world = this;
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
  
  void add_wall(Wall wall){
    wall.position.x = floor(wall.position.x);
    wall.position.y = floor(wall.position.y);
    new_area(wall.position).set_wall(wall);
  }
  
  void add_ground(Ground ground){
    ground.position.x = floor(ground.position.x);
    ground.position.y = floor(ground.position.y);
    new_area(ground.position).set_ground(ground);
  }
  
  void place_agent(Agent agent){
    Area area = get_area(agent.position);
    if(area !is null && area !is agent.area){
      writefln("%s switched from %s to %s", agent, agent.area, area);
      area.add_agent(agent);
    }
  }
  
}