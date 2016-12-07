import std.stdio;
import std.string;
import timer;
import game;

Timer test_timer;

void main(){
  "start".writeln;
  
  initialize;
  
  while(running){
    update;
  }
  
  quit;
  
}