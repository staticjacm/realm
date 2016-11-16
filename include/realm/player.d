
module player;

import std.stdio;
import sgogl_interface;
import entity;
import sgogl;

Entity player_entity;
int move_up_button    = GR_W;
int move_left_button  = GR_A;
int move_down_button  = GR_S;
int move_right_button = GR_D;

bool move_up_pressed = false;
bool move_left_pressed = false;
bool move_down_pressed = false;
bool move_right_pressed = false;

void player_update(long time, float dt){
  float boost = 100.0;
  Vector2f acceleration = Vector2f(0.0f, 0.0f);
  if(move_up_pressed) acceleration += Vector2f(0.0, 1.0f);
  else if(move_down_pressed) acceleration += Vector2f(0.0, -1.0f);
  if(move_left_pressed) acceleration += Vector2f(-1.0, 0.0f);
  else if(move_right_pressed) acceleration += Vector2f(1.0, 0.0f);
  player_entity.accelerate(acceleration*boost, dt);
  
  gr_view_centered(player_entity.position, 10.0);
}

void player_key_function(){
  switch(gr_key){
    case move_up_button:
      if(gr_key_pressed)
        move_up_pressed = true;
      else
        move_up_pressed = false;
      break;
    case move_down_button:  
      if(gr_key_pressed)
        move_down_pressed = true;
      else
        move_down_pressed = false;
      break;
    case move_left_button:  
      if(gr_key_pressed)
        move_left_pressed = true;
      else
        move_left_pressed = false;
      break;
    case move_right_button: 
      if(gr_key_pressed)
        move_right_pressed = true;
      else
        move_right_pressed = false;
      break;
    default: break;
  }
}

void player_mouse_button_function(){
  
}
