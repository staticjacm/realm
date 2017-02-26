module big_bite;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.stdio;
import std.string;
import std.random;
import animation;
import game;
import vector;
import shot;
import entity;
import sgogl;

alias Vector2f = Vector2!float;

class Big_bite_1 : Shot {
  static uint image_1, image_2;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image_1 = gr_load_image("assets/shots/bite/big_bite_1_1.png".toStringz, 0);
      image_2 = gr_load_image("assets/shots/bite/big_bite_1_2.png".toStringz, 0);
    }
  }
  
  long end_time;
  long lifetime = 1000;
  
  this(){
    super();
    animation = new Animation([image_1, image_2], 30, Vector2f(0.5, 0.25), Vector2f(2, 2));
    end_time = game_time + lifetime + uniform(0, 500);
    height = 0.75;
    collider_size_x = 0.5;
    collider_size_y = 0.5;
    end_time = game_time + lifetime;
  }
  
  override string name(){ return "Gnashing mouth"; }
  override string description(){ return "Careful with those choppers!"; }
  override string standard_article(){ return "a"; }
  
  override bool uses_friction(){ return false; }

  void set_lifetime(long lifetime_){
    lifetime = lifetime_;
    end_time = game_time + lifetime_;
  }
  
  override bool destroy_on_agent_collision(){ return true; }
  override bool destroy_on_wall_collision(){ return true; }
  
  override float damage(){
    return 1.5f;
  }
  
  override void update(){
    super.update;
    // accelerate(rvector(1));
    if(velocity.x < 0)
      flip_horizontally = false;
    else
      flip_horizontally = true;
    // if(end_time < game_time){ kill; }
  }
}
