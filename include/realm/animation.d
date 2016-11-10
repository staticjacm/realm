
module animation;

import vector;
import sgogl;

alias Vector2f = Vector2!float;

/++
Iterates through a list of uints when playing
uints correspond to sgogl images
also contains anchor (anx, any) information and scale (sx, sy) information
++/
struct Animation {
  uint[] frames;
  float frame_rate = 1;
  int current_frame_index = 0;
  int current_frame_time = 0;  // in ms
  int next_frame_time = 0;     // in ms
  bool playing = false;
  Vector2f anchor;
  Vector2f scale;
  
  this(uint[] _frames, float _frame_rate, Vector2f _anchor, Vector2f _scale){
    frames = _frames;
    frame_rate = _frame_rate;
    anchor = _anchor;
    scale = _scale;
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
    current_frame_index = (frame + 1) % frames.length;
    current_frame_time = time;
    next_frame_time = current_frame_time + cast(int)(1000.0f/frame_rate);
  }
  
  void update(long time){
    if(time < current_frame_time)
      return next_frame(time);
    else
      return get_frame(current_frame_index);
  }
}

void gr_draw(Animation animation, Vector2f position, float depth, float angle){
  gr_draw(animation.current_frame, position.x, position.y, depth, animation.anchor.x, animation.anchor.y, angle, animation.scale.x, animation.scale.y);
}