module renderable;

import std.stdio;
import refable;
import vector;
import animation;

class Renderable : Refable {
  float height = 0;
  float angle = 0;
  Vector2f position;
  Animation animation;
  
  this(Vector2f _position){
    position = _position;
  }
  
  override void destroy(){
    animation.destroy;
    animation = null;
    super.destroy;
  }
  
  bool y_shift(){ return true; }
  float render_depth(){ return 10.0f; }
  
  void render(long time){
    if(animation !is null){
      if(y_shift){
        if(height > 0)
          gr_draw(animation, position + Vector2f(0, height), render_depth + position.y, angle);
        else
          gr_draw(animation, position, render_depth + position.y, angle);
      }
      else {
        if(height > 0)
          gr_draw(animation, position + Vector2f(0, height), render_depth, angle);
        else
          gr_draw(animation, position, render_depth, angle);
      }
    }
  }
}