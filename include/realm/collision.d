module collision;

import std.stdio;
import std.math;
import timer;
import dbg;
import vector;

Timer test_timer;

/*
  Check for a collision between two centered rectangles
    
  Returns a Vector2f_2 object pointer if there was a collision
  The x member is the vertex that triggered the collision detection and the y member is the collision normal
  Returns null if there was no collision
  
  A collision is detected if one of the four points in one of the rectangles is detected inside the other rectangle
  A point is determined to be inside a rectangle if the point's coordinates projected onto arbitrary axes in the
  rectangle are between 0 and the rectangles side lengths (px in [0, rx], py in [0, ry] for a rectangle with side
  lengths rx and ry)
  The surface normal is estimated by finding the approximate quadrant the internal point found above is inside of
  the containing rectangle. 
*/
Vector2f_2* test_for_collision_crect_crect(Vector2f apos, float arx, float ary, float aang, Vector2f bpos, float brx, float bry, float bang){
  float a_cos = cos(aang);
  float a_sin = sin(aang);
  Vector2f a1 = apos + Vector2f(- arx * a_cos + ary * a_sin, - arx * a_sin - ary * a_cos);
  Vector2f a2 = apos + Vector2f(  arx * a_cos + ary * a_sin,   arx * a_sin - ary * a_cos);
  Vector2f a3 = apos + Vector2f(  arx * a_cos - ary * a_sin,   arx * a_sin + ary * a_cos);
  Vector2f a4 = apos + Vector2f(- arx * a_cos - ary * a_sin, - arx * a_sin + ary * a_cos);
  Vector2f ax = (a2 - a1)/(4.0f*arx*arx);
  Vector2f ay = (a4 - a1)/(4.0f*ary*ary);
  
  float b_cos = cos(bang);
  float b_sin = sin(bang);
  Vector2f b1 = bpos + Vector2f(- brx * b_cos + bry * b_sin, - brx * b_sin - bry * b_cos);
  Vector2f b2 = bpos + Vector2f(  brx * b_cos + bry * b_sin,   brx * b_sin - bry * b_cos);
  Vector2f b3 = bpos + Vector2f(  brx * b_cos - bry * b_sin,   brx * b_sin + bry * b_cos);
  Vector2f b4 = bpos + Vector2f(- brx * b_cos - bry * b_sin, - brx * b_sin + bry * b_cos);
  Vector2f bx = (b2 - b1)/(4.0f*brx*arx);
  Vector2f by = (b4 - b1)/(4.0f*bry*ary);
  
  float px, py; // positions of the test point inside the other rectangle;
  
  // for testing wall quadrants against agent point p
  pragma(inline) Vector2f_2* quadrant_decider_a(ref float px, ref float py, Vector2f p){
    bool s1 = py > px, s2 = py > 1.0f - px;
    if(s1){
      if(s2)
        return new Vector2f_2(p,  ay);
      else
        return new Vector2f_2(p, -ax);
    }
    else {
      if(s2)
        return new Vector2f_2(p,  ax);
      else
        return new Vector2f_2(p, -ay);
    }
  }
  
  // for testing agent quadrants against wall point p
  pragma(inline) Vector2f_2* quadrant_decider_b(ref float px, ref float py, ref Vector2f p){
    // bool s1 = py > px*bry/brx, s2 = py > 2.0f*bry - px*bry/brx;        
    bool s1 = py > px, s2 = py > 1.0f - px;        
    if(s1){
      if(s2)
        return new Vector2f_2(p, -by);
      else
        return new Vector2f_2(p,  bx);
    }
    else {
      if(s2)
        return new Vector2f_2(p, -bx);
      else
        return new Vector2f_2(p,  by);
    }
  }
  
  // b point in a
  // b1 inside a
  if( (0 <= (px = ax.dot(b1 - a1))) && (px < 1.0f) && (0 <= (py = ay.dot(b1 - a1))) && (py < 1.0f) )
    return quadrant_decider_a(px, py, b1);
  // b2 inside a
  else if( (0 <= (px = ax.dot(b2 - a1))) && (px < 1.0f) && (0 <= (py = ay.dot(b2 - a1))) && (py < 1.0f) )
    return quadrant_decider_a(px, py, b2);
  // b3 inside a
  else if( (0 <= (px = ax.dot(b3 - a1))) && (px < 1.0f) && (0 <= (py = ay.dot(b3 - a1))) && (py < 1.0f) )
    return quadrant_decider_a(px, py, b3);
  // b4 inside a
  else if( (0 <= (px = ax.dot(b4 - a1))) && (px < 1.0f) && (0 <= (py = ay.dot(b4 - a1))) && (py < 1.0f) )
    return quadrant_decider_a(px, py, b4);
  
  // a point in b
  // a1 inside b
  else if( (0 <= (px = bx.dot(a1 - b1))) && (px < 1.0f) && (0 <= (py = by.dot(a1 - b1))) && (py < 1.0f) )
    return quadrant_decider_b(px, py, a1);
  // a2 inside b
  else if( (0 <= (px = bx.dot(a2 - b1))) && (px < 1.0f) && (0 <= (py = by.dot(a2 - b1))) && (py < 1.0f) )
    return quadrant_decider_b(px, py, a2);
  // a3 inside b
  else if( (0 <= (px = bx.dot(a3 - b1))) && (px < 1.0f) && (0 <= (py = by.dot(a3 - b1))) && (py < 1.0f) )
    return quadrant_decider_b(px, py, a3);
  // a4 inside b
  else if( (0 <= (px = bx.dot(a4 - b1))) && (px < 1.0f) && (0 <= (py = by.dot(a4 - b1))) && (py < 1.0f) )
    return quadrant_decider_b(px, py, a4);
    
  // none of the points are inside the other rectangle -> no collision detected
  else
    return null;
}

