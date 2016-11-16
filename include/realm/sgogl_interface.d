module sgogl_interface;

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