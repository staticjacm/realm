module wall;

import std.stdio;
import std.math;
import animation;
import game;
import sgogl_interface;
import collision;
import vector;
import agent;
import rooted;

class Wall : Rooted {
  
  bool draw_colliders = false;
  
  this(){
    super();
  }
  
  // Damage must be above this amount for the wall to be destroyed
  float destruction_damage_threshold(){ return 10_000.0f; }
  
  override string name(){ return "wall"; }
  override string description(){ return "An undefined wall"; }
  override string standard_article(){ return "a"; }
  
  override int rooted_subtype_id(){ return Rooted.subtype_wall; }
  
  override bool interacts(){ return true; }
  
  float restitution(){ return 1.0; }
  
  /*
    Checks for a collision between this square wall and the rotated-rectangle agent
  */
  Vector2f_2* test_for_collision(Agent agent){
    return test_for_collision_asqr_crect(
      position, 1.0f,
      agent.position, agent.collider_size_x, agent.collider_size_y, agent.collider_angle
    );
  }
  
  // Heres where the wall causes an agent to recoil, move away, etc
  void collision_block(Agent agent, Vector2f collision_point, Vector2f collision_normal){
    if(agent !is null && agent.valid){
      /*
        With walls we always want the normal vectors to be the usual unit vectors
        so we use quadrant_vector to get the closest unit vector
      */
      Vector2f pdif_normal = Vector2f(agent.position.x - (position.x + 0.5f), agent.position.y - (position.y + 0.5f)).quadrant_vector;
      if(agent.velocity.dot(pdif_normal) < 0){
        // agent.set_velocity = agent.velocity.reflect(pdif_normal)*restitution*agent.restitution;
        Vector2f vdelta = agent.velocity.proj(pdif_normal);
        agent.set_velocity = agent.velocity - vdelta - vdelta*restitution*agent.restitution;
      }
      agent.set_position = agent.position + pdif_normal * 0.1; // Access violation error here
    }
  }
  
  void collide(Agent agent){}
  
  override void render(){
    if(draw_colliders){
      Vector2f w1 = Vector2f(position.x, position.y);
      Vector2f w2 = Vector2f(position.x + 1.0f, position.y);
      Vector2f w3 = Vector2f(position.x + 1.0f, position.y + 1.0f);
      Vector2f w4 = Vector2f(position.x, position.y + 1.0f);
      Vector2f wx = w2 - w1;
      Vector2f wy = w4 - w1;
      gr_draw_line(w1, w2, 1);
      gr_draw_line(w2, w3, 1);
      gr_draw_line(w3, w4, 1);
      gr_draw_line(w4, w1, 1);
    }
    if(flip_horizontally)
      gr_draw_tilted_flipped_horizontally(animation.update(game_time), position, render_depth, 1.0f, angle + render_angle, 1.0f);
    else 
      // writefln("this %b valid %b animation %b type %s", this !is null, valid, animation !is null, name);
      gr_draw_tilted(animation.update(game_time), position, render_depth, 1.0f, angle + render_angle, 1.0f);
    super.render;
  }
}
