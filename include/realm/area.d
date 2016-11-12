module area;

import physical;
import agent;
import vector;

alias Vector2f = Vector2!float;

class Area {
  static const(float) area_width = 1.0f, area_height = 1.0f;
  
  Physical_list stationaries; /// Static objects
  Physical_list agents; /// Mobile objects
  Vector2f position;
  
  this(Vector2f _position){
    position = _position;
    stationaries = new Physical_list;
    agents = new Physical_list;
  }
  
  void destroy(){
    foreach(Physical stationary; stationaries){
      stationary.destroy;
    }
    foreach(Physical agent; agents){
      agent.destroy;
    }
    stationaries.destroy;
    agents.destroy;
    object.destroy(this);
  }
  
  void update(long time, float dt){
    foreach(Physical stationary; stationaries){
      stationary.update(time, dt);
    }
    foreach(Physical agent; agents){
      agent.update(time, dt);
    }
  }
  
  void render(long time){
    foreach(Physical stationary; stationaries){
      stationary.render(time);
    }
    foreach(Physical agent; agents){
      agent.render(time);
    }
  }
  
  void add_agent(Agent agent){
    agent.index.remove;
    agent.index = agents.add(agent);
  }
  
  void add_stationaries(Physical stationary){
    stationary.index.remove;
    stationary.index = stationaries.add(stationary);
  }
}


