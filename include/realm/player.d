
module player;

import std.stdio;
import std.string;
import std.math;
import std.random;
import sgogl_interface;
import agent;
import drop;
import entity;
import structured_entity;
import sgogl;
import animation;
import item;
import world;
import kernel;
import weapon;
import armor;
import accessory;
import effect;
import area;
import game;
import vector;

float view_size = 15;

float sound_max_distance = 50.0f;

Drop nearby_drop;
Effect player_effect;
Entity player_entity;

bool gui_show_primary   = true;
bool gui_show_equipment = true;
bool gui_show_items     = true;
bool gui_show_stats     = true;

int activate_button       = GR_E;
int warp_to_kernel_button = GR_R;

int move_up_button    = GR_W;
int move_left_button  = GR_A;
int move_down_button  = GR_S;
int move_right_button = GR_D;

int gui_show_primary_button   = GR_H;
int gui_show_equipment_button = GR_J;
int gui_show_items_button     = GR_K;
int gui_show_stats_button     = GR_L;

bool shift_pressed = false;
bool ctrl_pressed  = false;

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
bool use_spring_shake_model = false;
bool use_screen_shake = true;

class Player_effect : Effect {
  alias collide = Effect.collide;
  override void finalize(){
    nearby_drop = null;
  }
  override void collide(Drop other){
    nearby_drop = other;
  }
}

void shake_screen(float amount){
  view_shake_amount = amount.sqrt;
  view_shake_frames = cast(int)(2*amount);
}

void shake_screen(Vector2f position, float magnitude){
  if(player_entity !is null){
    view_shake_amount = (position - player_entity.position).norm;
    view_shake_amount = 5.0f/(0.1f + view_shake_amount/50.0f);
    view_shake_frames = cast(int)(4*view_shake_amount.sqrt);
    // writefln(" amount: %f, frames %d", view_shake_amount, view_shake_frames);
  }
}

void player_register(Entity entity){
  destroy(player_effect);
  player_entity = entity;
  player_entity.add_effect(new Player_effect);
}

void player_update(){
  
  if(player_entity !is null && player_entity.valid){
    
    gr_read_mouse;
    player_entity.direction = Vector2f(gr_mouse_x.gr_screen_to_world_x - player_entity.position.x, 
                                       gr_mouse_y.gr_screen_to_world_y - player_entity.position.y ).normalize;
    
    Vector2f direction = Vector2f(0.0f, 0.0f);
    if(move_up_pressed) direction += Vector2f(0.0, 1.0f);
    else if(move_down_pressed) direction += Vector2f(0.0, -1.0f);
    if(move_left_pressed) direction += Vector2f(-1.0, 0.0f);
    else if(move_right_pressed) direction += Vector2f(1.0, 0.0f);
    if(direction.x != 0 || direction.y != 0)
      player_entity.propel(direction);
    // possibly w -> toward cursor; s -> away cursor; a,d-> perpendicular to cursor
    
    view_target = player_entity.position;
  }
  if(use_screen_shake){
    if(use_spring_shake_model){
      view_velocity += ((view_target + view_target_offset - view_position)*view_pull_strength - view_velocity*view_friction)*frame_delta;
      if(frame_delta > 0)
        view_position += view_velocity*frame_delta;
      if(view_shake_frames > 0){
        view_velocity += rvector(view_shake_amount);
        view_shake_frames--;
      }
    }
    else {
      if(view_shake_frames > 0){
        view_position = view_target + rvector(view_shake_amount*0.03f);
        view_shake_frames --;
      }
      else {
        view_position = view_target;
      }
    }
  }
  else {
    view_position = view_target;
  }
  
  if(nearby_drop !is null && nearby_drop.valid){
    if(!player_entity.fast_test_for_collision(nearby_drop)){
      nearby_drop = null;
    }
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
        if(render_area !is null && render_area.valid){
          render_area.render;
        }
      }
    }
  }
}

