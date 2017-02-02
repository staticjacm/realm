
module player;

import std.stdio;
import std.string;
import std.math;
import std.random;
import dbg;
import text;
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
import drop_tiers;

Drop nearby_drop;
Effect player_effect;
Entity player_entity;
  
// GUI
bool gui_show_primary     = true;
bool gui_show_equipment   = true;
bool gui_show_items       = true;
bool gui_show_stats       = true;
bool gui_show_description = false;

enum{
  gui_description_mode_world,
  gui_description_mode_item,
  gui_description_mode_weapon,
  gui_description_mode_armor,
  gui_description_mode_accessory,
  gui_description_mode_class,
  gui_description_mode_ground,
  gui_description_mode_wall
}
int gui_description_mode = gui_description_mode_world;

int gui_description_mode_world_button     = GR_F1;
int gui_description_mode_item_button      = GR_F2;
int gui_description_mode_weapon_button    = GR_F3;
int gui_description_mode_armor_button     = GR_F4;
int gui_description_mode_accessory_button = GR_F5;
int gui_description_mode_class_button     = GR_F6;
int gui_description_mode_ground_button    = GR_F7;
int gui_description_mode_wall_button      = GR_F8;


int drop_selection      = 0;
int inventory_selection = 0;
int selection_marker    = 0;
bool selection_marker_on_inventory = true;  // is the selection marker on the inventory or on the nearby drops item list?

uint selection_border_image;

float gui_panel_size   = 0.065; // size of a single info panel (hp, nrg, equipment, etc)
float gui_lower_gap    = 0.002;  // distance of panels from the bottom of the screen
float gui_panel_depth  = 0.2f;  // render depth (z)

float gui_stat_font_width  = 0.03;
float gui_stat_font_height = 0.03;
float gui_stat_line_size   = 0.02;

float gui_description_upper_gap   = 0.05;  // gap between top description element and top of screen
float gui_description_left_gap    = 0.05;  // gap between top description element and top of screen
float gui_description_between_gap = 0.025; // gap between description elements
float gui_description_font_width  = 0.05;
float gui_description_font_height = 0.04;
float gui_description_line_size   = 0.05;
float gui_description_depth       = 0.2;

// Buttons / Controls
int activate_button       = GR_E;
int warp_to_kernel_button = GR_R;

int move_up_button    = GR_W;
int move_left_button  = GR_A;
int move_down_button  = GR_S;
int move_right_button = GR_D;

int selection_marker_move_left_button  = GR_LEFT;
int selection_marker_move_right_button = GR_RIGHT;
int selection_marker_move_up_button    = GR_UP;
int selection_marker_move_down_button  = GR_DOWN;
int selection_marker_select_button     = GR_RETURN;

int gui_show_description_button = GR_G;
int gui_show_primary_button     = GR_H;
int gui_show_equipment_button   = GR_J;
int gui_show_items_button       = GR_K;
int gui_show_stats_button       = GR_L;

bool shift_pressed = false;
bool ctrl_pressed  = false;

bool move_up_pressed    = false;
bool move_left_pressed  = false;
bool move_down_pressed  = false;
bool move_right_pressed = false;

bool mouse_left_down = false;

// View
Vector2f view_target = Vector2f(0, 0);
Vector2f view_target_offset = Vector2f(0, 0);
Vector2f view_position = Vector2f(0, 0);
Vector2f view_velocity = Vector2f(0, 0);
float view_size = 15;
float view_pull_strength = 100.0;
float view_friction = 10;
float view_shake_amount = 0;
int view_shake_frames = 0;
bool use_spring_shake_model = false;
bool use_screen_shake = true;

float sound_max_distance = 50.0f;


class Player_effect : Effect {
  alias collide = Effect.collide;
  override void finalize(){
    nearby_drop = null;
  }
  override void collide(Drop other){
    nearby_drop = other;
  }
}

