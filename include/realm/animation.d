
module animation;

import std.stdio;
import vector;
import sgogl;
import validatable;

alias Vector2f = Vector2!float;

/++
Iterates through a list of uints when playing
uints correspond to sgogl images
also contains anchor (anx, any) information and scale (sx, sy) information
++/
class Animation : Validatable {
  uint[] frames;
  int frame_delay = 1; // how long a frame lasts
  int current_frame_index = 0;
  long current_frame_time = 0;  // when the current frame was switched to, in ms
  long next_frame_time = 0;     // in ms
  bool playing = false;
  Vector2f anchor;
  Vector2f scale;
  
  this(uint[] _frames, float frame_rate, Vector2f _anchor, Vector2f _scale){
    super();
    frames = _frames;
    // todo: if frame_rate is 0 then set to static Animation
    frame_delay = cast(int)(1000.0f/frame_rate);
    anchor = _anchor;
    scale = _scale;
  }
  
  void destroy(){
    object.destroy(this);
  }
  
  void play(){
    playing = true;
  }
  
  void pause(){
    playing = false;
  }
  
  void reset(){
    current_frame_index = 0;
  }
  
  uint get_frame(int frame){
    return frames[frame];
  }
  
  uint current_frame(){
    return frames[current_frame_index];
  }
  
  void next_frame(long time){
    // if(frames.length == 1) ...
    current_frame_index = (current_frame_index + 1) % frames.length;
    current_frame_time = time;
    next_frame_time = current_frame_time + frame_delay;
  }
  
  Animation update(long time){
    // if(frames.length == 1) ...
    if(next_frame_time < time){
      next_frame(time);
    }
    return this;
  }
}

void gr_draw(Animation animation, Vector2f position, float depth, float angle){
  sgogl.gr_draw(animation.current_frame, position.x, position.y, depth, animation.anchor.x, animation.anchor.y, angle, animation.scale.x, animation.scale.y);
}