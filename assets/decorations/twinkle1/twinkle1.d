module twinkle1;

import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import decoration;
import vector;

class Twinkle1 : Decoration {
  
  static bool type_initialized = false;
  static uint image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image = gr_load_image("assets/decorations/twinkle1/twinkle1_1.png".toStringz, 0);
      writeln("image ", image);
    }
  }
  
  this(){
    super();
    animation = new Animation([image], 1, Vector2f(0.5, 0.5), Vector2f(0.25, 0.25));
  }
  
  override string name(){ return "Twinkling"; }
  override string description(){ return "Something reflective must be in the air"; }
  override string standard_article(){ return "a"; }
  
  override long lifetime(){ return 500; }
  
  override void render(){
    gr_color(1.0f, 0.0f, 0.0f, 1.0f);
    position += rvector(0.1);
    angle += 200.0f*frame_delta;
    super.render;
    gr_color_alpha(1.0f);
  }
}