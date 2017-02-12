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
  Area_list.Index update_index; // Its index in Area.update_list - so it will update
  Agent_list agents; // Mobile objects
  Decoration_list decorations;
  Vector2f position;
  // Holding adjacencies might not be necessary
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
    world.grid.remove(position);
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
  
  /*
    Does agent fit without any collisions with walls?
  */
  bool agent_fits(Agent agent){
    if(agent.interacts_with_walls){
      int range = cast(int)((1.5*fmax(agent.collider_size_x, agent.collider_size_y) + 1.0f).floor);
      // int range_x = cast(int)((agent.collider_size_x + 1.0).floor);
      // int range_y = cast(int)((agent.collider_size_y + 1.0).floor);
      for(int xd = -range; xd <= range; xd++){
        for(int yd = -range; yd <= range; yd++){
          Area area = world.get_area(position + Vector2f(cast(float)xd, cast(float)yd));
          if(area !is null && area.wall !is null && area.wall.interacts){
            Vector2f_2* collision_result = area.wall.test_for_collision(agent);
            if(collision_result !is null)
              return false;
          }
        }
      }
    }
    return true;
  }
  
  void agent_do_collisions(Agent agent){
    // Checking collision between agent and agents in a range
    int range = cast(int)((1.5*fmax(agent.collider_size_x, agent.collider_size_y) + 1.0f).floor);
    // int range_x = cast(int)((agent.collider_size_x + 1.0).floor);
    // int range_y = cast(int)((agent.collider_size_y + 1.0).floor);
    for(int xd = -range; xd <= range; xd++){
      for(int yd = -range; yd <= range; yd++){
        Area area = world.get_area(position + Vector2f(cast(float)xd, cast(float)yd));
        if(area !is null){
          if(agent.interacts_with_agents){
            foreach(Agent check_agent; area.agents){
              if(agent !is check_agent && agent.fast_test_for_collision(check_agent) && check_agent.id > agent.id){
                Vector2f_2* collision_result = agent.test_for_collision(check_agent);
                if(collision_result !is null){
                  // agent or checkagent might be killed here, so check validity
                  agent.block(check_agent, collision_result.x, collision_result.y);
                  agent.collide_agent_subtype(check_agent);
                  if(check_agent.valid)
                    check_agent.collide_agent_subtype(agent);
                  if(!agent.valid)
                    return;
                }
              }
            }
          }
          if(agent.interacts_with_walls && area.wall !is null && area.wall.interacts){
            Vector2f_2* collision_result = area.wall.test_for_collision(agent);
            if(collision_result !is null){
              agent.collide(area.wall);
              if(!agent.valid)
                return;
              else if(area.wall.valid){
                area.wall.collision_block(agent, collision_result.x, collision_result.y);
                area.wall.collide(agent);
              }
            }
          }
        }
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
    
    if(wall !is null && wall.interacts){
      foreach(Agent agent; agents){
        if(agent.interacts_with_walls){
          agent.collide(wall);
          if(!agent.valid)
            continue;
          else if(wall.valid){
            wall.collision_block(agent, agent.position, agent.velocity);
            wall.collide(agent);
          }
        }
      }
    }
    
    // Collision detecting agents
    foreach(Agent agent; agents){
      agent_do_collisions(agent);
    }
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
  
  bool contains(Vector2f point){
    return ( (position.x <= point.x) && (point.x <= position.x + 1) && 
             (position.y <= point.y) && (point.y <= position.y + 1) );
  }
  
  void add_agent(Agent agent){
    if(contains(agent.position)){
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