/*
  Check for a collision between a 0-dimensional point and a centered rectangle
  Returns an estimated collision normal pointer
  Returns null if there was no collision
*/
Vector2f* test_for_collision_point_crect(Vector2f apos, Vector2f bpos, float brx, float bry, float bang){  
  float b_cos = cos(bang);
  float b_sin = sin(bang);
  Vector2f b1 = bpos + Vector2f(- brx * b_cos + bry * b_sin, - brx * b_sin - bry * b_cos);
  Vector2f b2 = bpos + Vector2f(  brx * b_cos + bry * b_sin,   brx * b_sin - bry * b_cos);
  Vector2f b3 = bpos + Vector2f(  brx * b_cos - bry * b_sin,   brx * b_sin + bry * b_cos);
  Vector2f b4 = bpos + Vector2f(- brx * b_cos - bry * b_sin, - brx * b_sin + bry * b_cos);
  Vector2f bx = (b2 - b1)/(4.0f*brx);
  Vector2f by = (b4 - b1)/(4.0f*bry);
  
  float px, py; // positions of the test point inside the rectangle;
  
  if( (0 <= (px = bx.dot(apos - b1))) && (px < 1.0f) && (0 <= (py = by.dot(apos - b1))) && (py < 1.0f) ){
    bool s1 = py > px, s2 = py > 1.0f - px;        
    if(s1){
      if(s2)
        return new Vector2f(-by.x, -by.y);
      else
        return new Vector2f( bx.x,  bx.y);
    }
    else {
      if(s2)
        return new Vector2f(-bx.x, -bx.y);
      else
        return new Vector2f( by.x,  by.y);
    }
  }
  else
    return null;
}

