
module agent;

import std.stdio;
import std.string;
import std.math;
import collision;
import game;
import world;
import area;
import effect;
import entity;
import drop;
import portal;
import shot;
import wall;
import ground;
import material;
import vector;
import renderable;
import validatable;
import sllist;
import sgogl;
import sgogl_interface;

alias Vector2f = Vector2!float;

/*
  Proxy class from LList!AgentR
*/
class Agent_list : LList!Agent {}

/*
  Represents a physical object that can inhabit a world.
  A conceptual abstract of floating (can move freely between grid locations) objects
  Each agent has a size for collision detection purposes
*/
class Agent : Renderable {
  /*
    subtype_*s are so the actual agent subtype of an object can be known at compile time
  */
  static enum {
    subtype_none,
    subtype_shot,
    subtype_portal,
    subtype_drop,
    subtype_entity
  };
  
  static bool type_initialized = false;
  static int gid = 0;
  static Agent_list master_list;
  static draw_colliders = false;
  
  static initialize_type(){
    if(!type_initialized){
      super.initialize_type;
      master_list = new Agent_list;
    }
  }
  
  static render_all(){
    foreach(Agent agent; master_list){
      agent.render;
    }
  }
  
  static update_all(){
    foreach(Agent agent; master_list){
      agent.update;
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
  float stop_speed = 0.01f;
  float mass = 1;
  bool moving = false; // is its velocity nonzero?
  bool moved = false; // has the agent been moved since it was last placed?
  float height = 0; // How high off the ground is it?
  // float size = 1; // How large is it (for collision detection)
  // float friction = 1.0;
  float restitution = 1.0;
  int faction_id = 0; // determines what faction the agent belongs to - primarily for determining who hurts / targets who
  /*
    An agent's collider is the shape which determines when and how it collides with other agents and with walls
    It is a rectangle with center at the agent's position which is rotated by some angle
  */
  float collider_size_x = 1.0f, collider_size_y = 1.0f, collider_angle = 0.0f;
  Vector2f collider_offset = Vector2f(0, 0);
  bool interacts_with_agents  = true;
  bool interacts_with_walls   = true;
  bool interacts_with_grounds = true;
  
  /++
    Constructors & Destructors
  ++/
  this(){
    super();
    id = gid++;
    master_index = master_list.add_front(this);
  }
  ~this(){
    master_index.remove;
    if(area !is null && area.valid){
      area.remove_agent(this);
      area_index.remove;
    }
    if(material !is null && material.valid)
      destroy(material);
  }
  
  
  int agent_subtype_id(){ return subtype_none; }
  
  override string toString(){ return format("agent %d", id); }
  
  /++
    Updating & Collision detection
  ++/
  void update(){
    // move_by(Vector2f(0.03, 0));
    if(material !is null)
      material.update;
    if(moving){
      if(uses_friction && area !is null && area.ground !is null && area.ground.valid && area.ground.friction != 0)
        accelerate(-velocity*area.ground.friction*10.0f);
        // ^ should be accelerate(-velocity.normalize*friction*K);
      move_by(velocity*frame_delta);
      if(world !is null && moved){
        world.place_agent(this);
        moved = false;
      }
    }
  }
  
  void set_position(Vector2f new_position){
    position = new_position;
    moved = true;
  }
  
  bool fast_test_for_collision(Agent agent){
    return (abs(position.x - agent.position.x) < (collider_size_x + agent.collider_size_x)) &&
           (abs(position.y - agent.position.y) < (collider_size_y + agent.collider_size_y))   ;
  }
  Vector2f_2* test_for_collision(Wall wall){
    return wall.test_for_collision(this);
  }
  void block(Agent agent, Vector2f collision_point, Vector2f collision_normal){}
  /*
    Checks for a collision between this rotated-rectangle agent and another
    Feels really fucked up tbh fam
  */
  Vector2f_2* test_for_collision(Agent agent){
    return test_for_collision_crect_crect(
      position, collider_size_x, collider_size_y, collider_angle, 
      agent.position, agent.collider_size_x, agent.collider_size_y, agent.collider_angle
    );
  }
  // bool interacts(T : Agent)(){  return true; }
  // bool interacts(T : Wall)(){   return true; }
  // bool interacts(T : Ground)(){ return true; }
  /// void overlap(Agent) is called when a collision is detected (this's and agent's collision squares intersect)
  void collide(Entity entity){
    if(material !is null)
      material.collide(entity);
  }
  void collide(Portal portal){
    if(material !is null)
      material.collide(portal);
  }
  void collide(Shot shot){
    if(material !is null)
      material.collide(shot);
  }
  void collide(Drop drop){
    if(material !is null)
      material.collide(drop);
  }
  void collide(Agent agent){
    // Vector2f pdif = this.position - agent.position;
    // accelerate(pdif*0.1f);
    if(material !is null)
      material.collide(agent);
  }
  void collide_agent_subtype(Agent agent){
    if(agent !is null && agent.valid){
      collide(agent);
      switch(agent.agent_subtype_id){
        case subtype_none:
        default: break;
        case subtype_entity: collide(cast(Entity)agent);  break;
        case subtype_shot:   collide(cast(Shot)agent);      break;
        case subtype_drop:   collide(cast(Drop)agent);      break;
        case subtype_portal: collide(cast(Portal)agent);  break;
      }
    }
  }
  void collide(Wall wall){
    if(material !is null)
      material.collide(wall);
  }
  void collide(Ground ground){
    if(material !is null)
      material.collide(ground);
  }
  
  /++
    Movement Dynamics
  ++/
  void accelerate(Vector2f acceleration){
    velocity += acceleration*frame_delta;
    if(abs(velocity.x - stop_speed) > stop_speed || abs(velocity.y - stop_speed) > stop_speed)
      moving = true;
    else {
      velocity.x = 0;
      velocity.y = 0;
      moving = false;
    }
  }
  void apply_impulse(Vector2f force){
    accelerate(force/mass);
  }
  void set_velocity(Vector2f new_velocity){
    velocity = new_velocity;
    if(abs(velocity.x - stop_speed) > stop_speed || abs(velocity.y - stop_speed) > stop_speed)
      moving = true;
    else
      moving = false;
  }
  float speed(){ return velocity.norm; }
  bool uses_friction(){ return true; }
  
  void move_by(Vector2f delta){
    if(delta.x != 0 || delta.y != 0){
      position += delta;
      moved = true;
    }
    // position += Vector2f(0.01, 0);
  }
  void move_to(Vector2f new_position){
    if(new_position.x != position.x || new_position.y != position.y){
      position = new_position;
      moved = true;
    }
  }
  
  Shot create_shot(Shot shot){
    shot.position = position;
    shot.world = world;
    shot.faction_id = faction_id;
    return shot;
  }
  
  // For use by player_entity when E-activating something
  void activate(Agent agent){}
  
  /++
    Rendering
  ++/
  override float render_depth(){ return 100; }
  override void render(){
    if(draw_colliders){
      float cosangle = cos(collider_angle);
      float sinangle = sin(collider_angle);
      Vector2f a1 = position + Vector2f(- collider_size_x * cosangle + collider_size_y * sinangle,
                                        - collider_size_x * sinangle - collider_size_y * cosangle);
      Vector2f a2 = position + Vector2f(  collider_size_x * cosangle + collider_size_y * sinangle,
                                          collider_size_x * sinangle - collider_size_y * cosangle);
      Vector2f a3 = position + Vector2f(  collider_size_x * cosangle - collider_size_y * sinangle,
                                          collider_size_x * sinangle + collider_size_y * cosangle);
      Vector2f a4 = position + Vector2f(- collider_size_x * cosangle - collider_size_y * sinangle,
                                        - collider_size_x * sinangle + collider_size_y * cosangle);
      gr_color_alpha(1);
      gr_draw_line(a1, a2, 1);
      gr_draw_line(a2, a3, 1);
      gr_draw_line(a3, a4, 1);
      gr_draw_line(a4, a1, 1);
    }
    super.render;
  }
}