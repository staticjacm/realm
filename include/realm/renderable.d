module renderable;

import core.thread;
import std.parallelism;
import std.concurrency;
import std.stdio;
import std.string;
import dbg;
import sgogl;
import validatable;
import game;
import vector;
import animation;

class Renderable : Validatable {
  static bool type_initialized = false;
  static uint shadow_image_32x32;
  
  static initialize_type(){
    if(!type_initialized){
      shadow_image_32x32 = gr_load_image("assets/shadow_32x32.png".toStringz, 0);
    }
  }
  
  float height = 0;
  float angle = 0;
  Vector2f position;
  bool flip_horizontally = false;
  Animation animation;
  
  this(){
    super();
  }
  ~this(){
    if(animation !is null)
      destroy(animation);
  }
  
  // Call just before a standard removal (example: shot hits wall, this controls effects before shot is destroyed)
  void kill(){}
  
  /// The angle to compensate for the rotation of the image when rendering
  float render_angle(){ return 0; }
  bool y_shift(){ return true; } /// Should the animation's depth be shifted by its position.y ?
  float render_depth(){ return 1000.0f; }
  
  bool draw_shadow(){ return false; }
  uint shadow_image(){ return shadow_image_32x32; }
  
  void set_position(Vector2f new_position){
    position = new_position;
  }
  void set_position(float x, float y){
    position = Vector2f(x, y);
  }
  void set_position(int x, int y){
    position = Vector2f(cast(float)x, cast(float)y);
  }
  
  void render(){
    if(draw_shadow)
      gr_draw_centered(shadow_image, position.x, position.y, render_depth + position.y + 1.0, 0.0f, 1.0f, 0.5f);
    
    // if(animation !is null && animation.valid){
    //   if(y_shift){
    //      if(draw_shadow)
    //       // gr_draw_centered(shadow_image, position.x, position.y, render_depth + position.y + 1.0, 0.0f, 1.0f, 0.5f);
    //     if(height > 0){
    //       if(flip_horizontally)
    //         gr_draw_flipped_horizontally(animation.update(game_time), position + Vector2f(0, height), render_depth + position.y, angle + render_angle);
    //       else  
    //         gr_draw(animation.update(game_time), position + Vector2f(0, height), render_depth + position.y, angle + render_angle);
    //     }
    //     else{
    //       if(flip_horizontally)
    //         gr_draw_flipped_horizontally(animation.update(game_time), position, render_depth + position.y, angle + render_angle);
    //       else  
    //         gr_draw(animation.update(game_time), position, render_depth + position.y, angle + render_angle);
    //     }
    //   }
    //   else {
    //     // if(draw_shadow)
    //       // gr_draw_centered(shadow_image, position.x, position.y, render_depth + 1.0, 0.0f, 1.0f, 0.5f);
    //     if(height > 0){
    //       if(flip_horizontally)
    //         gr_draw_flipped_horizontally(animation.update(game_time), position + Vector2f(0, height), render_depth, angle + render_angle);
    //       else
    //         gr_draw(animation.update(game_time), position + Vector2f(0, height), render_depth, angle + render_angle);
    //     }
    //     else{
    //       if(flip_horizontally)
    //         gr_draw_flipped_horizontally(animation.update(game_time), position, render_depth, angle + render_angle);
    //       else
    //         gr_draw(animation.update(game_time), position, render_depth, angle + render_angle);
    //     }
    //   }
    // }
  }
}