module giant_sea_turtle;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.math;
import std.stdio;
import std.string;
import std.random;
import make;
import game;
import animation;
import vector;
import entity;
import shot;
import agent;
import sgogl;

class Giant_sea_turtle_1 : Entity {
  static uint image_standing, image_walking_1, image_walking_2, image_hurt;
  static  Vector2f image_dimensions;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      make.initialize_type!"Big_bite_1";
      image_dimensions = Vector2f(4, 3);
      image_standing  = gr_load_image("assets/entities/giant_sea_turtle/giant_sea_turtle_1_standing.png".toStringz, 0);
      image_walking_1 = gr_load_image("assets/entities/giant_sea_turtle/giant_sea_turtle_1_walking_1.png".toStringz, 0);
      image_walking_2 = gr_load_image("assets/entities/giant_sea_turtle/giant_sea_turtle_1_walking_2.png".toStringz, 0);
      image_hurt      = gr_load_image("assets/entities/giant_sea_turtle/giant_sea_turtle_1_hurt.png".toStringz, 0);
    }
  }
  
  // Animation animation_standing, animation_walking, animation_hurt;
  
  long bite_attack_end_time = 0;
  long bite_attack_delay = 1000;
  
  this(){
    super();
    standing_animation = new Animation([image_standing], 1, Vector2f(0.5, 0), image_dimensions);
    walking_animation  = new Animation([image_walking_1, image_walking_2], 10, Vector2f(0.5, 0), image_dimensions);
    hurt_animation     = new Animation([image_hurt], 1, Vector2f(0.5, 0), image_dimensions);
    animation = walking_animation;
    propel_rate = 60.0f;
    max_speed = 2;
    l_defence = 5.0f;
  }
  ~this(){ writeln("destroyed"); }
  
  override void update(){
    if(regular_attack_started){
      if(bite_attack_end_time < game_time){
        bite_attack_end_time = game_time + bite_attack_delay;
        for(float q = -PI/4.0f; q < PI/4.0f; q += PI/4.0f){
          Shot bite = make_shot!"Big_bite_1";
          bite.set_velocity = direction.rotate_by(q)*10.0f;
          created_shot(bite);
        }
      }
    }
    super.update;
  }
  
  override string name(){ return "Giant sea turtle"; }
  override string description(){ return "A gigantic, ancient sea turtle corrupted by the destroyer!"; }
  override string standard_article(){ return "a"; }
  
  // override float targeting_range(){ return 5.0f; }
}