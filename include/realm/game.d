module game;

import std.stdio;
import std.string;
import core.thread;
import std.math;

import sgogl;
import sgogl_interface;

import dbg;
import timer;
import testing_world;
import renderable;
import world;
import area;
import commoner;
import fire_staff;
import ring_of_defence;
import ring_of_speed;
import shirt;
import rooted;
import entity;
import drop;
import drop_tiers;
import structured_entity;
import agent;
import ground;
import rocky_ground_1;
import decoration;
import vector;
import player;
import game;
import wall;
import kernel;
import cactus1;
import turret;
import kernel_portal;

alias Vector2f = Vector2!float;

File fileout1, fileout2;

Structured_entity test_entity;
World test_world;
World kernel_world;

bool running = true;

Timer test_timer;

uint test_font;

Timer game_timer;
Timer frame_timer;
long frame_time = 0;
long game_time;
float frame_delta = 0.001;
long frame = 0;

uint test_img;
uint gui_mockup_img;
float test_x = 0.0, test_y = 0.0;

void key_function(){
  player_key_function();
  // writefln(" key %d", gr_key);
  switch(gr_scancode){
    case GR_SCANCODE_LEFT: gr_set_screen_size(gr_screen_width - 10, gr_screen_height);  writefln("< screen size %d %d", gr_screen_width, gr_screen_height); goto case GR_SCANCODE_RETURN;
    case GR_SCANCODE_RIGHT: gr_set_screen_size(gr_screen_width + 10, gr_screen_height); writefln("> screen size %d %d", gr_screen_width, gr_screen_height); goto case GR_SCANCODE_RETURN;
    case GR_SCANCODE_UP: gr_set_screen_size(gr_screen_width, gr_screen_height + 10);    writefln("^ screen size %d %d", gr_screen_width, gr_screen_height); goto case GR_SCANCODE_RETURN;
    case GR_SCANCODE_DOWN: gr_set_screen_size(gr_screen_width, gr_screen_height - 10);  writefln("v screen size %d %d", gr_screen_width, gr_screen_height); goto case GR_SCANCODE_RETURN;
    case GR_SCANCODE_RETURN: gr_clear_all; break;
    case GR_SCANCODE_R: gr_set_keep_window_aspect = 1; writeln("keep_window_aspect 1");   break;
    case GR_SCANCODE_F: gr_set_keep_window_aspect = 0; writeln("keep_window_aspect 0");   break;
    case GR_SCANCODE_T: gr_set_center_screen = 1;      writeln("center_screen 1");        break;
    case GR_SCANCODE_G: gr_set_center_screen = 0;      writeln("center_screen 0");        break;
    case GR_SCANCODE_Y: gr_set_stretch_screen = 1;     writeln("stretch_screen 1");       break;
    case GR_SCANCODE_H: gr_set_stretch_screen = 0;     writeln("stretch_screen 0");       break;
    default: break;
  }
}

void mouse_click_function(){
  player_mouse_click_function;
}

void mouse_move_function(){
  gr_read_mouse;
  test_x = gr_mouse_x.gr_screen_to_world_x;
  test_y = gr_mouse_y.gr_screen_to_world_y;
}

void window_event_function(){
}

