import std.stdio;
import sgogl;

bool running = true;
extern(C) void close_function(){
  running = false;
}

void main(){
  "start".writeln;
  
  gr_open;
  gr_window_close_function(&close_function);
  
  while(running){
    gr_clear;
    gr_poll_events;
    gr_refresh;
  }
  
}