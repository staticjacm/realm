module game;

import std.stdio;
import std.string;
import core.thread;
import std.math;

import sgogl;
import sgogl_interface;

import text;
import dbg;
import timer;
import make;
import renderable;
import world;
import portal;
import area;
import rooted;
import entity;
import drop;
import structured_entity;
import agent;
import ground;
import decoration;
import vector;
import player;
import game;
import wall;
import drop_tiers;
import kernel;

alias Vector2f = Vector2!float;

// enum {
//   mode_loading,
//   mode_playing
// }
// int game_mode = mode_playing;

uint loading_image = 0;

Structured_entity test_entity;
World test_world;
World kernel_world;
World entry;

bool running = true;

Timer test_timer;

uint standard_font;
float standard_font_offset = 0.4;
uint test_font;
uint test_bitmap_font;

Timer game_timer;
Timer frame_delay_helper;
Timer frame_timer;
long frame_time = 0;
long game_time;
float frame_delta = 0.001;
float frame_delta_2 = 0.001;
long frame = 0;

bool use_framerate_cap = true;
float framerate_cap = 30.0f;
long frame_delay = 0;

uint test_img;
uint gui_mockup_img;
float test_x = 0.0, test_y = 0.0;

void key_function(){
  player_key_function();
  // writefln(" key %d", gr_key);
  switch(gr_scancode){
    case GR_SCANCODE_KP_4:     gr_set_screen_size(gr_screen_width - 10, gr_screen_height); writefln("< screen size %d %d", gr_screen_width, gr_screen_height); goto case GR_SCANCODE_KP_ENTER;
    case GR_SCANCODE_KP_6:     gr_set_screen_size(gr_screen_width + 10, gr_screen_height); writefln("> screen size %d %d", gr_screen_width, gr_screen_height); goto case GR_SCANCODE_KP_ENTER;
    case GR_SCANCODE_KP_8:     gr_set_screen_size(gr_screen_width, gr_screen_height + 10); writefln("^ screen size %d %d", gr_screen_width, gr_screen_height); goto case GR_SCANCODE_KP_ENTER;
    case GR_SCANCODE_KP_2:     gr_set_screen_size(gr_screen_width, gr_screen_height - 10); writefln("v screen size %d %d", gr_screen_width, gr_screen_height); goto case GR_SCANCODE_KP_ENTER;
    case GR_SCANCODE_KP_ENTER: gr_clear_all; break;
    // case GR_SCANCODE_R: gr_set_keep_window_aspect = 1; writeln("keep_window_aspect 1");   break;
    // case GR_SCANCODE_F: gr_set_keep_window_aspect = 0; writeln("keep_window_aspect 0");   break;
    // case GR_SCANCODE_T: gr_set_center_screen = 1;      writeln("center_screen 1");        break;
    // case GR_SCANCODE_G: gr_set_center_screen = 0;      writeln("center_screen 0");        break;
    // case GR_SCANCODE_Y: gr_set_stretch_screen = 1;     writeln("stretch_screen 1");       break;
    // case GR_SCANCODE_H: gr_set_stretch_screen = 0;     writeln("stretch_screen 0");       break;
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

// void set_game_mode_loading_screen(uint image){
  // game_mode = mode_loading;
  // loading_image = image;
// }

// void set_game_mode_playing(){
  // game_mode = mode_playing;
// }

void game_render_loading_screen(uint image, float loaded){
  gr_clear;
  gr_screen_draw(image, 0.0f, 0.0f, 0.1f, 0.0f, 0.0f, 0.0f, 1.0f, 0.76f);
  gr_screen_draw_text(test_font, format("%2.2f", loaded).toStringz, 0.5, 0.25, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f);
  gr_refresh;
}

void initialize(){
  gr_open;
  gr_activate_depth_testing(1);
  gr_activate_linear_filtering(0);
  gr_set_max_depth(20000.0f);
  gr_set_window_size(600, 400);
  gr_set_center_screen = 1;
  // gr_set_screen_size(2400, 1600);
  // gr_set_screen_size(1200, 800);
  gr_set_screen_size(600, 400);
  // gr_set_screen_size(300, 200);
  // writefln("a");
  // test_font = gr_load_ttf("cour.ttf".toStringz, 128.0);
  test_font = gr_load_ttf("assets/fonts/ariblk.ttf".toStringz, 128.0);
  standard_font = gr_load_image("assets/fonts/cour_low.png".toStringz, 0);
  test_bitmap_font = gr_load_image("assets/fonts/cour_low.png".toStringz, 0);
  // test_font = gr_load_ttf("", 32.0f);
  // writefln("b");
  
  // load_character_images;
  
  initialize_debug;
  initialize_player;
  
  initialize_drop_tiers;
  
  World.initialize_type;
  // Kernel.initialize_type;
  // Entry_world_1.initialize_type;
  Area.initialize_type;
  Agent.initialize_type;
  Rooted.initialize_type;
  Renderable.initialize_type;
  make.initialize_type!"Kernel";
  make.initialize_type!"Entry_world_1";
  make.initialize_type!"Commoner_1";
  make.initialize_type!"Commoner_1_token";
  make.initialize_type!"Drop_tier_0";
  make.initialize_type!"Testing_world_1";
  make.initialize_type!"Fire_staff_1";
  make.initialize_type!"Shirt_1";
  make.initialize_type!"Ring_of_defence_1";
  make.initialize_type!"Ring_of_speed_1";
  make.initialize_type!"Dev_ring_1";
  make.initialize_type!"Fire_turret_1";
  make.initialize_type!"Kernel_portal_1";
  make.initialize_type!"Generic_portal_1";
  make.initialize_type!"Island_world_1";
  
  test_img = gr_load_image("assets/test_img.png".toStringz, 0);
  gui_mockup_img = gr_load_image("assets/gui/gui_mockup.png".toStringz, 0);
  
  gr_view_centered(Vector2f(0, 0), 10);
  
  entry = make_world!"Entry_world_1";
  
  Drop test_drop = make_drop!"Drop_tier_0";
  test_drop.add_item(make_item!"Ring_of_defence_1");
  
  // test_entity = cast(Structured_entity)(new Commoner);
  test_entity = make_structured_entity!"Commoner_1";
  test_entity.position = Vector2f(10.5, 10.5);
  test_entity.automatic_controls = false;
  test_entity.faction_id = 0;
  test_entity.equip_weapon(make_weapon!"Fire_staff_1");
  test_entity.equip_armor(make_armor!"Shirt_1");
  test_entity.equip_accessory(make_accessory!"Ring_of_defence_1");
  test_entity.items[0] = make_item!"Dev_ring_1";
  test_entity.items[1] = make_item!"Ring_of_speed_1";
  test_entity.items[2] = make_item!"Ring_of_defence_1";
  test_entity.items[3] = make_item!"Ring_of_speed_1";
  test_entity.items[4] = make_item!"Ring_of_defence_1";
  test_entity.items[5] = make_item!"Ring_of_speed_1";
  test_entity.items[6] = make_item!"Ring_of_defence_1";
  test_entity.items[7] = make_item!"Commoner_1_token";
  player_register(test_entity);
  
  // kernel_world = new Kernel;
  
  Structured_entity enemy;
  enemy = make_structured_entity!"Commoner_1";
  enemy.position = Vector2f(17.0f, 17.0f);
  enemy.automatic_controls = true;
  enemy.faction_id = 1;
  enemy.equip_weapon(make_weapon!"Fire_staff_1");
  enemy.equip_armor(make_armor!"Shirt_1");
  enemy.equip_accessory(make_accessory!"Ring_of_defence_1");
  
  Agent turret = make_agent!"Fire_turret_1";
  turret.position = Vector2f(17.0f, 17.0f);
  
  Portal test_portal_1 = make_portal!"Kernel_portal_1";
  test_portal_1.position = Vector2f(20.0f, 20.0f);
  test_portal_1.exit_position = Vector2f(25.0f, 20.0f);
  
  Portal test_portal_2 = make_portal!"Kernel_portal_1";
  // test_portal_2.position = Kernel.center_spawn + Vector2f(2.0f, 0.0f);
  test_portal_2.position = Vector2f(25.0f, 20.0f);
  test_portal_2.exit_position = Vector2f(20.0f, 20.0f);
  
  test_world = make_world!"Testing_world_1";
  
  Portal island_portal = make_portal!"Generic_portal_1";
  island_portal.position = Vector2f(19.0f, 19.0f);
  island_portal.exit_world = make_world!"Island_world_1";
  island_portal.exit_position = Vector2f(0, 0);
  test_world.place_agent(island_portal);
  
  test_world.place_agent(player_entity);
  // test_world.place_agent(enemy);
  test_world.place_agent(turret);
  test_world.place_agent(test_portal_1);
  // test_world.place_agent(test_portal_2);
  test_portal_1.exit_world = test_world;
  // player_entity.world = test_world;
  test_drop.position = Vector2f(21.0f, 19.0f);
  // test_drop.world = test_world;
  test_world.place_agent(test_drop);
  // player_entity.position = Kernel.center_spawn;
  
  World test_world_2 = make_world!"Testing_world_1";
  test_world_2 = make_world!"Testing_world_1";
  test_world_2.place_agent(player_entity);
  test_world_2.place_agent(test_portal_2);
  
  test_portal_1.exit_world = test_world_2;
  test_portal_2.exit_world = test_world;
  
  // kernel_world = new Kernel;
  // kernel_world = new Kernel;
  // test_portal_1.exit_world = kernel_world;
  // kernel_world.place_agent(test_portal_2);
  // player_entity.world = kernel_world;
  // player_entity.position = Kernel.center_spawn;
  
  game_timer.start;
  frame_timer.start;
}

void quit(){
  gr_close;
}

void render(){

  // frame_time = frame_timer.msecs;
  // frame_delta = frame_timer.hnsecsf;
  // frame_timer.start;
  gr_clear;
  
  render_debug;
  
  // test_world.render;
  
  //foreach(Agent agent; Agent.master_list){
  //  agent.render;
  //}
  
  player_render_near;
  
  gr_draw_partial(test_img, 0, 0, 1, 0.5, test_x, test_y, 1.0, 0.5, 0.5, 0.0, 0.5, 0.5);
  
  gr_color(1.0, 0.0, 0.0, 1.0);
  gr_draw_line(player_entity.position, Vector2f(0, 0), 1.0);
  gr_color(0.0, 1.0, 0.0, 1.0);
  gr_draw_line(player_entity.position, player_entity.position + player_entity.velocity/10, 1.0);
  gr_color_alpha(1.0);
  
  // if(player_entity !is null){
  //   gr_color(1.0f, 0.0f, 0.0f, 1.0f);
  //   screen_draw_string(format("speed %2.2f", player_entity.speed), test_bitmap_font, 19, 5, 0.3, 0.1f, 0.2f, 0.0f, 0.04f, 0.04f);
  //   gr_color_alpha(1.0f);
  //   
  //   if(player_entity.area !is null && player_entity.area.ground !is null)
  //     screen_draw_string(format("%s %s", player_entity.area.ground.standard_article, player_entity.area.ground.name), test_bitmap_font, 19, 5, 0.3, 0.1f, 0.25f, 0.0f, 0.04f, 0.04f);
  // }
  
  player_render_gui;
  
  gr_refresh;
}

immutable(bool) debug_update = false;
void update(){
  
  debug_write_1(game_time);
  debug_write_2(format("%2.2f", frame_delta));
  
  static if(debug_update) write_location_debug;
  game_time = game_timer.msecs;
  frame++;

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
  if(frame % 500 == 0){
    writefln("frame_delta: %2.2f ms = %2.1f fps", frame_delta*1000.0f, 1.0f/frame_delta);
    writefln("  frame_delay: %d ms = %2.1f fps", frame_delay, 1000.0f/cast(float)frame_delay);
    writeln("  number of agents: ", Agent.master_list.length);
    writeln("  number of decorations: ", Decoration.total_number);
    writeln("  number of areas: ", Area.total_number);
  }
  // if(current_game_time > 5000) running = false;
  
  static if(debug_update) write_location_debug;
  if(use_framerate_cap){
    // frame_delay = cast(long)(1000.0f / framerate_cap - frame_delay_helper.msecs);
    // if(frame_delay < 0)
      // frame_delay = 0;
    if(frame_delay_helper.msecs < cast(long)(1000.0f / framerate_cap))
      frame_delay ++;
    else
      frame_delay --;
    if(frame_delay < 0)
      frame_delay = 0;
  }
  else 
    frame_delay = 0;
  frame_delay_helper.start;
  frame_delta = frame_timer.hnsecsf;
  frame_time = frame_timer.msecs;
  frame_timer.start;
  // Thread.sleep(dur!"msecs"(cast(long)(game_time / 100)));
  Thread.sleep(dur!"msecs"(frame_delay));
  static if(debug_update) write_location_debug;
}