module area;

import physical;
import agent;
import vector;

alias Vector2f = Vector2!float;

class Area {
  Physical stationary; /// The stationary physical currently sitting at this location
  Agent_list agents;
  Vector2f position;
  
  this(Vector2f _position){
    position = _position;
  }
  
  void update(long time, float dt){
    stationary.update(time, dt);
    foreach(Agent agent; agents){
      agent.update(time, dt);
    }
  }
  
  void render(long time){
    stationary.render(time);
    foreach(Agent agent; agents){
      agent.render(time);
    }
  }
}


