module game;

import std.stdio;
import std.string;
import core.thread;
import std.math;

import sgogl;
import sgogl_interface;

import timer;
import testing_world;
import world;
import area;
import commoner;
import rooted;
import entity;
import agent;
import ground;
import rocky_ground;
import vector;
import player;
import game;
import wall;
import rocky_ground;
import cactus1;

alias Vector2f = Vector2!float;

Entity test_entity;
World test_world;

bool running = true;

Timer test_timer;

Timer game_timer;
Timer frame_timer;
long frame_time = 0;
long game_time;
float frame_delta = 0.001;
long frame = 0;

uint test_img;
float test_x = 0.0, test_y = 0.0;

void key_function(){
  player_key_function();
}

void mouse_click_function(){
  player_mouse_click_function;
}

void mouse_move_function(){
  gr_read_mouse;
  test_x = gr_mouse_x.gr_screen_to_world_x;
  test_y = gr_mouse_y.gr_screen_to_world_y;
}

void initialize(){
  test_timer.start;
  gr_open;
  gr_activate_depth_testing(1);
  gr_activate_linear_filtering(0);
  gr_set_max_depth(1000.0f);
  writefln("graphics init %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  Area.initialize;
  // writefln("area init %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  Agent.initialize;
  // writefln("area init %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  Rooted.initialize;
  // writefln("rooted init %f", test_timer.hnsecsf*1000.0f);
  
  test_img = gr_load_image("assets/test_img.png".toStringz, 0);
  
  gr_view_centered(Vector2f(0, 0), 10);
  
  // Rooted.initialize;
  
  // test_timer.start;
  Commoner.initialize_type;
  // writefln("commoner init %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  Testing_world.initialize_type;
  // writefln("test_world init %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  test_entity = new Commoner(Vector2f(10.5, 10.5), 1);
  player_entity = test_entity;
  test_world = new Testing_world();
  test_entity.world = test_world;
  // writefln("additions init %f", test_timer.hnsecsf*1000.0f);
  
  // Ground new_ground = new Rocky_ground(Vector2f(-2,-2));
  // Wall new_wall = new Cactus1(Vector2f(-2,-2));
  // new_ground.id = 77777;
  // new_wall.id = 99999;
  // test_world.add_ground(new_ground);
  // test_world.add_wall(new_wall);
  
  game_timer.start;
}

void quit(){
  gr_close;
}

void render(){
  gr_clear;
  
  // test_timer.start;
  test_world.render;
  // writefln("test_world.render %f", test_timer.hnsecsf*1000.0f);
  
  
  // test_timer.start;
  foreach(Agent agent; Agent.master_list){
    agent.render;
  }
  // writefln("agents render %f", test_timer.hnsecsf*1000.0f);
  
  player_render_near;
  
  // test_timer.start;
  gr_draw_centered(test_img, test_x, test_y, 1.0, 0.0, 0.5, 0.5);
  // writefln("gr_draw_centered %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  gr_color(1.0, 0.0, 0.0, 1.0);
  gr_draw_line(player_entity.position, Vector2f(0, 0), 1.0);
  gr_color(0.0, 1.0, 0.0, 1.0);
  gr_draw_line(player_entity.position, player_entity.position + player_entity.velocity/10, 1.0);
  gr_color_alpha(1.0);
  // writefln("other stuff %f", test_timer.hnsecsf*1000.0f);
  
  gr_refresh;
}

void update(){
  
  game_time = game_timer.msecs;
  // writeln("game time ", game_time);
  frame++;
  frame_timer.start;
  
  // test_timer.start;
  gr_register_events();
  // writefln("register events %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  while(gr_has_event()){
    switch(gr_read()){
      case GR_CLOSE: running = false; break;
      case GR_KEY_EVENT: key_function; break;
      case GR_MOUSE_BUTTON_EVENT: mouse_click_function; break;
      case GR_MOUSE_MOVE_EVENT: mouse_move_function; break;
      default: break;
    }
  }
  // writefln("do events %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  player_update;
  // writefln("player_update %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  foreach(Agent agent; Agent.master_list){
    agent.update;
  }
  // writefln("agent.update_list %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  foreach(Rooted rooted; Rooted.update_list){
    rooted.update;
  }
  // writefln("rooted.update_list %f", test_timer.hnsecsf*1000.0f);
  
  // test_timer.start;
  foreach(Area area; Area.update_list){
    area.update;
  }
  // writefln("area.update_list %f", test_timer.hnsecsf*1000.0f);
  
  // test_world.update;
  
  // test_timer.start;
  render;
  // writefln("render %f", test_timer.hnsecsf*1000.0f);
  
  frame_time = frame_timer.msecs;
  frame_delta = frame_timer.hnsecsf;
  if(frame % 100 == 0){
    writeln("frame_delta: ", floor(frame_delta * 10000)/10, " ms = " , floor(1/frame_delta), " fps");
    writeln("  number of agents: ", Agent.master_list.length);
  }
  // if(current_game_time > 5000) running = false;
  Thread.sleep(dur!"msecs"(0));
}