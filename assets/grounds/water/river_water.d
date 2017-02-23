module river_water;

import std.random;
import std.stdio;
import std.string;
import game;
import sgogl;
import animation;
import vector;
import ground;
import entity;
import agent;
import validatable;

class River_water_1 : Ground {
  static bool type_initialized = false;
  static uint image_1, image_2, image_3, image_4, ripple_image_1, ripple_image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/grounds/water/river_water_1_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/grounds/water/river_water_1_2.png".toStringz, 0);
      image_3 = gr_load_image("assets/grounds/water/river_water_1_3.png".toStringz, 0);
      image_4 = gr_load_image("assets/grounds/water/river_water_1_4.png".toStringz, 0);
      
      ripple_image_1 = gr_load_image("assets/grounds/water/ripple_image_1.png".toStringz, 0);
      ripple_image_2 = gr_load_image("assets/grounds/water/ripple_image_2.png".toStringz, 0);
    }
  }
  
  Animation ripple_animation;
  
  this(){
    switch(uniform!"[]"(1, 4)){
      default:
      case 1: animation = new Animation([image_1, image_2, image_3, image_4], uniform(0.8f, 1.2f), Vector2f(0,0), Vector2f(1,1));  break;
      case 2: animation = new Animation([image_3, image_1, image_4, image_2], uniform(0.8f, 1.2f), Vector2f(0,0), Vector2f(1,1));  break;
      case 3: animation = new Animation([image_2, image_4, image_3, image_1], uniform(0.8f, 1.2f), Vector2f(0,0), Vector2f(1,1));  break;
      case 4: animation = new Animation([image_4, image_3, image_2, image_1], uniform(0.8f, 1.2f), Vector2f(0,0), Vector2f(1,1));  break;
    }
    ripple_animation = new Animation([ripple_image_1, ripple_image_2], 3.0f, Vector2f(0.5, 0.5), Vector2f(4.0f, 4.0f));
  }
  
  override string name(){ return "River water"; }
  override string description(){ return "The current isn't strong enough to move me"; }
  override string standard_article(){ return "some"; }
  
  override float friction(){ return 45; }
  override float max_speed_mod(){ return 0.4; }
  
  override float height(){ return -0.1; }
  
  override void render_under(Entity entity){
    if(entity.height == 0){
      gr_color(0.5, 0.5, 1.0f, 1.0f);
      gr_draw(ripple_animation.update(game_time), entity.position, render_depth - 0.01, 0.0f, 0.2f);
      gr_color_alpha(1.0f);
    }
  }
  
}