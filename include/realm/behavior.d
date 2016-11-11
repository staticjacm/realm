
module behavior;

import agent;

/++
Controls the movement, attack patterns, etc of agents
++/
class Behavior {
  Agent agent;
  
  void update(long time, float dt){}
  
  /// detected(agent) is called when an another agent is detected
  void detected(Agent agent){}
  
  void regular_attack(){}
}