void player_render_gui(){
  if(player_entity !is null && player_entity.valid){
    gr_screen_draw(gui_mockup_img, 0.0f, 0.0f, 0.1f, 0.0f, 0.0f, 0.0f, 1.0f, 0.666666f);
    
    gr_screen_draw_text(test_font, format("Player health: %f", player_entity.health).toStringz, 0.0f, 0.2f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.4f);
    gr_screen_draw_text(test_font, format("(%.2f, %.2f)", player_entity.position.x, player_entity.position.y).toStringz, 0.0f, 0.4f, 0.0f, 0.0f, 0.0f, 0.0f, 0.5f, 0.5f);
    
    if(gui_show_primary){
      // Health
      gr_screen_draw_text(test_font, "HP", 0.02f, 0.03f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.1f);
      gr_screen_draw_text(test_font, format("%3.0f", player_entity.health).toStringz, 0.02f, 0.01f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.1f);
      // NRG
      gr_screen_draw_text(test_font, "NRG", 0.095f, 0.03f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.1f);
      gr_screen_draw_text(test_font, format("%3.0f", player_entity.energy).toStringz, 0.095f, 0.01f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.1f);
    }
    
    if(gui_show_stats){
      // Stats
      gr_screen_draw_text(test_font, format("%2.0f hpmax", player_entity.health_max).toStringz, 0.85, 0.05f, 0.0f, 0.0f, 0.0f, 0.0f, 0.15f, 0.15f);
      gr_screen_draw_text(test_font, format("%2.0f ldef", player_entity.l_defence).toStringz, 0.85, 0.07f, 0.0f, 0.0f, 0.0f, 0.0f, 0.15f, 0.15f);
      gr_screen_draw_text(test_font, format("%2.0f mdef", player_entity.m_defence).toStringz, 0.85, 0.09f, 0.0f, 0.0f, 0.0f, 0.0f, 0.15f, 0.15f);
    }
    
    // Structured entity
    if(player_entity.entity_subtype_id == Entity.subtype_structured_entity){
      Structured_entity player_entity_structured = cast(Structured_entity)player_entity;
      if(gui_show_equipment){
        if(player_entity_structured.weapon !is null && player_entity_structured.weapon.valid)
          gr_screen_draw(
            player_entity_structured.weapon.animation.update(game_time), 
            0.17f, 0.0f, 0.0f, 
            0.0f, 0.0f, 
            0.0f, 
            0.045f
          );
        if(player_entity_structured.armor !is null && player_entity_structured.armor.valid)
          gr_screen_draw(
            player_entity_structured.armor.animation.update(game_time),
            0.24f, 0.0f, 0.0f, 
            0.0f, 0.0f, 
            0.0f, 
            0.045f
          );
        if(player_entity_structured.accessory !is null && player_entity_structured.accessory.valid)
          gr_screen_draw(
            player_entity_structured.accessory.animation.update(game_time),
            0.29f, 0.0f, 0.0f, 
            0.0f, 0.0f, 
            0.0f, 
            0.045f
          );
      }
      if(gui_show_items){
        for(int i = 0; i < player_entity_structured.items.length; i++){
          if(player_entity_structured.items[i] !is null && player_entity_structured.items[i].valid)
            gr_screen_draw(
              player_entity_structured.items[i].animation.update(game_time),
              0.34f + cast(float)i * 0.065, 0.0f, 0.0f, 
              0.0f, 0.0f, 
              0.0f, 
              0.045f
            );
        }
        if(nearby_drop !is null && nearby_drop.valid){
          for(int i = 0; i < nearby_drop.items.length; i++){
            if(nearby_drop.items[i] !is null && nearby_drop.items[i].valid){
              gr_screen_draw(
                nearby_drop.items[i].animation.update(game_time),
                0.34f + cast(float)i * 0.065, 0.05f, 0.0f, 
                0.0f, 0.0f, 
                0.0f, 
                0.045f
              );
            }
          }
        }
      }
    }
  }
}

// Swaps that item slot with the corresponding slot in nearby_drop
void player_swap_item(int i){
  if(player_entity !is null && player_entity.valid && nearby_drop !is null && nearby_drop.valid && nearby_drop.items[i] !is null){
    Item temp = nearby_drop.items[i];
    nearby_drop.items[i] = player_entity.items[i];
    player_entity.items[i] = temp;
  }
}

void player_equip_item(int i){
  if(player_entity !is null && player_entity.valid 
     && player_entity.items[i] !is null && player_entity.items[i].valid 
     && player_entity.entity_subtype_id == Entity.subtype_structured_entity){
    Structured_entity player_entity_structured = cast(Structured_entity)player_entity;
    switch(player_entity_structured.items[i].item_subtype_id){
      default: break;
      case Item.subtype_weapon:
        Item temp = player_entity_structured.items[i];
        player_entity_structured.items[i] = player_entity_structured.weapon;
        player_entity_structured.equip_weapon(cast(Weapon)temp);
        break;
      case Item.subtype_armor:
        Item temp = player_entity_structured.items[i];
        player_entity_structured.items[i] = player_entity_structured.armor;
        player_entity_structured.equip_armor(cast(Armor)temp);
        break;
      case Item.subtype_accessory:
        Item temp = player_entity_structured.items[i];
        player_entity_structured.items[i] = player_entity_structured.accessory;
        player_entity_structured.equip_accessory(cast(Accessory)temp);
        break;
    }
  }
}

