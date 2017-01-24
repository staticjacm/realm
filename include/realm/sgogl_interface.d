module sgogl_interface;

import std.stdio;
import std.math;
import vector;
import sgogl;

void gr_draw_line(Vector2f v1, Vector2f v2, float z){
  sgogl.gr_draw_line(v1.x, v1.y, v2.x, v2.y, z);
}

void gr_draw_line(Vector2f[] vlist, float z){
  for(int vi = 0; vi < vlist.length - 1; vi++){
    gr_draw_line(vlist[vi], vlist[vi+1], z);
  }
}

void gr_view_centered(Vector2f position, float scale, float angle){
  sgogl.gr_view_centered(position.x, position.y, scale, angle);
}

void gr_view_centered(Vector2f position, float scale){
  sgogl.gr_view_centered(position.x, position.y, scale, 0);
}

/// Is point visible in the current view?
bool point_in_view(Vector2f point, float margin = 1){
  return (gr_view_left - margin <= point.x) && (gr_view_bottom - margin <= point.y) && 
         (point.x <= gr_view_right + margin) && (point.y <= gr_view_top + margin);
}

/*
  Turns utf8 character codes into character image list indexes
  Image lists are layed out just like utf8 but with ! ~= 1 like the following:
    utf8 21 - 2F
      !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  
    utf8 30 - 39
      0  1  2  3  4  5  6  7  8  9  
    utf8 3A - 40
      :  ;  <  =  >  ?  @  
    utf8 41 - 5A
      A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q  R  S  T  U  V  W  X  Y  Z  
    utf8 5F - 60
      [ \ ] ^ _ `  
    utf8 61 - 7A
      a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z  
    utf8 7B - 7E
      {  |  }  ~
  index 0 is the blank character that obviously has no image representation (utf8 space)
 */
uint character_to_image_index(string checks = "careful")(char c){
  static if(checks == "careful"){
    uint ret = c - 20;
    if(ret < 0) return 0;
    else if(0x7E < ret) return 0x7E;
    else return ret;
  }
  else static if(checks == "careless"){
    return c - 20;
  }
}

void draw_string(string s, uint[] cimgs, float x, float y, float z, float sx, float sy){
  float xacc = x;
  foreach(char c; s){
    uint index = character_to_image_index(c);
    if(index > 0){
      writeln("index: ", index);
      gr_screen_draw(cimgs[index], xacc, y, z, 0.5f, 0.0f, 0.0f, sx, sy);
      }
    xacc += sx;
  }
}

void gr_set_attenuation(int channel, Vector2f pdif, float max_distance){
  sgogl.gr_set_attenuation(channel, cast(int)(255.0f*pdif.norm/max_distance));
}

void set_audio_panning_and_attenuation(uint channel, Vector2f pdif, float max_distance){
  gr_set_attenuation(channel, pdif, max_distance);
  // 255/2*(2/Pi ArcTan[x] + 1)
  gr_set_panning(channel, cast(int)(127*(2/PI*atan(-pdif.x) + 1)));
}