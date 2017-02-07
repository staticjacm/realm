module token_generator;

import std.string;
import vector;
import game;
import animation;
import entity;
import agent;
import sgogl;

class Token_generator_1 : Agent {
  static bool type_initialized = false;
  static uint image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image = gr_load_image("assets/agents/token_generator/token_generator_1_1.png".toStringz, 0);
    }
  }
  
  Animation an;
  
  this(){
    an = new Animation([image], 1.0f, Vector2f(0.5f, 0.0f), Vector2f(2.0f, 2.0f));
    animation = an;
    collider_size_x = 0.5;
    collider_size_y = 0.5;
  }
  
  override string name(){ return "Token Generator"; }
  override string description(){ return "Generates a character token. I wonder what kind it will give?"; }
  override string standard_article(){ return "a"; }
}