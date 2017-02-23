module ground;

import std.stdio;
import animation;
import game;
import vector;
import entity;
import agent;
import rooted;

class Ground : Rooted {
  
  this(){
    super();
  }
  
  override string name(){ return "Ground"; }
  override string description(){ return "An undefined ground"; }
  override string standard_article(){ return "a"; }
  
  override int rooted_subtype_id(){ return Rooted.subtype_ground; }
  
  override bool interacts(){ return false; }
  
  float friction(){ return 30.0f; }
  // max_speed_mod multiplies on entity max_speed values
  float max_speed_mod(){ return 1.0f; }
  
  void render_under(Entity entity){}
  
  void collide(Agent agent){}
  void entered(Agent agent){}
  void exited(Agent agent){}
  
  float height(){ return 0; }// Vertical offset for agents near or below zero height
  
  override void render(){
    if(flip_horizontally)
      gr_draw_flipped_horizontally(animation.update(game_time), position, render_depth, angle + render_angle, 1.0f);
    else  
      gr_draw(animation.update(game_time), position, render_depth, angle + render_angle, 1.0f);
    super.render;
  }
}