
module physical;

import std.conv;
import world;
import area;
import vector;
import collidable;
import material;
import animation;
import sllist;

alias Vector2f = Vector2!float;

float under_render_depth = 1000;
float level_render_depth = 100;
float over_render_depth  = 1;


/++
++/
class Physical : Refable {
  
  
  override string toString(){ return "Physical "~id.to!string; }
  
  void destroy(){
    super.destroy();
  }
  
  
  
  
}