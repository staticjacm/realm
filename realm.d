import std.stdio;
import sgogl;

import agent;
import vector;

alias Vector2f = Vector2!float;

Agent test_agent;

bool running = true;
extern(C) void close_function(){
  running = false;
}

void initialize(){
  gr_open;
  gr_window_close_function(&close_function);
  
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