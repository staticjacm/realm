module brazier;

import std.string;
import vector;
import game;
import animation;
import entity;
import agent;
import sgogl;

class Brass_brazier_1 : Agent {
  static bool type_initialized = false;
  static uint unlit_image, lit_image_1, lit_image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      unlit_image = gr_load_image("assets/agents/brazier/brass_brazier_1_unlit.png".toStringz, 0);
      lit_image_1 = gr_load_image("assets/agents/brazier/brass_brazier_1_lit_1.png".toStringz, 0);
      lit_image_2 = gr_load_image("assets/agents/brazier/brass_brazier_1_lit_2.png".toStringz, 0);
    }
  }
  
  bool is_lit = false;
  Animation lit_animation, unlit_animation;
  
  this(){
    unlit_animation = new Animation([unlit_image], 1.0f, Vector2f(0.5f, 0.0f), Vector2f(1.0f, 1.0f));
    lit_animation = new Animation([lit_image_1, lit_image_2], 2.0f, Vector2f(0.5f, 0.0f), Vector2f(1.0f, 1.0f));
    animation = unlit_animation;
  }
  
  override string name(){ return "Brass Brazier"; }
  override string description(){
    if(is_lit)
      return "A shiny brass brazier. It holds burning oil";
    else
      return "A shiny brass brazier. It holds oil waiting to be lit";
  }
  override string standard_article(){ return "a"; }
  
  void lit(bool value){
    if(value)
      animation = lit_animation;
    else
      animation = unlit_animation;
  }
}