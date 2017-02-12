module character_generator_portal;

import std.stdio;
import std.string;
import dbg;
import make;
import agent;
import animation;
import vector;
import sgogl;
import portal;
import world;
import token;
import entity;
import game;
import kernel;
import player;

class Character_generator_portal_1 : Portal {
  static bool type_initialized = false;
  static uint image_1, image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      image_1 = gr_load_image("assets/portals/character_generator_portal/character_generator_portal_1_1.png", 0);
      image_2 = gr_load_image("assets/portals/character_generator_portal/character_generator_portal_1_2.png", 0);
    }
  }
  
  this(){
    animation = new Animation([image_1, image_2], 2.0f, Vector2f(0.5f, 0.1f), Vector2f(1.0f, 2.0f));
    collider_size_x = 0.5;
  }
  
  override string name(){ return "Character Portal"; }
  override string description(){ return "You need a token to get through?"; }
  override string standard_article(){ return "a"; }
  
  /*
    This only allows players through
  */
  override void activate(Agent agent){
    if(agent is player_entity && player_token !is null){
      if(game.kernel_world is null){
        game.kernel_world = new Kernel;
        exit_world = game.kernel_world;
        exit_position = Kernel.center_spawn;
      }
      if(exit_world is null){
        exit_world = game.kernel_world;
        exit_position = Kernel.center_spawn;
      }
      Entity entity = (cast(Token)player_token).make_entity;
      player_register(entity);
      Portal.activate(entity);
    }
  }
  
}