
module agent;

import std.stdio;
import std.string;
import std.math;
import world;
import area;
import wall;
import ground;
import material;
import vector;
import renderable;
import refable;
import sllist;
import sgogl;
import sgogl_interface;

alias Vector2f = Vector2!float;

/++
Proxy class from LList!AgentR
++/
class Agent_list : LList!Agent {}

bool render_overlap_boundary = true;

/++
Represents a physical object that can inhabit a world.
A conceptual abstract of floating (can move freely between grid locations) objects
Each agent has a size for collision detection purposes
++/
class Agent : Renderable {
  /++
    Static Variables
  ++/
  enum {
    subtype_agent,
    subtype_shot,
    subtype_drop,
    subtype_entity
  };
  
  static int gid = 0;
  static Agent_list master_list;
  
  static this(){
    master_list = new Agent_list;
  }
  
  static render_all(long time){
    foreach(Agent agent; master_list){
      agent.render(time);
    }
  }
  
  static update_all(long time, float dt){
    foreach(Agent agent; master_list){
      agent.update(time, dt);
    }
  }
  
  /++
    Object Variables
  ++/
  int id = 0;
  World world;
  Area area;
  Agent_list.Index master_index;
  Agent_list.Index area_index;
  Material material;
  Vector2f velocity = Vector2f(0, 0);
  float mass = 1;
  bool moving = false;
  bool moved = false;
  float height = 0;
  float size = 1;
  float friction = 1.0;
  
  /++
    Constructors & Destructors
  ++/
  this(Vector2f _position, float _size){
    id = gid++;
    super(_position);
    size = _size;
    master_index = master_list.add(this);
  }
  
  int agent_subtype_id(){ return 0; }
  
  override void destroy(){
    master_index.remove;
    area_index.remove;
    material.destroy;
    material = null;
    animation.destroy;
    animation = null;
    super.destroy;
  }
  
  override string toString(){ return format("agent %d", id); }
  
  /++
    Updating & Collision detection
  ++/
  void update(long time, float dt){
    if(material !is null)
      material.update(time, dt);
    if(moving){
      if(friction != 0)
        accelerate(-velocity*friction*10.0f, dt);
      position += velocity*dt;
      if(world !is null)
        world.place_agent(this);
    }
  }
  
  
  bool check_for_overlap(Agent agent){
    return (abs(agent.position.x - this.position.x) <= (agent.size/2 + this.size/2)) && 
           (abs(agent.position.y - this.position.y) <= (agent.size/2 + this.size/2));
  }
  bool interacts(T : Agent)(){  return true; }
  bool interacts(T : Wall)(){   return true; }
  bool interacts(T : Ground)(){ return true; }
  /// void overlap(Agent) is called when a collision is detected (this's and agent's collision squares intersect)
  void overlap(Agent agent){
    if(material !is null)
      material.overlap(this, agent);
  }
  void collide(Wall wall){
    if(material !is null)
      material.collide(this, wall);
  }
  void over(Ground ground){
    if(material !is null)
      material.over(this, ground);
  }
  
  /++
    Movement Dynamics
  ++/
  void accelerate(Vector2f acceleration, float dt){
    velocity += acceleration*dt;
    if(velocity.x != 0 || velocity.y != 0)
      moving = true;
  }
  void apply_impulse(Vector2f force, float dt){
    accelerate(force/mass, dt);
  }
  
  void move_by(Vector2f delta){
    position += delta;
    moved = true;
  }
  void move_to(Vector2f new_position){
    position = new_position;
    moved = true;
  }
  
  /++
    Rendering
  ++/
  override float render_depth(){ return 200; }
  override void render(long time){
    if(render_overlap_boundary){
      gr_color_alpha(1);
      gr_draw_line(position + Vector2f(size/2, size/2), position + Vector2f(-size/2, size/2), 1);
      gr_draw_line(position + Vector2f(-size/2, size/2), position + Vector2f(-size/2, -size/2), 1);
      gr_draw_line(position + Vector2f(-size/2, -size/2), position + Vector2f(size/2, -size/2), 1);
      gr_draw_line(position + Vector2f(size/2, -size/2), position + Vector2f(size/2, size/2), 1);
    }
    super.render(time);
  }
}