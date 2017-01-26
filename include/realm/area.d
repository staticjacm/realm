module area;
/++
Responsibilities:
  Collision detection between agents and rooted objects
  Updating rooted objects

+/

import std.stdio;
import std.string;
import std.math;
import decoration;
import game;
import validatable;
import world;
import ground;
import wall;
import agent;
import vector;
import sllist;
import sgogl_interface;

alias Vector2f = Vector2!float;

bool draw_boundaries = false;

class Area_list : LList!Area {}

class Area : Validatable {
  static Area_list update_list;
  static bool type_initialized = false;
  static int gid = 0;
  static int total_number = 0;
  static const(float) area_width = 1.0f, area_height = 1.0f;
  
  static initialize_type(){
    if(!type_initialized){
      update_list = new Area_list;
    }
  }
  
  int id = 0;
  int object_count = 0;
  World world;
  Wall wall;
  Ground ground;
  Area_list.Index update_index; /// Its index in Area.update_list - so it will update
  Agent_list agents; /// Mobile objects
  Decoration_list decorations;
  Vector2f position;
  /// Holding adjacencies might not be necessary
  Area adjacent_ul, adjacent_u, adjacent_ur, adjacent_l, adjacent_r, adjacent_bl, adjacent_b, adjacent_br;
  
  this(Vector2f _position){
    id = gid++;
    position = _position;
    agents = new Agent_list;
    decorations = new Decoration_list;
    total_number++;
  }
  
  ~this(){
    if(agents !is null){
      foreach(Agent agent; agents){
        agent.area = null;
      }
      destroy(agents);
    }
    if(decorations !is null){
      foreach(Decoration decor; decorations)
        destroy(decor);
      destroy(decorations);
    }
    update_index.remove;
    unset_wall;
    unset_ground;
    total_number--;
    world.remove(position);
  }
  
  override string toString(){ return format("area %d", id); }
  
  bool updates(){ return update_index.valid; }
  
  void set_updating(bool ud){
    if(ud){
      if(!update_index.valid){
        update_index = update_list.add(this);
      }
    }
    else{
      if(update_index.valid){
        update_index.remove;
      }
    }
  }
  
