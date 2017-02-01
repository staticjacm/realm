module sgogl_interface;

import std.stdio;
import std.math;
import vector;
import sgogl;

/*
  Draw a vertex-centered rectangle at position p with side lengths given by s
*/
void screen_draw_vrect(Vector2f p, Vector2f s, float z){
  sgogl.gr_screen_draw_line(p.x      , p.y      , p.x + s.x, p.y      , z);
  sgogl.gr_screen_draw_line(p.x + s.x, p.y      , p.x + s.x, p.y + s.y, z);
  sgogl.gr_screen_draw_line(p.x + s.x, p.y + s.y, p.x      , p.y + s.y, z);
  sgogl.gr_screen_draw_line(p.x      , p.y + s.y, p.x      , p.y      , z);
}
void screen_draw_vrect(float px, float py, float sx, float sy, float z){
  sgogl.gr_screen_draw_line(px     , py     , px + sx, py     , z);
  sgogl.gr_screen_draw_line(px + sx, py     , px + sx, py + sy, z);
  sgogl.gr_screen_draw_line(px + sx, py + sy, px     , py + sy, z);
  sgogl.gr_screen_draw_line(px     , py + sy, px     , py     , z);
}

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

void gr_set_attenuation(int channel, Vector2f pdif, float max_distance){
  sgogl.gr_set_attenuation(channel, cast(int)(255.0f*pdif.norm/max_distance));
}

void set_audio_panning_and_attenuation(uint channel, Vector2f pdif, float max_distance){
  gr_set_attenuation(channel, pdif, max_distance);
  // 255/2*(2/Pi ArcTan[x] + 1)
  gr_set_panning(channel, cast(int)(127*(2/PI*atan(-pdif.x) + 1)));
}