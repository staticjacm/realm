import std.stdio;

import sgogl;

import agent;
import vector;
import player;

alias Vector2f = Vector2!float;

Agent test_agent;

Vector2f mouse_world_position = Vector2f(0, 0);
int move_up_button    = GR_W;
int move_left_button  = GR_A;
int move_down_button  = GR_S;
int move_right_button = GR_D;

bool running = true;

extern(C) void close_function(){
  running = false;
}

extern(C) void key_function(int key, int actions, int mods){
  
}

extern(C) void mouse_move_function(double x, double y){
  
}

extern(C) void mouse_button_function(int button, int actions, int mods){
  
}

void initialize(){
  gr_open;
  gr_window_close_function(&close_function);
  gr_key_function(&key_function);
  gr_mouse_move_function(&mouse_move_function);
  gr_mouse_button_function(&mouse_button_function);
  
  test_agent = new Agent(Vector2f(0, 0), 1);
}

void render(){
  gr_clear;
  gr_refresh;
}

void update(){
  gr_poll_events;
  render;
}

void main(){
  "start".writeln;
  
  initialize;
  
  while(running){
    update;
  }
  
}