void initialize_player(){
  selection_border_image = gr_load_image("assets/gui/fancy_border.png", 0);
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
      selection_marker_on_inventory = true;
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

/*
  (Poorly) Render the gui
*/
void player_render_gui(){
  if(player_entity !is null && player_entity.valid){
    // gr_screen_draw(gui_mockup_img, 0.0f, 0.0f, 0.1f, 0.0f, 0.0f, 0.0f, 1.0f, 0.666666f);
    
    // gr_screen_draw_text(test_font, format("Player health: %f", player_entity.health).toStringz, 0.0f, 0.2f, 0.0f, 0.0f, 0.0f, 0.0f, 0.4f, 0.4f);
    // gr_screen_draw_text(test_font, format("(%.2f, %.2f)", player_entity.position.x, player_entity.position.y).toStringz, 0.0f, 0.4f, 0.0f, 0.0f, 0.0f, 0.0f, 0.5f, 0.5f);
    
    // Primary statistics: Health, Energy
    if(gui_show_primary){
      
      // Health Bar
      screen_draw_string!"centered"(
        format("HP"), 
        standard_font, 19, 5, standard_font_offset, 
        gui_panel_size / 2, gui_panel_size / 2, gui_panel_depth - 0.05f, 
        0.04f, 0.04f
      );
      gr_color(1.0f, 0.0f, 0.0f, 1.0f);
      gr_screen_draw(
        -1,
        0.0f, gui_lower_gap, gui_panel_depth,
        0.0f, 0.0f,
        0.0f,
        gui_panel_size, gui_panel_size * player_entity.health / player_entity.health_max
      );
      gr_color_alpha(1.0f);
      
      // Energy Bar (+1)
      screen_draw_string!"centered"(
        format("NRG"),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 3 / 2, gui_panel_size / 2, gui_panel_depth - 0.05,
        0.04f, 0.04f
      );
      gr_color(0.0f, 0.0f, 1.0f, 1.0f);
      gr_screen_draw(
        -1,
        gui_panel_size * 1.0f, gui_lower_gap, gui_panel_depth,
        0.0f, 0.0f,
        0.0f,
        gui_panel_size, gui_panel_size * player_entity.energy / player_entity.energy_max
      );
      gr_color_alpha(1.0f);
    }
    
    // Structured entity information (+2)
    if(gui_show_equipment && player_entity.entity_subtype_id == Entity.subtype_structured_entity){
      Structured_entity player_entity_structured = cast(Structured_entity)player_entity;
      if(player_entity_structured.weapon !is null && player_entity_structured.weapon.valid)
        gr_screen_draw(
          player_entity_structured.weapon.animation.update(game_time), 
          gui_panel_size * 2, gui_lower_gap, gui_panel_depth, 
          0.0f, 0.0f, 
          0.0f, 
          gui_panel_size
        );
      if(player_entity_structured.armor !is null && player_entity_structured.armor.valid)
        gr_screen_draw(
          player_entity_structured.armor.animation.update(game_time),
          gui_panel_size * 3, gui_lower_gap, gui_panel_depth, 
          0.0f, 0.0f, 
          0.0f, 
          gui_panel_size
        );
      if(player_entity_structured.accessory !is null && player_entity_structured.accessory.valid)
        gr_screen_draw(
          player_entity_structured.accessory.animation.update(game_time),
          gui_panel_size * 4, gui_lower_gap, gui_panel_depth, 
          0.0f, 0.0f, 
          0.0f, 
          gui_panel_size
        );
    }
    
    // Items (+5)
    if(gui_show_items){
      
      // Item selection marker over selected item
      if(selection_marker_on_inventory){
        gr_color(0.0f, 1.0f, 0.0f, 1.0f);
        gr_screen_draw(
          selection_border_image, 
          gui_panel_size * cast(float)(5 + selection_marker), gui_lower_gap, gui_panel_depth, 
          0.0f, 0.0f, 
          0.0f, 
          gui_panel_size, gui_panel_size
        );
        gr_color_alpha(1.0f);
      }
        
      // Currently selected player item
      gr_color(1.0f, 0.0f, 0.0f, 1.0f);
      gr_screen_draw(
        selection_border_image,
          gui_panel_size * cast(float)(5 + inventory_selection), gui_lower_gap, gui_panel_depth, 
          0.0f, 0.0f, 
          0.0f, 
          gui_panel_size, gui_panel_size
      );
      gr_color_alpha(1.0f);
      
      
      // Player_entity's items
      for(int i = 0; i < player_entity.items.length; i++){
        if(player_entity.items[i] !is null && player_entity.items[i].valid)
          gr_screen_draw(
            player_entity.items[i].animation.update(game_time),
            gui_panel_size * cast(float)(5 + i), gui_lower_gap, gui_panel_depth, 
            0.0f, 0.0f, 
            0.0f, 
            gui_panel_size
          );
      }
      
      // Closest drop's items
      if(nearby_drop !is null && nearby_drop.valid){
        
        // Item selection marker over selected dropitem
        if(!selection_marker_on_inventory){
          gr_color(0.0f, 1.0f, 0.0f, 1.0f);
          gr_screen_draw(
            selection_border_image, 
            gui_panel_size * cast(float)(5 + selection_marker), gui_lower_gap + gui_panel_size, gui_panel_depth, 
            0.0f, 0.0f, 
            0.0f, 
            gui_panel_size, gui_panel_size
          );
          gr_color_alpha(1.0f);
        }
        
        // Drop item selection
        gr_color(1.0f, 0.0f, 0.0f, 1.0f);
        gr_screen_draw(
          selection_border_image,
            gui_panel_size * cast(float)(5 + drop_selection), gui_lower_gap + gui_panel_size, gui_panel_depth, 
            0.0f, 0.0f, 
            0.0f, 
            gui_panel_size, gui_panel_size
        );
        gr_color_alpha(1.0f);
        
        // Drop's items
        for(int i = 0; i < nearby_drop.items.length; i++){
          if(nearby_drop.items[i] !is null && nearby_drop.items[i].valid){
            gr_screen_draw(
              nearby_drop.items[i].animation.update(game_time),
            gui_panel_size * cast(float)(5 + i), gui_lower_gap + gui_panel_size, gui_panel_depth, 
            0.0f, 0.0f, 
            0.0f, 
            gui_panel_size
            );
          }
        }
      }
    }
    
    // Stats (+13)
    if(gui_show_stats){
      
      // health
      gr_color(1.0f, 0.8f, 0.8f, 1.0f);
      screen_draw_string(
        format("hp"),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 2, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      screen_draw_string(
        format("  %2.0f / %2.0f", player_entity.health_max, player_entity.health),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 1, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      screen_draw_string(
        format("  rate: %2.1f", player_entity.health_rate),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      
      // energy
      gr_color(0.8f, 0.8f, 1.0f, 1.0f);
      screen_draw_string(
        format("nrg:"),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 5, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      screen_draw_string(
        format("  %2.0f / %2.0f", player_entity.energy_max, player_entity.energy),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 4, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      screen_draw_string(
        format("  rate: %2.1f", player_entity.energy_rate),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 3, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      
      // defence
      gr_color(0.8f, 0.8f, 0.8f, 0.5f);
      screen_draw_string(
        format("def:"),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 9, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      screen_draw_string(
        format("  l: %2.0f", player_entity.l_defence),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 8, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      screen_draw_string(
        format("  m: %2.0f", player_entity.m_defence - 100),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 7, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      screen_draw_string(
        format("  e: %2.0f", player_entity.energy_defence),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 6, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      
      // speed
      gr_color(1.0f, 0.75f, 0.25f, 0.5f);
      screen_draw_string(
        format("speed:"),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 12, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      screen_draw_string(
        format("  max: %2.0f", player_entity.max_speed),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 11, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      screen_draw_string(
        format("  rate: %2.0f", player_entity.propel_rate),
        standard_font, 19, 5, standard_font_offset,
        gui_panel_size * 13, gui_lower_gap + gui_stat_line_size * 10, gui_panel_depth,
        gui_stat_font_width, gui_stat_font_height
      );
      gr_color_alpha(1.0f);
    }
    
    // Description for world / item / weapon / armor / accessory / class / ground / wall
    if(gui_show_description){
      string type_string, name_string, description_string;
      switch(gui_description_mode){
        default: break;
        case gui_description_mode_world:
          type_string        = "World:";
          name_string        = format("%s %s", player_entity.world.standard_article, player_entity.world.name);
          description_string = player_entity.world.description.wrap(25);
          break;
        case gui_description_mode_item:
          Item display_item;
          if(selection_marker_on_inventory && player_entity.items[selection_marker] !is null)
            display_item = player_entity.items[selection_marker];
          else if(!selection_marker_on_inventory && nearby_drop !is null && nearby_drop.items[selection_marker] !is null)
            display_item = nearby_drop.items[selection_marker];
          if(display_item !is null){
            type_string        = "Item:";
            name_string        = format("%s %s", display_item.standard_article, display_item.name);
            description_string = display_item.description.wrap(25);
          }
          break;
        case gui_description_mode_weapon:
          if(player_entity.entity_subtype_id == Entity.subtype_structured_entity){
            Structured_entity player_entity_structured = cast(Structured_entity)player_entity;
            if(player_entity_structured.weapon !is null){
              type_string        = "Weapon:";
              name_string        = format("%s %s", player_entity_structured.weapon.standard_article, player_entity_structured.weapon.name);
              description_string = player_entity_structured.weapon.description.wrap(25);
            }
            else {
              type_string = "No weapon";
            }
          }
          else {
            type_string = "Can't hold a weapon";
          }
          break;
        case gui_description_mode_armor:
          if(player_entity.entity_subtype_id == Entity.subtype_structured_entity){
            Structured_entity player_entity_structured = cast(Structured_entity)player_entity;
            if(player_entity_structured.armor !is null){
              type_string        = "Armor:";
              name_string        = format("%s %s", player_entity_structured.armor.standard_article, player_entity_structured.armor.name);
              description_string = player_entity_structured.armor.description.wrap(25);
            }
            else {
              type_string = "No armor";
            }
          }
          else {
            type_string = "Can't hold armor";
          }
          break;
        case gui_description_mode_accessory:
          if(player_entity.entity_subtype_id == Entity.subtype_structured_entity){
            Structured_entity player_entity_structured = cast(Structured_entity)player_entity;
            if(player_entity_structured.accessory !is null){
              type_string        = "Accessory:";
              name_string        = format("%s %s", player_entity_structured.accessory.standard_article, player_entity_structured.accessory.name);
              description_string = player_entity_structured.accessory.description.wrap(25);
            }
            else {
              type_string = "No accessory";
            }
          }
          else {
            type_string = "Can't hold an accessory";
          }
          break;
        case gui_description_mode_class:
          type_string        = "Class:";
          name_string        = format("%s %s", player_entity.standard_article, player_entity.name);
          description_string = player_entity.description.wrap(25);
          break;
        case gui_description_mode_ground:
          if(player_entity.area !is null && player_entity.area.ground !is null){
            type_string        = "Ground:";
            name_string        = format("%s %s", player_entity.area.ground.standard_article, player_entity.area.ground.name);
            description_string = player_entity.area.ground.description.wrap(25);
          }
          break;
        case gui_description_mode_wall:
          
          break;
      }
      
      screen_draw_string(
        type_string,
        standard_font, 19, 5, standard_font_offset,
        gui_description_left_gap, gr_screen_draw_height - gui_description_upper_gap, gui_panel_depth,
        gui_description_font_width, gui_description_font_height
      );
      gr_color(1.0f, 0.0f, 0.0f, 1.0f);
      screen_draw_string(
        name_string,
        standard_font, 19, 5, standard_font_offset,
        gui_description_left_gap, gr_screen_draw_height - gui_description_upper_gap - gui_description_line_size, gui_panel_depth,
        gui_description_font_width, gui_description_font_height
      );
      gr_color_alpha(1.0f);
      screen_draw_string(
        description_string,
        standard_font, 19, 5, standard_font_offset,
        gui_description_left_gap, gr_screen_draw_height - gui_description_upper_gap - gui_description_line_size*2, gui_panel_depth,
        gui_description_font_width, gui_description_font_height
      );
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

void player_get_item(int i){
  if(player_entity !is null && player_entity.valid && nearby_drop !is null && nearby_drop.valid && nearby_drop.items[i] !is null){
    for(int j = 0; j < player_entity.items.length; j++){
      if(player_entity.items[j] is null){
        player_entity.items[j] = nearby_drop.items[i];
        nearby_drop.remove_item(i);
        return;
      }
    }
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

void selection_marker_move_left(){
  if(nearby_drop is null)
    selection_marker_on_inventory = true;
  int old_selection = selection_marker;
  selection_marker --;
  if(selection_marker < 0)
    selection_marker = 7;
  if(ctrl_pressed){
    if(player_entity !is null && player_entity.items[old_selection] !is null){
      Item temp = player_entity.items[selection_marker];
      player_entity.items[selection_marker] = player_entity.items[old_selection];
      player_entity.items[old_selection] = temp;
    }
  }
}

void selection_marker_move_right(){
  if(nearby_drop is null)
    selection_marker_on_inventory = true;
  int old_selection = selection_marker;
  selection_marker ++;
  if(selection_marker > 7)
    selection_marker = 0;
  if(ctrl_pressed){
    if(player_entity !is null && player_entity.items[old_selection] !is null){
      Item temp = player_entity.items[selection_marker];
      player_entity.items[selection_marker] = player_entity.items[old_selection];
      player_entity.items[old_selection] = temp;
    }
  }
}

void player_drop_item(int i){
  if(player_entity !is null && player_entity.world !is null && player_entity.items[i] !is null){
    write_location_debug;
    // there currently is a drop
    if(nearby_drop !is null && nearby_drop.valid){
      write_location_debug;
      int drop_space = nearby_drop.find_empty_space;
      // has an empty spot for the item
      if(drop_space >= 0){
        write_location_debug;
        nearby_drop.items[drop_space] = player_entity.items[i];
        player_entity.items[i] = null;
      }
      // its full -> create a new drop
      else {
        write_location_debug;
        Drop new_drop = drop_decide_tier(player_entity.items[i].tier);
        new_drop.position = player_entity.position;
        player_entity.world.place_agent(new_drop);
        new_drop.add_item(player_entity.items[i]);
        player_entity.items[i] = null;
      }
    }
    // there is no drop nearby
    else {
      write_location_debug;
      Drop new_drop = drop_decide_tier(player_entity.items[i].tier);
      new_drop.position = player_entity.position;
      player_entity.world.place_agent(new_drop);
      new_drop.add_item(player_entity.items[i]);
      player_entity.items[i] = null;
    }
  }
}

void player_grab_item(int i){
  if(player_entity !is null && nearby_drop !is null && nearby_drop.items[i] !is null){
    int inventory_space = player_entity.find_empty_space;
    if(inventory_space >= 0){
      player_entity.items[inventory_space] = nearby_drop.items[i];
      nearby_drop.remove_item(i);
    }
  }
}

void selection_marker_switch(){
  if(nearby_drop !is null){
    selection_marker_on_inventory = !selection_marker_on_inventory;
  }
}

void selection_marker_activate(){
  if(selection_marker_on_inventory){
    Item item = player_entity.items[selection_marker];
    if(item !is null){
      if(item.item_subtype_id != Item.subtype_item)
        player_equip_item(selection_marker);
      else
        player_use_item(selection_marker);
    }
  }
}

void selection_marker_swap(){
  if(!selection_marker_on_inventory)
    player_get_item(selection_marker);
}

void selection_marker_select(){
  static long selection_marker_double_select_time;
  static immutable(long) selection_marker_double_select_delay = 200;
  if(selection_marker_on_inventory){
    if(selection_marker == inventory_selection && game_time < selection_marker_double_select_time)
      selection_marker_activate;
    else
      inventory_selection = selection_marker;
  }
  else {
    if(selection_marker == drop_selection && game_time < selection_marker_double_select_time)
      selection_marker_swap;
    else
      drop_selection = selection_marker;
  }
  selection_marker_double_select_time = game_time + selection_marker_double_select_delay;
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
    
    // GUI selection marker movement
    case selection_marker_move_left_button:
      if(gr_key_pressed)
        selection_marker_move_left;
      break;
    case selection_marker_move_right_button:
      if(gr_key_pressed)
        selection_marker_move_right;
      break;
    case selection_marker_move_down_button:
      if(gr_key_pressed){
        if(ctrl_pressed && !selection_marker_on_inventory)
          player_grab_item(selection_marker);
        else
          selection_marker_switch;
      }
    case selection_marker_move_up_button:
      if(gr_key_pressed){
        if(ctrl_pressed && selection_marker_on_inventory)
          player_drop_item(selection_marker);
        else
          selection_marker_switch;
      }
      break;
    
    // GUI selection marker selecting
    case selection_marker_select_button:
      if(gr_key_pressed)
        selection_marker_select;
      break;
      
    // Gui toggles
    case gui_show_primary_button:
      if(gr_key_pressed)
        gui_show_primary = !gui_show_primary;
      break;
    case gui_show_description_button:
      if(gr_key_pressed)
        gui_show_description = !gui_show_description;
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
    
    case gui_description_mode_world_button:     if(gr_key_pressed) gui_description_mode = gui_description_mode_world; break;
    case gui_description_mode_item_button:      if(gr_key_pressed) gui_description_mode = gui_description_mode_item; break;
    case gui_description_mode_weapon_button:    if(gr_key_pressed) gui_description_mode = gui_description_mode_weapon; break;
    case gui_description_mode_armor_button:     if(gr_key_pressed) gui_description_mode = gui_description_mode_armor; break;
    case gui_description_mode_accessory_button: if(gr_key_pressed) gui_description_mode = gui_description_mode_accessory; break;
    case gui_description_mode_class_button:     if(gr_key_pressed) gui_description_mode = gui_description_mode_class; break;
    case gui_description_mode_ground_button:    if(gr_key_pressed) gui_description_mode = gui_description_mode_ground; break;
    case gui_description_mode_wall_button:      if(gr_key_pressed) gui_description_mode = gui_description_mode_wall; break;
    
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