
module player;

import std.stdio;
import std.math;
import sgogl_interface;
import entity;
import sgogl;
import world;
import area;
import game;
import vector;

float view_size = 20;

Entity player_entity;
int move_up_button    = GR_W;
int move_left_button  = GR_A;
int move_down_button  = GR_S;
int move_right_button = GR_D;

bool move_up_pressed = false;
bool move_left_pressed = false;
bool move_down_pressed = false;
bool move_right_pressed = false;

void player_update(){
  float boost = 100.0;
  Vector2f acceleration = Vector2f(0.0f, 0.0f);
  if(move_up_pressed) acceleration += Vector2f(0.0, 1.0f);
  else if(move_down_pressed) acceleration += Vector2f(0.0, -1.0f);
  if(move_left_pressed) acceleration += Vector2f(-1.0, 0.0f);
  else if(move_right_pressed) acceleration += Vector2f(1.0, 0.0f);
  player_entity.accelerate(acceleration*boost);
  
  gr_view_centered(player_entity.position, view_size);
}

void player_render_near(){
  if(player_entity.world !is null){
    // get topleft corner of screen
    float view_left = gr_view_left.floor;
    float view_bottom = gr_view_bottom.floor;
    float view_top = gr_view_top.ceil;
    float view_right = gr_view_right.ceil;
    // progress downright to other corner of screen
    for(float x = view_left; x < view_right; x++){
      for(float y = view_bottom; y < view_top; y++){
        Area render_area = player_entity.world.get_area(Vector2f(x, y));
        if(render_area !is null){
          render_area.render;
        } 
      } 
    }
    // render everything inside
  }
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

void player_mouse_click_function(){
  gr_read_mouse;
  player_entity.direction = Vector2f(gr_mouse_x.gr_screen_to_world_x - player_entity.position.x, 
                                     gr_mouse_y.gr_screen_to_world_y - player_entity.position.y ).normalize;
  if(gr_mouse_left){
    if(player_entity !is null)
      player_entity.regular_attack;
  }
}

void player_mouse_button_function(){
  
}