/*
  Check for a collision between an axis aligned corner-centered square and a centered rectangle
*/
Vector2f_2* test_for_collision_asqr_crect(Vector2f apos, float ar, Vector2f bpos, float brx, float bry, float bang){
  Vector2f a1 = Vector2f(apos.x, apos.y);
  Vector2f a2 = Vector2f(apos.x + ar, apos.y);
  Vector2f a3 = Vector2f(apos.x + ar, apos.y + ar);
  Vector2f a4 = Vector2f(apos.x, apos.y + ar);
  
  Vector2f ax = Vector2f(1.0f, 0.0f);
  Vector2f ay = Vector2f(0.0f, 1.0f);
  
  float b_cos = cos(bang);
  float b_sin = sin(bang);
  Vector2f b1 = bpos + Vector2f(- brx * b_cos + bry * b_sin, - brx * b_sin - bry * b_cos);
  Vector2f b2 = bpos + Vector2f(  brx * b_cos + bry * b_sin,   brx * b_sin - bry * b_cos);
  Vector2f b3 = bpos + Vector2f(  brx * b_cos - bry * b_sin,   brx * b_sin + bry * b_cos);
  Vector2f b4 = bpos + Vector2f(- brx * b_cos - bry * b_sin, - brx * b_sin + bry * b_cos);
  Vector2f bx = (b2 - b1)/(4.0f*brx*brx);
  Vector2f by = (b4 - b1)/(4.0f*bry*bry);
  
  float px, py; // positions of the test point inside the other rectangle;
  
  // for testing wall quadrants against agent point p
  pragma(inline) Vector2f_2* quadrant_decider_a(ref float px, ref float py, Vector2f p){
    bool s1 = py > px, s2 = py > 1.0f - px;
    if(s1){
      if(s2)
        return new Vector2f_2(p,  ay);
      else
        return new Vector2f_2(p, -ax);
    }
    else {
      if(s2)
        return new Vector2f_2(p,  ax);
      else
        return new Vector2f_2(p, -ay);
    }
  }
  
  // for testing agent quadrants against wall point p
  pragma(inline) Vector2f_2* quadrant_decider_b(ref float px, ref float py, ref Vector2f p){
    bool s1 = py > px, s2 = py > 1.0f - px;        
    if(s1){
      if(s2)
        return new Vector2f_2(p, -by);
      else
        return new Vector2f_2(p,  bx);
    }
    else {
      if(s2)
        return new Vector2f_2(p, -bx);
      else
        return new Vector2f_2(p,  by);
    }
  }
  
  // b point in a
  // b1 inside a
  if( (0 <= (px = ax.dot(b1 - a1))) && (px < 1.0f) && (0 <= (py = ay.dot(b1 - a1))) && (py < 1.0f) ){
    return quadrant_decider_a(px, py, b1);
  }
  // b2 inside a
  else if( (0 <= (px = ax.dot(b2 - a1))) && (px < 1.0f) && (0 <= (py = ay.dot(b2 - a1))) && (py < 1.0f) ){
    return quadrant_decider_a(px, py, b2);
  }
  // b3 inside a
  else if( (0 <= (px = ax.dot(b3 - a1))) && (px < 1.0f) && (0 <= (py = ay.dot(b3 - a1))) && (py < 1.0f) ){
    return quadrant_decider_a(px, py, b3);
  }
  // b4 inside a
  else if( (0 <= (px = ax.dot(b4 - a1))) && (px < 1.0f) && (0 <= (py = ay.dot(b4 - a1))) && (py < 1.0f) ){
    return quadrant_decider_a(px, py, b4);
  }
  // a point in b
  // a1 inside b
  else if( (0 <= (px = bx.dot(a1 - b1))) && (px < 1.0f) && (0 <= (py = by.dot(a1 - b1))) && (py < 1.0f) ){
    return quadrant_decider_b(px, py, a1);
  }
  // a2 inside b
  else if( (0 <= (px = bx.dot(a2 - b1))) && (px < 1.0f) && (0 <= (py = by.dot(a2 - b1))) && (py < 1.0f) ){
    return quadrant_decider_b(px, py, a2);
  }
  // a3 inside b
  else if( (0 <= (px = bx.dot(a3 - b1))) && (px < 1.0f) && (0 <= (py = by.dot(a3 - b1))) && (py < 1.0f) ){
    return quadrant_decider_b(px, py, a3);
  }
  // a4 inside b
  else if( (0 <= (px = bx.dot(a4 - b1))) && (px < 1.0f) && (0 <= (py = by.dot(a4 - b1))) && (py < 1.0f) ){
    return quadrant_decider_b(px, py, a4);
  }
    
  // none of the points are inside the other rectangle -> no collision detected
  else
    return null;
}