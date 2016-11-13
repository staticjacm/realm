import std.stdio;

import sgogl;
import sgogl_interface;

import testing_world;
import world;
import agent;
import vector;
import player;

alias Vector2f = Vector2!float;

Agent test_agent;
World test_world;

Vector2f mouse_world_position = Vector2f(0, 0);
int move_up_button    = GR_W;
int move_left_button  = GR_A;
int move_down_button  = GR_S;
int move_right_button = GR_D;

bool running = true;
long current_time = 0;

void initialize(){
  gr_open;
  gr_activate_linear_filtering(0);
  
  gr_view_centered(Vector2f(0, 0), 10);
  
  Testing_world.initialize_type;
  test_agent = new Agent(Vector2f(0, 0), 1);
  test_world = new Testing_world();
}

void render(){
  gr_clear;
  test_world.render(current_time);
  gr_refresh;
}

void update(){
  current_time++; // should be set to the current time in ms
  gr_register_events();
  while(gr_has_event()){
    switch(gr_read()){
      case GR_CLOSE: running = false; break;
      default: break;
    }
  }
  render;
}

void main(){
  "start".writeln;
  
  initialize;
  
  while(running){
    update;
  }
  
}