module world;

import grid;
import vector;
import physical;
import area;

alias world_grid_type = Dict_grid2;

class World : world_grid_type!(Area, float) {
  
  void update(long time, float dt){
    foreach(Area area; this){
      area.update(time, dt);
    }
  }
  
  void initialize(){}
  
  void render(long time){
    foreach(Area area; this){
      area.render(time);
    }
  }
  
  void set_ground()
  
}