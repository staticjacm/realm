module token_generator;

import std.stdio;
import std.string;
import vector;
import make;
import game;
import animation;
import entity;
import agent;
import sgogl;
import drop;
import drop_tiers;
import token;

class Token_generator_1 : Agent {
  static bool type_initialized = false;
  static uint image;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image = gr_load_image("assets/agents/token_generator/token_generator_1_1.png".toStringz, 0);
    }
  }
  
  string token_type = "Commoner_1_token";
  
  this(){
    animation = new Animation([image], 1.0f, Vector2f(0.5f, 0.0f), Vector2f(2.0f, 2.0f));
    collider_size_x = 0.5;
    collider_size_y = 0.5;
  }
  
  void set_token_type(string type){
    token_type = type;
  }
  
  override void activate(Agent agent){
    if(world !is null){
      Token token = make_token(token_type);
      if(token !is null){
        Drop drop = drop_decide_tier(token.tier);
        if(drop !is null){
          drop.add_item(token);
          drop.position = position;
          drop.set_velocity = Vector2f(0.0f, -7.0f);
          world.place_agent(drop);
        }
      }
    }
  }
  
  override string name(){ return "Token Generator"; }
  override string description(){ return "Generates a character token. I wonder what kind it will give?"; }
  override string standard_article(){ return "a"; }
}