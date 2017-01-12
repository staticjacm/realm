
module player;

import std.stdio;
import std.string;
import std.math;
import std.random;
import sgogl_interface;
import entity;
import structured_entity;
import sgogl;
import animation;
import world;
import area;
import game;
import vector;

float view_size = 15;

Entity player_entity;
int move_up_button    = GR_W;
int move_left_button  = GR_A;
int move_down_button  = GR_S;
int move_right_button = GR_D;

bool move_up_pressed = false;
bool move_left_pressed = false;
bool move_down_pressed = false;
bool move_right_pressed = false;

bool mouse_left_down = false;

Vector2f view_target = Vector2f(0, 0);
Vector2f view_target_offset = Vector2f(0, 0);
Vector2f view_position = Vector2f(0, 0);
Vector2f view_velocity = Vector2f(0, 0);
float view_pull_strength = 100.0;
float view_friction = 10;
float view_shake_amount = 0;
int view_shake_frames = 0;

void set_player_entity(Entity player_entity_){} // To implement

void shake_screen(float amount){
  view_shake_amount = amount.sqrt;
  view_shake_frames = cast(int)(2*amount);
}

void player_update(){
  
  if(player_entity !is null && player_entity.valid){
    
    gr_read_mouse;
    player_entity.direction = Vector2f(gr_mouse_x.gr_screen_to_world_x - player_entity.position.x, 
                                       gr_mouse_y.gr_screen_to_world_y - player_entity.position.y ).normalize;
    
    float boost = 100.0;
    Vector2f acceleration = Vector2f(0.0f, 0.0f);
    if(move_up_pressed) acceleration += Vector2f(0.0, 1.0f);
    else if(move_down_pressed) acceleration += Vector2f(0.0, -1.0f);
    if(move_left_pressed) acceleration += Vector2f(-1.0, 0.0f);
    else if(move_right_pressed) acceleration += Vector2f(1.0, 0.0f);
    player_entity.accelerate(acceleration*boost);
    
    // if(mouse_left_down)
      // player_entity.regular_attack_start;
    // else
      // player_entity.regular_attack_end;
    
    view_target = player_entity.position;
  }
  view_velocity += ((view_target + view_target_offset - view_position)*view_pull_strength - view_velocity*view_friction)*frame_delta;
  if(frame_delta > 0)
    view_position += view_velocity*frame_delta;
  if(view_shake_frames > 0){
    view_velocity += rvector(view_shake_amount);
    view_shake_frames--;
  }
  
  gr_view_centered(view_position, view_size);
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

void player_render_gui(){
  if(player_entity !is null && player_entity.valid){
    gr_screen_draw(gui_mockup_img, 0.0f, 0.0f, 0.1f, 0.0f, 0.0f, 0.0f, 1.0f, 0.666666f);
    
    gr_screen_draw_text(test_font, format("Player health: %f", player_entity.health).toStringz, 0.0f, 0.2f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.4f);
    gr_screen_draw_text(test_font, format("(%.2f, %.2f)", player_entity.position.x, player_entity.position.y).toStringz, 0.0f, 0.4f, 0.0f, 0.0f, 0.0f, 0.0f, 0.5f, 0.5f);
    
    // Health
    gr_screen_draw_text(test_font, "HP", 0.02f, 0.03f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.1f);
    gr_screen_draw_text(test_font, format("%3.0f", player_entity.health).toStringz, 0.02f, 0.01f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.1f);
    
    //NRG
    gr_screen_draw_text(test_font, "NRG", 0.095f, 0.03f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.1f);
    gr_screen_draw_text(test_font, format("%3.0f", player_entity.energy).toStringz, 0.095f, 0.01f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.1f);
    
    //Weapon
    if(player_entity.entity_subtype_id == Entity.subtype_structured_entity){
      Structured_entity player_entity_structured = cast(Structured_entity)player_entity;
      if(player_entity_structured.weapon !is null && player_entity_structured.weapon.valid)
        gr_screen_draw(
          player_entity_structured.weapon.animation.update(game_time), 
          0.17f, 0.0f, 0.0f, 
          0.0f, 0.0f, 
          0.0f, 
          0.045f
        );
    }
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
    case GR_Q: 
      if(gr_key_pressed){
        player_entity.interacts_with_walls = !player_entity.interacts_with_walls;
        writeln("collides with walls toggled to: ", player_entity.interacts_with_walls);
      }
      break;
    default: break;
  }
}

void player_mouse_click_function(){
  if(gr_mouse_button == GR_MOUSE_LEFT){
    if(gr_mouse_state == GR_PRESSED){
      if(player_entity !is null && player_entity.valid)
        player_entity.regular_attack_start;
    }
    else if(gr_mouse_state == GR_RELEASED){
      if(player_entity !is null && player_entity.valid)
        player_entity.regular_attack_end;
    }
  }
  else if(gr_mouse_button == GR_MOUSE_RIGHT){
  }
  else if(gr_mouse_button == GR_MOUSE_MIDDLE){
  }
}

void player_play_audio(int audio, Vector2f position){
  int channel = gr_play_once(audio);
  float xdif = position.x - player_entity.position.x;
  // 255/2*(2/Pi ArcTan[x] + 1)
  gr_set_panning(channel, cast(int)(127*(2/PI*atan(-xdif) + 1)));
}