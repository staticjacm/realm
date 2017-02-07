module blank_impassable_wall;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import wall;
import agent;

class Blank_impassable_wall_1 : Wall {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
    }
  }
  
  this(){
  
  }
  
  override string name(){ return "Something Blank"; }
  override string description(){ return "An ill defined section of space and time"; }
  override string standard_article(){ return "a"; }
  
}