module world;

import std.stdio;
import std.math;
import grid;
import vector;
import physical;
import agent;
import area;

alias world_grid_type = Dict_grid2;

class World : world_grid_type!(Area, float) {
  
  void destroy(){
    foreach(Area area; this){
      area.destroy;
    }
    object.destroy(this);
  }
  
  void update_area(long time, float dt, Area area){
    foreach(Physical stationary; area.stationaries){
      stationary.update(time, dt);
      
    }
    foreach(Physical agent; area.agents){
      if(agent !is null){
        agent.update(time, dt);
        if(agent.moved)
          place_agent(cast(Agent)agent);
      }
    }
  }
  
  void update(long time, float dt){
    foreach(Area area; this){
      if(area.agents.length == 0){ // no agents
        if(area.stationaries.length == 0){ // no agents, no stationaries
          area.destroy;
          remove(area.position);
        }
      }
      else if(area.stationaries.length == 0){ // no stationaries
        generate(area);
        update_area(time, dt, area);
      }
      else {
        update_area(time, dt, area);
      }
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
    set(area, position);
    return area;
  }
  
  void add_stationary(Physical stationary){
    stationary.position.x = floor(stationary.position.x);
    stationary.position.y = floor(stationary.position.y);
    new_area(stationary.position).add_stationaries(stationary);
  }
  
  void place_agent(Agent agent){
    Vector2f position = floor(agent.position);
    Area* areap = get(position);
    if(areap !is null)
      areap.add_agent(agent);
  }
  
}