void initialize(){
  gr_open;
  gr_activate_depth_testing(1);
  gr_activate_linear_filtering(0);
  gr_set_max_depth(1000.0f);
  gr_set_window_size(600, 400);
  gr_set_center_screen = 1;
  // gr_set_screen_size(2400, 1600);
  // gr_set_screen_size(1200, 800);
  gr_set_screen_size(600, 400);
  // gr_set_screen_size(300, 200);
  // writefln("a");
  // test_font = gr_load_ttf("cour.ttf".toStringz, 128.0);
  test_font = gr_load_ttf("assets/fonts/ariblk.ttf".toStringz, 128.0);
  // test_font = gr_load_ttf("", 32.0f);
  // writefln("b");
  
  // load_character_images;
  
  // fileout1 = File("debug_data1.txt", "w");
  // fileout2 = File("debug_data2.txt", "w");
  
  
  initialize_drop_tiers;
  
  World.initialize_type;
  Kernel.initialize_type;
  Area.initialize_type;
  Agent.initialize_type;
  Rooted.initialize_type;
  Renderable.initialize_type;
  Commoner.initialize_type;
  Drop_tier_0.initialize_type;
  Testing_world.initialize_type;
  Fire_staff_1.initialize_type;
  Shirt_1.initialize_type;
  Ring_of_defence_1.initialize_type;
  Ring_of_speed_1.initialize_type;
  Fire_turret_1.initialize_type;
  Kernel_portal_1.initialize_type;
  
  test_img = gr_load_image("assets/test_img.png".toStringz, 0);
  gui_mockup_img = gr_load_image("assets/gui/gui_mockup.png".toStringz, 0);
  
  gr_view_centered(Vector2f(0, 0), 10);
  
  Drop test_drop = new Drop_tier_0;
  test_drop.add_item(new Ring_of_defence_1);
  
  // test_entity = cast(Structured_entity)(new Commoner);
  test_entity = new Commoner;
  test_entity.position = Vector2f(10.5, 10.5);
  test_entity.automatic_controls = false;
  test_entity.faction_id = 0;
  test_entity.equip_weapon(new Fire_staff_1);
  test_entity.equip_armor(new Shirt_1);
  test_entity.equip_accessory(new Ring_of_defence_1);
  test_entity.items[0] = new Ring_of_defence_1;
  test_entity.items[1] = new Ring_of_speed_1;
  test_entity.items[2] = new Ring_of_defence_1;
  test_entity.items[3] = new Ring_of_speed_1;
  test_entity.items[4] = new Ring_of_defence_1;
  test_entity.items[5] = new Ring_of_speed_1;
  test_entity.items[6] = new Ring_of_defence_1;
  player_register(test_entity);
  
  Structured_entity enemy;
  enemy = new Commoner;
  enemy.position = Vector2f(17.0f, 17.0f);
  enemy.automatic_controls = true;
  enemy.faction_id = 1;
  enemy.equip_weapon(new Fire_staff_1);
  enemy.equip_armor(new Shirt_1);
  enemy.equip_accessory(new Ring_of_defence_1);
  enemy.items[0] = new Ring_of_defence_1;
  enemy.items[1] = new Ring_of_speed_1;
  enemy.items[2] = new Ring_of_defence_1;
  enemy.items[3] = new Ring_of_speed_1;
  enemy.items[4] = new Ring_of_defence_1;
  enemy.items[5] = new Ring_of_speed_1;
  enemy.items[6] = new Ring_of_defence_1;
  
  Fire_turret_1 turret = new Fire_turret_1;
  turret.position = Vector2f(17.0f, 17.0f);
  
  Kernel_portal_1 test_portal_1 = new Kernel_portal_1;
  test_portal_1.position = Vector2f(20.0f, 20.0f);
  test_portal_1.exit_position = Vector2f(25.0f, 20.0f);
  
  Kernel_portal_1 test_portal_2 = new Kernel_portal_1;
  // test_portal_2.position = Kernel.center_spawn + Vector2f(2.0f, 0.0f);
  test_portal_2.position = Vector2f(25.0f, 20.0f);
  test_portal_2.exit_position = Vector2f(20.0f, 20.0f);
  
  test_world = new Testing_world();
  test_world.place_agent(player_entity);
  test_world.place_agent(enemy);
  test_world.place_agent(turret);
  test_world.place_agent(test_portal_1);
  test_world.place_agent(test_portal_2);
  test_portal_1.exit_world = test_world;
  test_portal_2.exit_world = test_world;
  // player_entity.world = test_world;
  test_drop.position = Vector2f(21.0f, 19.0f);
  // test_drop.world = test_world;
  test_world.place_agent(test_drop);
  // player_entity.position = Kernel.center_spawn;
  
  // kernel_world = new Kernel;
  // test_portal_1.exit_world = kernel_world;
  // kernel_world.place_agent(test_portal_2);
  // player_entity.world = kernel_world;
  // player_entity.position = Kernel.center_spawn;
  
  game_timer.start;
}

void quit(){
  gr_close;
}

void render(){

  gr_clear;
  
  // test_world.render;
  
  //foreach(Agent agent; Agent.master_list){
  //  agent.render;
  //}
  
  player_render_near;
  
  gr_draw_centered(test_img, test_x, test_y, 1.0, 0.0, 0.5, 0.5);
  
  gr_color(1.0, 0.0, 0.0, 1.0);
  gr_draw_line(player_entity.position, Vector2f(0, 0), 1.0);
  gr_color(0.0, 1.0, 0.0, 1.0);
  gr_draw_line(player_entity.position, player_entity.position + player_entity.velocity/10, 1.0);
  gr_color_alpha(1.0);
  
  player_render_gui;
  
  gr_refresh;
}

immutable(bool) debug_update = false;
void update(){
  
  static if(debug_update) write_location_debug;
  game_time = game_timer.msecs;
  frame++;
  frame_timer.start;

  static if(debug_update) write_location_debug;
  gr_register_events();  
  while(gr_has_event()){
    switch(gr_read()){
      case GR_CLOSE: running = false; break;
      case GR_KEY_EVENT: key_function; break;
      case GR_MOUSE_BUTTON_EVENT: mouse_click_function; break;
      case GR_MOUSE_MOVE_EVENT: mouse_move_function; break;
      case GR_WINDOW_EVENT: window_event_function; break;
      default: break;
    }
  }
  
  static if(debug_update) write_location_debug;
  player_update;
  
  static if(debug_update) write_location_debug;
  foreach(Agent agent; Agent.master_list){
    agent.update;
  }
  
  static if(debug_update) write_location_debug;
  foreach(World world; World.master_list){
    world.update;
  }
  
  static if(debug_update) write_location_debug;
  foreach(Rooted rooted; Rooted.update_list){
    rooted.update;
  }
  
  static if(debug_update) write_location_debug;
  foreach(Area area; Area.update_list){
    area.update;
  }
  
  static if(debug_update) write_location_debug;
  render;
  
  static if(debug_update) write_location_debug;
  frame_time = frame_timer.msecs;
  frame_delta = frame_timer.hnsecsf;
  static if(debug_update) write_location_debug;
  if(frame % 1000 == 0){
    writeln("frame_delta: ", floor(frame_delta * 10000)/10, " ms = " , floor(1/frame_delta), " fps");
    writeln("  number of agents: ", Agent.master_list.length);
    writeln("  number of decorations: ", Decoration.total_number);
    writeln("  number of areas: ", Area.total_number);
  }
  // if(current_game_time > 5000) running = false;
  static if(debug_update) write_location_debug;
  Thread.sleep(dur!"msecs"(1));
  static if(debug_update) write_location_debug;
}