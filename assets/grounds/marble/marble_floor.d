module marble_floor;

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

class Marble_floor_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3, image_4;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/marble/marble_floor_1_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/marble/marble_floor_1_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/grounds/marble/marble_floor_1_3.png".toStringz, 0);
      image_4 = gr_load_image("assets/grounds/marble/marble_floor_1_4.png".toStringz, 0);
    }
  }
  
  this(){
    uint image = 0;
    switch(uniform!"[]"(0, 3)){
      default:
      case 0: image = image_1; break;
      case 1: image = image_2; break;
      case 2: image = image_3; break;
      case 3: image = image_4; break;
    }
    animation = new Animation([image], 1.0f, Vector2f(0,0), Vector2f(1,1));
  }
  
  override string name(){ return "Marble Floor"; }
  override string description(){ return "A smooth and clean floor made of marble. Looks like it was recently polished"; }
  override string standard_article(){ return "a"; }
  
}