module renderable;

import std.stdio;
import refable;
import game;
import vector;
import animation;

class Renderable : Refable {
  float height = 0;
  float angle = 0;
  Vector2f position;
  Animation animation;
  
  this(Vector2f _position){
    super();
    position = _position;
  }
  
  override void destroy(){
    super.destroy;
  }
  
  /// The angle to compensate for the rotation of the image when rendering
  float render_angle(){ return 0; }
  bool y_shift(){ return true; }
  float render_depth(){ return 10.0f; }
  
  void render(){
    if(animation !is null){
      if(y_shift){
        if(height > 0)
          gr_draw(animation.update(game_time), position + Vector2f(0, height), render_depth + position.y, angle + render_angle);
        else
          gr_draw(animation.update(game_time), position, render_depth + position.y, angle + render_angle);
      }
      else {
        if(height > 0)
          gr_draw(animation.update(game_time), position + Vector2f(0, height), render_depth, angle + render_angle);
        else
          gr_draw(animation.update(game_time), position, render_depth, angle + render_angle);
      }
    }
  }
}