  void update(){
    bool emptyq = false;
    
    if(ground !is null && ground.interacts){
      foreach(Agent agent; agents){
        if(agent.interacts_with_grounds){
          ground.collide(agent);
          agent.collide(ground);
        }
      }
    }
    
    // Collision detecting agents
    first: foreach(Agent agent; agents){
      // Checking collision between agents and agents in a range
      int range = cast(int)((1.5*fmax(agent.collider_size_x, agent.collider_size_y) + 1.0f).floor);
      // int range_x = cast(int)((agent.collider_size_x + 1.0).floor);
      // int range_y = cast(int)((agent.collider_size_y + 1.0).floor);
      for(int xd = -range; xd <= range; xd++){
        for(int yd = -range; yd <= range; yd++){
          Area area = world.get_area(position + Vector2f(cast(float)xd, cast(float)yd));
          if(area !is null){
            if(agent.interacts_with_agents){
              foreach(Agent check_agent; area.agents){
                if(agent !is check_agent && agent.fast_test_for_collision(check_agent)){
                  Vector2f_2* collision_result = agent.test_for_collision(check_agent);
                  if(collision_result !is null){
                    // agent or checkagent might be killed here, so check validity
                    agent.block(check_agent, collision_result.x, collision_result.y);
                    agent.collide_agent_subtype(check_agent);
                    if(check_agent.valid)
                      check_agent.collide_agent_subtype(agent);
                    if(!agent.valid)
                      continue first;
                  }
                }
              }
            }
            if(agent.interacts_with_walls && area.wall !is null && area.wall.interacts){
              Vector2f_2* collision_result = area.wall.test_for_collision(agent);
              if(collision_result !is null){
                agent.collide(area.wall);
                if(agent.valid && area.wall.valid){
                  area.wall.collision_block(agent, collision_result.x, collision_result.y);
                  area.wall.collide(agent);
                }
              }
            }
          }
        }
      }
    }
      /*
        rough chekc for agent - wall collisions
        if(((position.x <= agent.position.x + agent.collider_size_x) &&
        (position.y <= agent.position.y + agent.collider_size_y)) ||
        ((position.x + 1.0f >= agent.position.x - agent.collider_size_x) &&
        (position.y  + 1.0f >= agent.position.y - agent.collider_size_y)))
      */
      //if(agent.interacts_with_walls){
      //  void do_collisions(Agent agent, Area area){
      //    if(area !is null && area.wall !is null && area.wall.interacts && area.wall.test_for_collision(agent)){
      //      agent.collide(area.wall);
      //      area.wall.collide(agent);
      //    }
      //  }
      //  // Checking collisions between agent and surrounding walls
      //  // Theres probably a faster / more concise way to do this
      //  if(agent.position.x - agent.collider_size_x < position.x){
      //    Area collider_area = world.get_area(position + Vector2f(-1, 0));
      //    do_collisions(agent, collider_area);
      //    // if(collider_area !is null && collider_area.wall !is null && collider_area.wall.interacts){
      //      // agent.collide(collider_area.wall);
      //      // collider_area.wall.collide(agent);
      //    // }
      //  }
      //  if(position.x + 1 < agent.position.x + agent.collider_size_x){
      //    Area collider_area = world.get_area(position + Vector2f(1, 0));
      //    do_collisions(agent, collider_area);
      //  }
      //  if(agent.position.y - agent.collider_size_y < position.y){
      //    Area collider_area = world.get_area(position + Vector2f(0, -1));
      //    do_collisions(agent, collider_area);
      //  }
      //  if(position.y + 1 < agent.position.y + agent.collider_size_y){
      //    Area collider_area = world.get_area(position + Vector2f(0, 1));
      //    do_collisions(agent, collider_area);
      //  }
      //}
    if(agents.length > 0)
      emptyq = false;
    else
      set_updating = false;
    if(emptyq)
      destroy(this);
    
  }
  
  void render(string checks = "careful")(){
    static if(checks == "careful"){
      if(point_in_view(position)){
        if(draw_boundaries){
          gr_draw_line([position, position + Vector2f(1, 0), position + Vector2f(1, 1), position + Vector2f(0, 1)], 1.0f);
        }
        if(ground !is null)
          ground.render;
        if(wall !is null)
          wall.render;
        foreach(Agent agent; agents){
          agent.render;
        }
        foreach(Decoration decor; decorations){
          decor.render;
        }
      }
    }
    else if(checks == "careless"){
      if(draw_boundaries){
        gr_draw_line([position, position + Vector2f(1, 0), position + Vector2f(1, 1), position + Vector2f(0, 1)], 1.0f);
      }
      if(ground !is null)
        ground.render;
      if(wall !is null)
        wall.render;
      foreach(Agent agent; agents){
        agent.render;
      }
      foreach(Decoration decor; decorations){
        decor.render;
      }
    }
  }
  
  bool inside(Vector2f point){
    return ( (position.x <= point.x) && (point.x <= position.x + 1) && 
             (position.y <= point.y) && (point.y <= position.y + 1) );
  }
  
  void add_agent(Agent agent){
    if(inside(agent.position)){
      agent.area = this;
      set_updating = true;
      agent.area_index = agents.add(agent);
      if(ground !is null)
        ground.entered(agent);
    }
    else
      agent.area_index.remove;
  }
  
  void add_decoration(Decoration decor){
    decor.area_index = decorations.add(decor);
  }
  
  void remove_agent(Agent agent){
    if(agent.area is this){
      agent.area_index.remove;
      if(ground !is null)
        ground.exited(agent);
    }
    if(agents.length == 0)
      set_updating = false;
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
        destroy(wall);
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
        destroy(ground);
      }
      ground = null;
    }
  }
}


