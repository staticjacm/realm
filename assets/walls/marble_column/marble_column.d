module marble_column;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class Marble_column_1 : Wall {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/walls/marble_column/marble_column_1_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/walls/marble_column/marble_column_1_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/walls/marble_column/marble_column_1_3.png".toStringz, 0);
    }
  }
  
  this(){
    uint image = 0;
    switch(uniform!"[]"(0, 2)){
      default:
      case 0:  image = image_1; break;
      case 1:  image = image_2; break;
      case 2:  image = image_3; break;
    }
    animation = new Animation([image], 1, Vector2f(0, 0), Vector2f(1, 2));
 }
  
  override string name(){ return "Marble Column"; }
  override string description(){ return "Created by a student of classic architecture surely"; }
  override string standard_article(){ return "a"; }
  
}