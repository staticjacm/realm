import std.stdio;
import std.string;

import sgogl;
import sgogl_interface;

import core.thread;
import std.math;
import timer;
import testing_world;
import world;
import commoner;
import entity;
import agent;
import ground;
import rocky_ground;
import vector;
import player;

// extern (C) void dmd_coverSourcePath( string pathname );
// extern (C) void dmd_coverDestPath( string pathname );

alias Vector2f = Vector2!float;

Entity test_entity;
World test_world;

bool running = true;

Timer game_timer;
Timer frame_timer;
long current_frame_time = 0;
long current_game_time = 0;
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
  gr_open;
  gr_activate_depth_testing(1);
  gr_activate_linear_filtering(0);
  gr_set_max_depth(1000.0f);
  
  test_img = gr_load_image("assets/test_img.png".toStringz, 0);
  
  gr_view_centered(Vector2f(0, 0), 10);
  
  Commoner.initialize_type;
  Testing_world.initialize_type;
  test_entity = new Commoner(Vector2f(10.5, 10.5), 1);
  player_entity = test_entity;
  test_world = new Testing_world();
  test_entity.world = test_world;
  
  game_timer.start;
}

void render(){
  gr_clear;
  // gr_clear_depth;
  test_world.render(current_game_time);
  // Agent.render_all(current_time);
  foreach(Agent agent; Agent.master_list){
    agent.render(current_game_time);
  }
  
  gr_draw_centered(test_img, test_x, test_y, 1.0, 0.0, 0.5, 0.5);
  
  gr_color(1.0, 0.0, 0.0, 1.0);
  gr_draw_line(player_entity.position, Vector2f(0, 0), 1.0);
  gr_color(0.0, 1.0, 0.0, 1.0);
  gr_draw_line(player_entity.position, player_entity.position + player_entity.velocity/10, 1.0);
  gr_color_alpha(1.0);
  
  gr_refresh;
}

void update(){
  current_game_time = game_timer.msecs;
  frame++;
  frame_timer.start;
  
  gr_register_events();
  while(gr_has_event()){
    switch(gr_read()){
      case GR_CLOSE: running = false; break;
      case GR_KEY_EVENT: key_function; break;
      case GR_MOUSE_BUTTON_EVENT: mouse_click_function; break;
      case GR_MOUSE_MOVE_EVENT: mouse_move_function; break;
      default: break;
    }
  }
  
  player_update(current_game_time, frame_delta);
  foreach(Agent agent; Agent.master_list){
    agent.update(current_game_time, frame_delta);
  }
  test_world.update(current_game_time, frame_delta);
  
  render;
  
  current_frame_time = frame_timer.msecs;
  frame_delta = frame_timer.hnsecsf;
  if(frame % 100 == 0){
    writeln("frame_delta: ", floor(frame_delta * 10000)/10, " ms = " , floor(1/frame_delta), " fps");
    writeln("  number of agents: ", Agent.master_list.length);
  }
  // if(current_game_time > 5000) running = false;
  // Thread.sleep(2.dur!"msecs");
}

void main(){
  "start".writeln;
  
  // dmd_coverSourcePath("cov");
  // dmd_coverDestPath("cov");
  
  initialize;
  
  while(running){
    update;
  }
  
}