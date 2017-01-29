module dbg;

import std.stdio;
import vector;
import sgogl;
import sgogl_interface;
import game;
import sllist;

File fileout1, fileout2;

class Vector2f_2_list : LList!Vector2f_2 {}
Vector2f_2_list debug_line_list;

void initialize_debug(){
  fileout1 = File("debug_data1.txt", "w");
  fileout2 = File("debug_data2.txt", "w");
  
  debug_line_list = new Vector2f_2_list;
}

void debug_add_line(Vector2f position, int spot){
  static Vector2f_2 line;
  if(spot == 1)
    line.x = position;
  else {
    line.y = position;
    debug_line_list.add(line);
  }
}

void debug_write_1(T)(T value){
  fileout1.writeln(game_time, " ", value);
}
void debug_write_2(T)(T value){
  fileout2.writeln(game_time, " ", value);
}

void render_debug(){
  foreach(ref Vector2f_2 line; debug_line_list)
    gr_draw_line(line.x, line.y, 1.0f);
}

// Idea taken from dmd language docs
void write_location_debug(int line = __LINE__, string mod = __MODULE__, string fun = __PRETTY_FUNCTION__){
  writefln("%d %s %s", line, mod, fun);
}

