
module player;

import std.stdio;
import entity;
import sgogl;

Entity player_entity;
int move_up_button    = GR_W;
int move_left_button  = GR_A;
int move_down_button  = GR_S;
int move_right_button = GR_D;

void player_update(long time, float dt){
  
}

void player_key_function(long time, float dt){
  switch(gr_key){
    case move_up_button:    
      player_entity.accelerate(Vector2f(0, 1), dt);
      break;
    case move_down_button:  
      player_entity.accelerate(Vector2f(0, -1), dt);
      break;
    case move_left_button:  
      player_entity.accelerate(Vector2f(-1, 0), dt);
      break;
    case move_right_button: 
      player_entity.accelerate(Vector2f(1, 0), dt);
      break;
    default: break;
  }
}

void player_mouse_button_function(){
  
}
