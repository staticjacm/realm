module area;
/++
Responsibilities:
  Collision detection between agents and rooted objects
  Updating rooted objects

+/

import std.stdio;
import std.string;
import std.math;
import game;
import refable;
import world;
import ground;
import wall;
import agent;
import vector;
import sgogl_interface;

alias Vector2f = Vector2!float;

bool draw_boundaries = false;

class Area {
  static int gid = 0;
  static const(float) area_width = 1.0f, area_height = 1.0f;
  
  int id = 0;
  int object_count = 0;
  World world;
  Wall wall;
  Ground ground;
  Agent_list agents; /// Mobile objects
  Vector2f position;
  /// Holding adjacencies might not be necessary
  Area adjacent_ul, adjacent_u, adjacent_ur, adjacent_l, adjacent_r, adjacent_bl, adjacent_b, adjacent_br;
  
  this(Vector2f _position){
    id = gid++;
    position = _position;
    agents = new Agent_list;
  }
  
  void destroy(){
    foreach(Agent agent; agents){
      agent.area = null;
    }
    unset_wall;
    unset_ground;
    if(agents !is null)
      agents.destroy;
    world.remove(position);
    object.destroy(this);
  }
  
  override string toString(){ return format("area %d", id); }
  
  void update(){
    bool emptyq = false;
    
    if(ground !is null && ground.interacts){
      foreach(Agent agent; agents){
        ground.under(agent);
        agent.over(ground);
      }
    }
    
    
    // Collision detecting agents
    foreach(Agent agent; agents){
      // Checking collision between agents and agents in a range
      int range = cast(int)((agent.size/2 + 1.0).floor);
      for(int xd = -range; xd <= range; xd++){
        for(int yd = -range; yd <= range; yd++){
          Area check_area = world.get_area(position + Vector2f(cast(float)xd, cast(float)yd));
          if(check_area !is null){
            foreach(Agent check_agent; check_area.agents){
              if(agent !is check_agent && agent.check_for_overlap(check_agent)){
                // writeln(agent, " overlapped ", check_agent);
                agent.overlap(check_agent);
                check_agent.overlap(agent);
              }
            }
          }
        }
      }
      // Checking collisions between agent and surrounding walls
      // Theres probably a faster / more consise way to do this
      if(agent.position.x - agent.size/2 < position.x){
        Area collider_area = world.get_area(position + Vector2f(-1, 0));
        if(collider_area !is null && collider_area.wall !is null && collider_area.wall.interacts){
          agent.collide(collider_area.wall);
          collider_area.wall.collide(agent);
        }
      }
      else if(position.x + 1 < agent.position.x + agent.size/2){
        Area collider_area = world.get_area(position + Vector2f(1, 0));
        if(collider_area !is null && collider_area.wall !is null && collider_area.wall.interacts){
          agent.collide(collider_area.wall);
          collider_area.wall.collide(agent);
        }
      }
      if(agent.position.y - agent.size/2 < position.y){
        Area collider_area = world.get_area(position + Vector2f(0, -1));
        if(collider_area !is null && collider_area.wall !is null && collider_area.wall.interacts){
          agent.collide(collider_area.wall);
          collider_area.wall.collide(agent);
        }
      }
      else if(position.y + 1 < agent.position.y + agent.size/2){
        Area collider_area = world.get_area(position + Vector2f(0, 1));
        if(collider_area !is null && collider_area.wall !is null && collider_area.wall.interacts){
          agent.collide(collider_area.wall);
          collider_area.wall.collide(agent);
        }
      }
    }
    if(agents.length > 0)
      emptyq = false;
    if(emptyq)
      destroy;
    
  }
  
  void render(){
    if(point_in_view(position)){
      if(draw_boundaries){
        gr_draw_line([position, position + Vector2f(1, 0), position + Vector2f(1, 1), position + Vector2f(0, 1)], 1.0f);
      }
      if(ground !is null)
        ground.render;
      if(wall !is null)
        wall.render;
    }
  }
  
  bool inside(Vector2f point){
    return ( (position.x <= point.x) && (point.x <= position.x + 1) && 
             (position.y <= point.y) && (point.y <= position.y + 1) );
  }
  
  void add_agent(Agent agent){
    if(inside(agent.position)){
      agent.area = this;
      agent.area_index = agents.add(agent);
      if(ground !is null)
        ground.entered(agent);
    }
    else
      agent.area_index.remove;
  }
  
  void remove_agent(Agent agent){
    if(agent.area is this){
      agent.area_index.remove;
      if(ground !is null)
        ground.exited(agent);
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


