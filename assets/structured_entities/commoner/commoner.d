module commoner;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.stdio;
import std.string;
import std.math;
import std.random;
import make;
import game;
import animation;
import vector;
import structured_entity;
import entity;
import token;
import shot;
import agent;
import sgogl;

alias Vector2f = Vector2!float;

class Commoner_1 : Structured_entity {
  static uint image_standing, image_walking_1, image_walking_2, image_hurt;
  static  Vector2f image_dimensions;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image_dimensions = Vector2f(1, 1);
      image_standing  = gr_load_image("assets/structured_entities/commoner/standing.png".toStringz, 0);
      image_walking_1 = gr_load_image("assets/structured_entities/commoner/walking_1.png".toStringz, 0);
      image_walking_2 = gr_load_image("assets/structured_entities/commoner/walking_2.png".toStringz, 0);
      image_hurt      = gr_load_image("assets/structured_entities/commoner/hurt.png".toStringz, 0);
    }
  }
  
  this(){
    standing_animation = new Animation([image_standing], 1, Vector2f(0.5, 0), image_dimensions);
    walking_animation  = new Animation([image_walking_1, image_walking_2], 10, Vector2f(0.5, 0), image_dimensions);
    hurt_animation     = new Animation([image_hurt], 1, Vector2f(0.5, 0), image_dimensions);
    collider_size_x = 0.33;
    collider_size_y = 0.33;
    propel_rate = 60.0f;
    max_speed = 5.0f;
    super();
  }
  
  override string name(){ return "Filthy Commoner"; }
  override string description(){ return "A pleb"; }
  override string standard_article(){ return "a"; }
  
  override int entity_subtype_id(){ return 1; }
  
}

class Commoner_1_token : Token {
  static uint image;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image = gr_load_image("assets/structured_entities/commoner/token_1.png".toStringz, 0);
    }
  }
  
  this(){
    animation = new Animation([image], 1.0f, Vector2f(0.5f, 0.5f), Vector2f(1.0f, 1.0f));
  }
  
  override string name(){ return "Commoner Token"; }
  override string description(){ return "A toiling pleb is inside"; }
  override string standard_article(){ return "a"; }
  
  override Entity make_entity(){
    return make.make_entity!"Commoner_1";
  }
  
}