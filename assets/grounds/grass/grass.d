module grass;

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

class Grass_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/grass/grass_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/grass/grass_2.png".toStringz, 0);
    }
  }
  
  bool onq = false;
  
  this(){
    switch(uniform!"[]"(0, 1)){
      default:
      case 0: animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      case 1: animation = new Animation([image_2], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
    }
  }
  
  override string name(){ return "Grass"; }
  override string description(){ return "It looks soft but if you lay in it you will get itchy"; }
  override string standard_article(){ return "some"; }
  
}

class Matted_grass_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/grass/matted_grass_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/grass/matted_grass_2.png".toStringz, 0);
    }
  }
  
  bool onq = false;
  
  this(){
    switch(uniform!"[]"(0, 1)){
      default:
      case 0: animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      case 1: animation = new Animation([image_2], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
    }
  }
  
  override string name(){ return "Matted Grass"; }
  override string description(){ return "A product of unergonomic walkway planning"; }
  override string standard_article(){ return "some"; }
  
}

class Grass_with_flowers_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3, image_4;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/grass/grass_with_flowers_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/grass/grass_with_flowers_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/grounds/grass/grass_with_flowers_3.png".toStringz, 0);
      image_4 = gr_load_image("assets/grounds/grass/grass_with_flowers_4.png".toStringz, 0);
    }
  }
  
  bool onq = false;
  
  this(){
    switch(uniform!"[]"(0, 3)){
      default:
      case 0: animation = new Animation([image_1], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      case 1: animation = new Animation([image_2], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      case 2: animation = new Animation([image_3], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
      case 3: animation = new Animation([image_4], 1.0f, Vector2f(0,0), Vector2f(1,1));  break;
    }
  }
  
  override string name(){ return "Grass With Pretty Flowers"; }
  override string description(){ return "They smell great!"; }
  override string standard_article(){ return "some"; }
  
}