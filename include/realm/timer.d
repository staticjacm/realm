
module timer;

import std.stdio;
import core.time;

struct Timer {
  MonoTime start_time;
  
  void start(){ start_time = MonoTime.currTime; }
  
  long secs(){ return (MonoTime.currTime - start_time).total!"seconds"; }
  long msecs(){ return (MonoTime.currTime - start_time).total!"msecs"; }
  long hnsecs(){ return (MonoTime.currTime - start_time).total!"hnsecs"; }
  
  float msecsf(){ return secs.msecs_to_secs; }
  float hnsecsf(){ return hnsecs.hnsecs_to_secs; }
  
  void report(string s){
    writefln("%s %f", s, hnsecsf*1_000.0);
  }
}

float msecs_to_secs(long msecs){ return (cast(float)msecs)/1_000.0f;}
float hnsecs_to_secs(long hnsecs){ return (cast(float)hnsecs)/10_000_000f;}