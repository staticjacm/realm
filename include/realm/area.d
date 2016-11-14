module area;

import std.stdio;
import refable;
import world;
import ground;
import wall;
import agent;
import vector;

alias Vector2f = Vector2!float;

class Area {
  static const(float) area_width = 1.0f, area_height = 1.0f;
  
  int object_count = 0;
  World world;
  Wall wall;
  Ground ground;
  Agent_list agents; /// Mobile objects
  Vector2f position;
  
  this(Vector2f _position){
    position = _position;
    agents = new Agent_list;
  }
  
  void destroy(){
    foreach(Agent agent; agents){
      agent.area = null;
    }
    wall.destroy;
    ground.destroy;
    agents.destroy;
    object.destroy(this);
  }
  
  void update(long time, float dt){
    bool emptyq = true;
    if(wall !is null){
      emptyq = false;
      wall.update(time, dt);
    }
    if(ground !is null){
      emptyq = false;
      ground.update(time, dt);
    }
    if(agents.length > 0)
      emptyq = false;
    if(emptyq)
      destroy;
  }
  
  void render(long time){
    if(ground !is null)
      ground.render(time);
    // foreach(Agent agent; agents){
      // if(agent !is null)
        // agent.render(time);
    // }
    if(wall !is null)
      wall.render(time);
  }
  
  bool inside(Vector2f point){
    return ( (position.x <= point.x) && (point.x <= position.x + 1) && 
             (position.y <= point.y) && (point.y <= position.y + 1) );
  }
  
  void add_agent(Agent agent){
    if(inside(agent.position)){
      agent.area = this;
      agent.area_index = agents.add(agent);
    }
  }
  
  void set_wall(Wall _wall){
    if(_wall !is null){
      unset_wall;
      wall = _wall;
      wall.position = position;
      wall.area = this;
    }
  }
  
  void unset_wall(){
    if(wall !is null){
      if(wall.area is this){
        wall.destroy;
      }
      wall = null;
    }
  }
  
  void set_ground(Ground _ground){
    if(_ground !is null){
      unset_ground;
      ground = _ground;
      ground.position = position;
      ground.area = this;
    }
  }
  
  void unset_ground(){
    if(ground !is null){
      if(ground.area is this){
        ground.destroy;
      }
      ground = null;
    }
  }
}


