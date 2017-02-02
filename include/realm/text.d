module text;

import std.stdio;
import std.math;
import sgogl;

/*
  Transforms character code c to an index to be used to get a particular
  gylph subimage in a bitmap font sheet
 */
uint character_to_image_index(string checks = "careful")(char c){
  static if(checks == "careful"){
    uint ret = c - 32;
    if(ret < 0) return 0;
    else if(0x7E < ret) return 0x7E;
    else return ret;
  }
  else static if(checks == "careless"){
    return c - 32;
  }
}

float calculate_string_width(string s, float offset, float sx){
  return cast(float)(s.length) * offset * sx;
}

/*
  Draws a string s to the screen using glyphs from fontimg at (x, y, z) with size (sx, sy)
  fontimg must be a regular rectangular grid of glyphs with numx columns and numy rows of glyphs
  offset is for varying the spacing between characters (its a proportion of sx)
*/
void screen_draw_string(string centering = "")(string s, uint fontimg, int numx, int numy, float offset, float x, float y, float z, float sx, float sy){
  static if(centering == "centered")
    float xacc = x - calculate_string_width(s, offset, sx) / 2;
  else
    float xacc = x;
  float yacc = y;
  immutable(float) gwidth  = 1.0f/cast(float)numx; // individual glyph widths
  immutable(float) gheight = 1.0f/cast(float)numy; // individual glyph heights
  foreach(char c; s){
    if(c == '\n'){
      yacc -= sy;
      xacc  = x;
    }
    else {
      uint index = character_to_image_index(c);
      // writeln("index: ", index);
      int locx = index % numx; // x location
      int locy = index / numx; // y location
      gr_screen_draw_partial(
        fontimg,
        cast(float)locx * gwidth, cast(float)locy * gheight,
        gwidth, gheight,
        xacc, yacc, z, 
        0.5f, 0.0f, 
        0.0f, 
        sx, sy
      );
      xacc += sx * offset;
    }
  }
}

/*
  Draws a string s to the world using glyphs from fontimg at (x, y, z) with size (sx, sy)
  fontimg must be a regular rectangular grid of glyphs with numx columns and numy rows of glyphs
  offset is for varying the spacing between characters (its a proportion of sx)
*/
void draw_string(string centering = "")(string s, uint fontimg, int numx, int numy, float offset, float x, float y, float z, float sx, float sy){
  static if(centering == "centered")
    float xacc = x - calculate_string_width(s, offset, sx) / 2;
  else
    float xacc = x;
  float yacc = y;
  immutable(float) gwidth  = 1.0f/cast(float)numx; // individual glyph widths
  immutable(float) gheight = 1.0f/cast(float)numy; // individual glyph heights
  foreach(char c; s){
    if(c == '\n'){
      yacc -= sy;
      xacc  = x;
    }
    else {
      uint index = character_to_image_index(c);
      // writeln("index: ", index);
      int locx = index % numx; // x location
      int locy = index / numx; // y location
      gr_draw_partial(
        fontimg,
        cast(float)locx * gwidth, cast(float)locy * gheight,
        gwidth, gheight,
        xacc, yacc, z, 
        0.5f, 0.0f, 
        0.0f, 
        sx, sy
      );
      xacc += sx * offset;
    }
  }
}