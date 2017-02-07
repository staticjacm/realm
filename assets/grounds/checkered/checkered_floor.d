module checkered_floor;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import ground;
import agent;
import validatable;

class Checkered_white_black_floor_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3, image_4;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/checkered/checkered_white_black_floor_1.png".toStringz, 0);
    }
  }
  
  this(){
    animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));
  }
  
  override string name(){ return "Checkered Floor"; }
  override string description(){ return "A clean and minimalistic checkered tile floor. Whichever interior decorator put this in should be fired"; }
  override string standard_article(){ return "a"; }
  
}