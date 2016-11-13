import std.stdio;

import sgogl;
import sgogl_interface;

import testing_world;
import world;
import commoner;
import entity;
import agent;
import vector;
import player;

alias Vector2f = Vector2!float;

Entity test_entity;
World test_world;

bool running = true;
long current_time = 0;

void key_function(){
  player_key_function(current_time, 0.1);
}

void initialize(){
  gr_open;
  gr_activate_linear_filtering(0);
  
  gr_view_centered(Vector2f(0, 0), 10);
  
  Commoner.initialize_type;
  Testing_world.initialize_type;
  test_entity = new Commoner(Vector2f(0.5, 0.5), 1);
  player_entity = test_entity;
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
      case GR_KEY_EVENT: key_function; break;
      default: break;
    }
  }
  test_world.update(current_time, 0.01);
  render;
}

void main(){
  "start".writeln;
  
  initialize;
  
  while(running){
    update;
  }
  
}