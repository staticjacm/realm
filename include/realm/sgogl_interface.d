module sgogl_interface;

import vector;
import sgogl;

void gr_view_centered(Vector2f position, float scale, float angle){
  sgogl.gr_view_centered(position.x, position.y, scale, angle);
}

void gr_view_centered(Vector2f position, float scale){
  sgogl.gr_view_centered(position.x, position.y, scale, 0);
}