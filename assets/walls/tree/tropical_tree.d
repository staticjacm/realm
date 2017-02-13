module tropical_tree;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class Tropical_tree_1 : Wall {
  static bool type_initialized = false;
  static uint image_1;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/walls/tree/tropical_tree_1_1.png".toStringz, 0);
    }
  }
  
  int description_type = 1;
  
  this(){
    animation = new Animation([image_1], 1, Vector2f(0.333333f, 0), Vector2f(3, 3));
    description_type = uniform!"[]"(1, 4);
  }
  
  override string name(){ return "Tropical tree"; }
  override string description(){
    switch(description_type){
      default:
      case 1: return "Mmmm coconuts!";
      case 2: return "Mmmm bananas!";
      case 3: return "Mmmm papayas!";
      case 4: return "Mmmm plantains!";
    }
  }
  override string standard_article(){ return "a"; }
}