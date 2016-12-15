module world;

import std.stdio;
import std.math;
import grid;
import decoration;
import game;
import vector;
import sllist;
import wall;
import ground;
import agent;
import entity;
import area;
import metaobject;
import timer;

Timer test_timer;

alias world_grid_type = Dict_grid2!(Area, float);

class World_list : LList!World {}

class World : world_grid_type {
  static World_list master_list;
  static bool type_initialized = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      master_list = new World_list;
    }
  }
  
  World_list.Index world_index;
  Metaobject_list metaobjects;
  
  this(){
    super();
    world_index = master_list.add(this);
    metaobjects = new Metaobject_list;
  }
  
  ~this(){
    world_index.remove;
    foreach(Area area; this){
      destroy(area);
    }
    foreach(Metaobject metaobj; metaobjects){
      destroy(metaobj);
    }
  }
  
  void update(){}
  
  void initialize(){}
  
  /// For rendering full screen effects (?)
  void render(){}
  
  void connect_area_to_surroundings(Area area){
    Vector2f position = area.position;
    area.adjacent_ul  = get_area(position + Vector2f(-1, 1));
    area.adjacent_u   = get_area(position + Vector2f(0, 1));
    area.adjacent_ur  = get_area(position + Vector2f(1, 1));
    area.adjacent_l   = get_area(position + Vector2f(-1, 0));
    area.adjacent_r   = get_area(position + Vector2f(1, 0));
    area.adjacent_bl  = get_area(position + Vector2f(-1, -1));
    area.adjacent_b   = get_area(position + Vector2f(0, -1));
    area.adjacent_br  = get_area(position + Vector2f(1, -1));
  }
  
  ///// Procedurally generates a new area. Usually used with areas generated at the location of agents
  //void generate_area(Area area){}
  //bool generate_adjacent_areas(){ return false; }
  ///// Procedurally generates a new area. Usually used with areas adjacent to generate_area's area
  //void generate_adjacent_area(Area area){}
  Area generate_area(Vector2f position){ return null; }
  
  //Area new_area(Vector2f position){
  //  Area area = new Area(Vector2f(position.x.floor, position.y.floor));
  //  integrate_area(area);
  //  return area;
  //}
  
  void integrate_area(Area area){
    if(area !is null){
      if(area.world !is this){
        if(area.world !is null)
          area.world.remove(area.position);
        area.world = this;
      }
      area.position.x = area.position.x.floor;
      area.position.y = area.position.y.floor;
      set(area, area.position);
      connect_area_to_surroundings(area);
    }
  }
  
  Area get_area(string checks = "careful")(Vector2f position){
    Area* areap = get(position.floor);
    static if(checks == "careful"){
      if(areap !is null)
        return *areap;
      else
        return null;
    }
    else static if(checks == "careless"){
      return *areap;
    }
  }
  
  Area new_area(string checks = "careful")(Vector2f position){
    static if(checks == "careful"){
      if(!exists(position)){
        Area area = new Area(position.floor);
        integrate_area(area);
        return area;
      }
      else
        return null;
    }
    else static if(checks == "careless"){
      Area area = new Area(position.floor);
      integrate_area(area);
      return area;
    }
  }
  
  Area get_or_new_area_single(Vector2f position){
    Area area = get_area(position);
    if(area is null){
      return new_area!"careful"(position);
    }
    else
      return area;
  }
  
  Area get_or_new_area_generate(Vector2f position){
    Area area = get_area(position);
    if(area is null){
      Area generated_area = generate_area(position);
      return generated_area;
    }
    else
      return area;
  }
  
  void add_wall(Wall wall){
    wall.position.x = floor(wall.position.x);
    wall.position.y = floor(wall.position.y);
    get_or_new_area_single(wall.position).set_wall(wall);
  }
  
  void add_ground(Ground ground){
    ground.position.x = floor(ground.position.x);
    ground.position.y = floor(ground.position.y);
    get_or_new_area_single(ground.position).set_ground(ground);
  }
  
  void place_agent(Agent agent){
    Area area = get_or_new_area_generate(agent.position);
    if(area !is null){
      if(area !is agent.area){
        if(agent.area !is null)
          agent.area.remove_agent(agent);
        agent.area_index.remove;
        area.add_agent(agent);
      }
    }
    else {
      agent.area_index.remove;
    }
  }
  
  void place_decoration(Decoration decor){
    Area area = get_area(decor.position);
    if(area !is null)
      area.add_decoration(decor);
    else
      destroy(decor);
  }
  
}