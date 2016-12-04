import std.stdio;
import std.string;
import game;


void main(){
  "start".writeln;
  
  initialize;
  
  while(running){
    update;
  }
  
  quit;
  
}