void player_use_item(int i){
  if(player_entity !is null && player_entity.valid && player_entity.items[i] !is null && player_entity.items[i].valid){
    player_entity.items[i].use(player_entity);
  }
}

void player_interact_item(int i){
  if(shift_pressed)
    player_swap_item(i);
  else if(ctrl_pressed)
    player_equip_item(i);
  else 
    player_use_item(i);
}

void player_activate_nearby(){
  if(player_entity !is null && player_entity.valid && player_entity.world !is null && player_entity.world.valid){
    Agent_list nearby_agents = player_entity.world.get_agents_nearby(player_entity.position, 1.0f);
    foreach(Agent nearby_agent; nearby_agents)
      nearby_agent.activate(cast(Agent)player_entity);
  }
}

void player_zero_view(){
  if(player_entity !is null)
    view_target = player_entity.position;
  view_position = view_target;
  view_velocity = Vector2f(0.0f, 0.0f);
}

void player_key_function(){
  switch(gr_key){
    case GR_LSHIFT:
      shift_pressed = (gr_key_pressed > 0);
      break;
    case GR_LCTRL:
      ctrl_pressed = (gr_key_pressed > 0);
      break;
    
    case GR_V:
      if(gr_key_pressed){
        game.framerate_cap ++;
        writefln("framrate cap %f", game.framerate_cap);
      }
      break;
    case GR_C:
      if(gr_key_pressed){
        game.framerate_cap --;
        if(game.framerate_cap < 0)
          game.framerate_cap = 0;
        writefln("framrate cap %f", game.framerate_cap);
      }
      break;
    
    // Movement
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
      
    // E-activation
    case activate_button:
      if(gr_key_pressed)
        player_activate_nearby;
      break;
      
    // Warp to kernel
    case warp_to_kernel_button:
      if(gr_key_pressed && kernel_world !is null && kernel_world.valid && player_entity !is null && player_entity.valid){
        player_entity.world = kernel_world;
        player_entity.position = Kernel.center_spawn;
        kernel_world.place_agent(player_entity);
        player_zero_view;
      }
      break;
      
    // Gui toggles
    case gui_show_primary_button:
      if(gr_key_pressed)
        gui_show_primary = !gui_show_primary;
      break;
    case gui_show_equipment_button:
      if(gr_key_pressed)
        gui_show_equipment = !gui_show_equipment;
      break;
    case gui_show_items_button:
      if(gr_key_pressed)
        gui_show_items = !gui_show_items;
      break;
    case gui_show_stats_button:
      if(gr_key_pressed)
        gui_show_stats = !gui_show_stats;
      break;
      
    // Item use
    case GR_1: if(gr_key_pressed) player_interact_item(0); break;
    case GR_2: if(gr_key_pressed) player_interact_item(1); break;
    case GR_3: if(gr_key_pressed) player_interact_item(2); break;
    case GR_4: if(gr_key_pressed) player_interact_item(3); break;
    case GR_5: if(gr_key_pressed) player_interact_item(4); break;
    case GR_6: if(gr_key_pressed) player_interact_item(5); break;
    case GR_7: if(gr_key_pressed) player_interact_item(6); break;
    case GR_8: if(gr_key_pressed) player_interact_item(7); break;
      
    
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

int player_play_audio(int audio, World world, Vector2f position, int loops = 0){
  if(player_entity !is null && player_entity.valid && world is player_entity.world){
    int channel = gr_play(audio, loops);
    Vector2f pdif = position - player_entity.position;
    // float xdif = position.x - player_entity.position.x;
    // 255/2*(2/Pi ArcTan[x] + 1)
    // gr_set_panning(channel, cast(int)(127*(2/PI*atan(-pdif.x) + 1)));
    // gr_set_attenuation(channel, cast(int)(255*pdif.norm/sound_max_distance));
    set_audio_panning_and_attenuation(channel, pdif, sound_max_distance);
    return channel;
  }
  else
    return -1;
}

void player_adjust_audio(int channel, World world, Vector2f position){
  if(channel >= 0 && player_entity !is null && player_entity.valid){
    if(world is player_entity.world){
      Vector2f pdif = position - player_entity.position;
      set_audio_panning_and_attenuation(channel, pdif, sound_max_distance);
    }
    else
      gr_stop(channel);
  }
}