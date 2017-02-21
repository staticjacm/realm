module sand;

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

class Sand_1 : Ground {
  static bool type_initialized = false;
  static uint[] images; static int image_number = 18;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      images.length = image_number;
      for(int i = 0; i < image_number; i++){
        images[i] = gr_load_image(format("assets/grounds/sand/sand_1_%d.png", i + 1).toStringz, 0);
      }
    }
  }
  
  bool onq = false;
  
  this(){
    int img_index = uniform!"[]"(0, image_number - 1);
    // writeln("grass: ", img_index);
    animation = new Animation([images[img_index]], 1.0f, Vector2f(0.333333f,0.333333f), Vector2f(3,3));
  }
  
  override string name(){ return "Sand"; }
  override string description(){ return "It's coarse, rough, irritating and it gets everywhere"; }
  override string standard_article(){ return "some"; }
}