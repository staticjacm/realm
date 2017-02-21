module world;

import std.string;
import std.stdio;
import std.math;
import dbg;
import grid;
import validatable;
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
import player;

Timer test_timer;

class World_list : LList!World {}

class World : Validatable {
  static int gid = 0;
  static World_list master_list;
  static bool type_initialized = false;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      master_list = new World_list;
    }
  }
  
  Grid2!(Area, float) grid;
  World_list.Index world_index;
  Metaobject_list metaobjects;
  int number_of_agents   = 0;
  int number_of_players  = 0;
  int id;
  bool allow_decorations = false; // allows decorations to spawn
  // bool allow_decorations = true; // allows decorations to spawn
  
  this(){
    super();
    id = gid++;
    world_index = master_list.add(this);
    metaobjects = new Metaobject_list;
    create_grid;
  }
  
  ~this(){
    world_index.remove;
    foreach(Area area; grid){
      destroy(area);
    }
    foreach(Metaobject metaobj; metaobjects){
      destroy(metaobj);
    }
  }
  
  string name(){ return "world"; }
  string description(){ return "An undefined world"; }
  string standard_article(){ return "a"; }
  
  void create_grid(){
    // grid = new Dict_grid2!(Area, float);
    grid = new Dict_array_grid2!(Area, float, 10, 10);
    // grid = new Array_grid2!(Area, float);
  }
  
  // Area* get(Vector2f position){ return grid.get(position); }
  // int opApply(scope int delegate(ref Area) dg){ return grid.opApply(dg); }
  // void set(Area area, Vector2f position){ grid.set(area, position); }
  // void remove(Vector2f position){ grid.remove(position); }
  // bool exists(Vector2f position){ return grid.exists(position); }
  // int length(){ return grid.length; }
  
  bool destroy_when_zero_agents(){ return false; }
  bool destroy_when_zero_players(){ return false; }
  void kill(){}
  
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
          area.world.grid.remove(area.position);
        area.world = this;
      }
      area.position.x = area.position.x.floor;
      area.position.y = area.position.y.floor;
      test_timer.start;
      grid.set(area, area.position);
      long timing = test_timer.hnsecs;
      debug_write_2(timing);
      connect_area_to_surroundings(area);
    }
  }
  
  Area get_area(string checks = "careful")(Vector2f position){
    test_timer.start;
    Area* areap = grid.get(position.floor);
    long timing = test_timer.hnsecs;
    debug_write_1(timing);
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
  
  /*
    Applies a function to every existing area nearby
  */
  void apply_areas_nearby(void delegate(ref Area) dg, Vector2f position, float max_distance = 1.0f){
    float r = (max_distance.ceil);
    for(float x = -r; x <= r; x++){
      for(float y = -r; y <= r; y++){
        Area area = get_area(position + Vector2f(x, y));
        if(area !is null)
          dg(area);
      }
    }
  }
  
  /*
    Applies a function to every possible location of an area (x, y) in some radius r (ie: x^2 + y^2 <= r^2)
  */
  void apply_radius(void delegate(float, float) dg, Vector2f position, float radius){
    float radius_squared = radius*radius;
    for(float x = -radius; x <= radius; x++){
      float x_squared = x*x;
      for(float y = -radius; y <= radius; y++){
        if(x_squared + y*y <= radius_squared)
          dg(position.x + x, position.y + y);
      }
    }
  }
  
  void apply_agents_nearby(void delegate(ref Agent) dg, Vector2f position, float max_distance = 1.0f){
    apply_areas_nearby((ref Area area){
      foreach(Agent agent; area.agents)
        dg(agent);
    }, position, max_distance);
  }
  
  Area_list get_areas_nearby(Vector2f position, float max_distance = 1.0f){
    Area_list ret = new Area_list;
    apply_areas_nearby((ref Area area){ ret.add(area); }, position, max_distance);
    return ret;
  }
  
  Agent_list get_agents_nearby(Vector2f position, float max_distance = 1.0f){
    Agent_list ret = new Agent_list;
    apply_agents_nearby((ref Agent agent){ ret.add(agent); }, position, max_distance);
    return ret;
  }
  
  Entity_list get_entities_nearby(Vector2f position, float max_distance = 1.0f){
    Entity_list ret = new Entity_list;
    apply_agents_nearby((ref Agent agent){
      if(agent.valid && agent.agent_subtype_id == Agent.subtype_entity)
        ret.add(cast(Entity)agent);
    }, position, max_distance);
    return ret;
  }
  
  /*
    Applies a function (of the current distance from the start, the current position, and the 
    current area) on each area it comes across
    
    It works by casting a ray repeatedly inside a unit square. Depending on where the ray hits
    inside of the unit square it will cycle back around to the other side of the square. Note
    that the direction of the ray is always the same
    
    Returning true continues, returning false breaks out of apply_raycast
    If generate is false then it will return as soon as it hits a null area
  */
  void apply_raycast(bool delegate(float, Vector2f, Area) dg, Vector2f position, Vector2f direction, bool generate = false){
    Area current_area;
    immutable(float) area_width = 1.0f, area_height = 1.0f;
    float current_distance = 0;
    if(generate)
      current_area = get_or_new_area_generate(position);
    else
      current_area = get_area(position);
    float x = position.x - floor(current_area.position.x);
    float y = position.y - floor(current_area.position.y);
    float lx, ly; // last x, y
    Vector2f current_position = position;
    while(dg(current_distance, current_position, current_area)){
      lx = x; ly = y;
      float xp, yp;
      // this determines where (xp, yp) are on the boundaries of the unit square
      if(direction.y > 0)
        xp = x + direction.x * (area_height - y) / direction.y;
      else
        xp = x - direction.x * y / direction.y;
      if(direction.x > 0)
        yp = y + direction.y * (area_width - x) / direction.x;
      else
        yp = y - direction.y * x / direction.x;
      // this replaces the current position (x, y) with the new position after
      // moving into the next area (and cycling on the boundary of the square)
      // also, here we replace the current area with the correct adjacent area
      // debug_add_line(current_position, 1);
      if( (0 <= xp) && (xp <= area_width) ) {
        x = xp;
        // bottom boundary
        if(yp < 0) {
          current_position += Vector2f(x - lx, 0 - ly);
          y = area_height;
          current_area = current_area.adjacent_b;
        }
        // upper boundary
        else {
          current_position += Vector2f(x - lx, area_height - ly);
          y = 0;
          current_area = current_area.adjacent_u;
        }
      }
      else {
        y = yp;
        // left boundary
        if(xp < 0) {
          current_position += Vector2f(0 - lx, yp - ly);
          x = area_width;
          current_area = current_area.adjacent_l;
        }
        // right boundary
        else {
          current_position += Vector2f(area_width - lx, yp - ly);
          x = 0;
          current_area = current_area.adjacent_r;
        }
      }
      current_distance += (current_position - position).norm;
      if(current_area is null){
        if(generate)
          current_area = get_or_new_area_generate(current_position);
        else
          return;
      }
    }
  }
  
  /*
    Returns the wall obtained by raycasting from position in the direction given
    If no wall is detected within a distance of max_distance then it returns null
    The generate parameter specifies whether or not the world should generate new areas as
    the ray is progressing
    
    It works by casting a ray repeatedly inside a unit square. Depending on where the ray hits
    inside of the unit square it will cycle back around to the other side of the square. Note, 
    however, that the direction of the ray is always the same
  */
  Wall get_wall_raycast(Vector2f position, Vector2f direction, float max_distance, bool generate = true){
    Area current_area;
    immutable(float) area_width = 1.0f, area_height = 1.0f;
    float current_distance = 0;
    if(generate)
      current_area = get_or_new_area_generate(position);
    else
      current_area = get_area(position);
    float x = position.x - floor(current_area.position.x);
    float y = position.y - floor(current_area.position.y);
    float lx, ly; // last x, y
    Vector2f current_position = position;
    while(current_area !is null && current_area.wall is null && current_distance < max_distance){
      lx = x; ly = y;
      float xp, yp;
      // this determines where (xp, yp) are on the boundaries of the unit square
      if(direction.y > 0)
        xp = x + direction.x * (area_height - y) / direction.y;
      else
        xp = x - direction.x * y / direction.y;
      if(direction.x > 0)
        yp = y + direction.y * (area_width - x) / direction.x;
      else
        yp = y - direction.y * x / direction.x;
      // this replaces the current position (x, y) with the new position after
      // moving into the next area (and cycling on the boundary of the square)
      // also, here we replace the current area with the correct adjacent area
      // debug_add_line(current_position, 1);
      if( (0 <= xp) && (xp <= area_width) ) {
        x = xp;
        // bottom boundary
        if(yp < 0) {
          current_position += Vector2f(x - lx, 0 - ly);
          y = area_height;
          current_area = current_area.adjacent_b;
        }
        // upper boundary
        else {
          current_position += Vector2f(x - lx, area_height - ly);
          y = 0;
          current_area = current_area.adjacent_u;
        }
      }
      else {
        y = yp;
        // left boundary
        if(xp < 0) {
          current_position += Vector2f(0 - lx, yp - ly);
          x = area_width;
          current_area = current_area.adjacent_l;
        }
        // right boundary
        else {
          current_position += Vector2f(area_width - lx, yp - ly);
          x = 0;
          current_area = current_area.adjacent_r;
        }
      }
      // debug_add_line(current_position, 2);
      current_distance += (current_position - position).norm;
      if(current_area is null){
        if(generate)
          current_area = get_or_new_area_generate(current_position);
        else
          return null;
      }
      // if(current_area is null)
      //   writefln("ca null");
      // if(current_area !is null && current_area.wall !is null)
      //   writefln("wall detected");
      // if(current_distance > max_distance)
      //   writefln("max distance"); 
    }
    if(current_area !is null && current_area.wall !is null)
      return current_area.wall;
    else
      return null;
  }
  /*
    Heres the retard version of the above (apply_raycast)
    
    The dg area parameter could be null, so watch out!
  */
  void apply_raycast_2(bool delegate(float, Vector2f, Area) dg, Vector2f position, Vector2f direction, bool generate = true, float step_size = 0.3){
    Vector2f current_position = position;
    Area current_area;
    Vector2f direction_normalized = direction.normalize;
    if(generate)
      current_area = get_or_new_area_generate(position);
    else
      current_area = get_area(position);
    while(dg((current_position - position).norm, current_position, current_area)){
      current_position += direction_normalized * step_size;
      // if(generate)
        // current_area = get_or_new_area_generate(current_position);
      // else
        // current_area = get_area(current_position);
      if(!current_area.contains(current_position)){
        if(generate)
          current_area = get_or_new_area_generate(current_position);
        else
          current_area = get_area(current_position);
      }
    }
  }
  
  Area new_area(string checks = "careful")(Vector2f position){
    static if(checks == "careful"){
      Area* area_p = grid.get(position);
      if(area_p is null){
        Area area = new Area(position.floor);
        integrate_area(area);
        return area;
      }
      else
        return *area_p;
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
      Area ret_area = new_area!"careful"(position);
      return ret_area;
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
  
  /*
    This adds a wall to an area with its position if it doesn't already have one
  */
  void add_wall(Wall wall){
    wall.position.x = floor(wall.position.x);
    wall.position.y = floor(wall.position.y);
    Area area = get_or_new_area_single(wall.position);
    if(area.wall is null)
      area.set_wall(wall);
  }
  
  void add_wall(Wall wall, Vector2f position){
    wall.position = position;
    add_wall(wall);
  }
  
  /*
    This adds a wall to an area with its position always (even if there is already a wall there)
  */
  void add_or_replace_wall(Wall wall){
    wall.position.x = floor(wall.position.x);
    wall.position.y = floor(wall.position.y);
    Area area = get_or_new_area_single(wall.position);
    area.set_wall(wall);
  }
  
  void add_or_replace_wall(Wall wall, Vector2f position){
    wall.position = position;
    add_or_replace_wall(wall);
  }
  
  /*
    This adds a ground to an area with its position if it doesn't already have one
  */
  void add_ground(Ground ground){
    ground.position.x = floor(ground.position.x);
    ground.position.y = floor(ground.position.y);
    Area area = get_or_new_area_single(ground.position);
    if(area.ground is null)
      area.set_ground(ground);
  }
  
  void add_ground(Ground ground, Vector2f position){
    ground.position = position;
    add_ground(ground);
  }
  
  /*
    This adds a ground to an area with its position always (even if there is already a ground there)
  */
  void add_or_replace_ground(Ground ground){
    ground.position.x = floor(ground.position.x);
    ground.position.y = floor(ground.position.y);
    Area area = get_or_new_area_single(ground.position);
    area.set_ground(ground);
  }
  
  void add_or_replace_ground(Ground ground, Vector2f position){
    ground.position = position;
    add_or_replace_ground(ground);
  }
  
  void remove_ground(Vector2f position){
    Vector2f get_position = Vector2f(floor(position.x), floor(position.y));
    Area area = get_area(get_position);
    if(area !is null)
      area.unset_ground;
  }
  
  void remove_wall(Vector2f position){
    Vector2f get_position = Vector2f(floor(position.x), floor(position.y));
    Area area = get_area(get_position);
    if(area !is null)
      area.unset_wall;
  }
  
  void place_agent(Agent agent){
    if(agent.world !is this){
      number_of_agents++;
      if(agent is player_entity)
        number_of_players++;
      if(agent.world !is null)
        agent.world.agent_exitted(agent);
      agent.world = this;
    }
    Area area = get_or_new_area_generate(agent.position);
    if(area !is null){
      if(area !is agent.area){
        if(agent.area !is null)
          agent.area.remove_agent(agent);
        agent.area_index.remove;
        area.add_agent(agent);
        agent.moving = true;
      }
    }
    else {
      agent.area_index.remove;
    }
  }
  
  void place_decoration(Decoration decor){
    if(allow_decorations){
      Area area = get_area(decor.position);
      if(area !is null)
        area.add_decoration(decor);
      else
        destroy(decor);
    }
    else
      destroy(decor);
  }
  
  void agent_exitted(Agent agent){
    number_of_agents--;
    // if(number_of_agents <= 0 && destroy_when_zero_agents){
    //   kill;
    //   destroy(this);
    // }
    // This likely also produces complex bugs like below
    if(agent is player_entity){
      number_of_players--;
      // if(number_of_players <= 0 && destroy_when_zero_players){
      //   kill;
      //   destroy(this);
      // }
      // This produces complex bugs for some reason
    }
  }
  
}

/*
  Tile map relation for tile mapping (the name is short to conserve memory in source files)
  (x, y) is the tile's position Vector2f(x, y)
  (r, g, b) is an arbitrary color value from a bitmap (this isn't just a single field because
  copying color values from an image editor is really easy compared to reducing those rgb
  colors to a single field, or any of the other ways of doing it)
*/
struct Tmr {
  int x, y;
  int r,g,b;
}