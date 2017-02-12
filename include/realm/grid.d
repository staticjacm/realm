module grid;

/*
  Contains types which hold data reference-able by Vector2!V's
  
  Note: these are suppose to hold reference types so T in each of these
  is assumed to be nullable ie: T x; assert(__traits(compiles, x = null));
*/

import core.memory;
import std.conv;
import std.stdio;
import std.math;
import std.traits;
import vector;
import validatable;

void write_location_debug(int line = __LINE__, string mod = __MODULE__, string fun = __PRETTY_FUNCTION__){
  writefln("%d %s %s", line, mod, fun);
}

abstract class Grid2(T, V) : Validatable {  
  this(){ super(); }
  
  T* get(Vector2!V);
  int opApply(scope int delegate(ref T));
  void set(T, Vector2!V);
  void remove(Vector2!V);
  bool exists(Vector2!V);
  int length();
}

/*
  A Grid2 type which uses a hash based dictionary to store values
  Use this for worlds which are small / spread out and are highly mutable
*/
class Dict_grid2(T, V) : Grid2!(T, V) {
  T[Vector2!V] dictionary;
  
  override T* get(Vector2!V vector){
    // This returns null if it doesn't exist
    return (vector in dictionary);
  }
  
  override int opApply(scope int delegate(ref T) dg){
    int result = 0;
    foreach(T value; dictionary){
      result = dg(value);
      if(result)
        break;
    }
    return result;
  }
  
  override void set(T value, Vector2!V vector){
    dictionary[vector] = value;
  }
  
  override void remove(Vector2!V vector){
    dictionary.remove(vector);
  }
  
  override bool exists(Vector2!V vector){
    return (get(vector) !is null);
  }
  
  override int length(){
    return dictionary.length;
  }
}

unittest {
  alias intv = Vector2!int;
  alias intgrid = Dict_grid2!(int, int);
  intgrid a = new intgrid;
  a.set(0, intv(0, 0));
  a.set(1, intv(1, 0));
  a.set(2, intv(0, 1));
  assert(*(a.get(intv(0, 0))) == 0);
  assert(*(a.get(intv(1, 0))) == 1);
  assert(*(a.get(intv(0, 1))) == 2);
  a.remove(intv(1, 0));
  assert(a.get(intv(1, 0)) is null);
  assert(!a.exists(intv(1, 0)));
  assert(a.exists(intv(0, 0)));
}

/*
  A Grid2 type which uses an array of arrays to store values
  Use this for worlds which are big and immutable
  
  Untested!
*/
class Array_grid2(T, V): Grid2!(T, V) {
  
  struct Element {
    bool has_value = false;
    T value;
  }
  
  int width = 1, height = 1;
  int position_x = 0, position_y = 0; // horizontal and vertical offsets for the bottom left corner of the grid in the world
  alias Matrix_type = Element[][];
  Matrix_type matrix;
  
  this(){
    resize(width, height);
    super();
  }
  
  void set_position(int x, int y){
    position_x = x;
    position_y = y;
  }
  
  void resize(int width_, int height_){
    width = width_;
    height = height_;
    matrix.length = width;
    for(int x = 0; x < width; x++)
      matrix[x].length = height;
  }
  
  /*
    Resizes and moves matrix to encompass the point (x, y) in world space
    handles all copying of data and adjusting bounds, sizes
  */
  void extend_to_encompass(int x, int y){
    int new_position_x = position_x, new_position_y = position_y;
    int new_width = width, new_height = height;
    bool copy_to_new_matrix = false;
    // moving horizontal bounds
    if(x < position_x){
      new_position_x = x;
      new_width = (position_x + width) - new_position_x;
      copy_to_new_matrix = true;
    }
    else if(position_x + width - 1 < x){
      new_width = x + 1 - position_x;
      copy_to_new_matrix = true;
    }
    // moving vertical bounds
    if(y < position_y){
      new_position_y = y;
      new_height = (position_y + height) - new_position_y;
      copy_to_new_matrix = true;
    }
    else if(position_y + height - 1 < y){
      new_height = y + 1 - position_y;
      copy_to_new_matrix = true;
    }
    // copying data
    if(copy_to_new_matrix){
      Matrix_type new_matrix;
      new_matrix.length = new_width;
      for(int ix = 0; ix < new_width; ix++)
        new_matrix[ix].length = new_height;
      //int old_ix0 = position_x - new_position_x;
      //int old_ixw = old_ix + width;
      //int old_iy0 = position_y - new_position_y;
      //int old_iyh = old_iy + height;
      for(int ix = 0; ix < width; ix++){
        for(int iy = 0; iy < height; iy++){
          int new_ix = position_x - new_position_x + ix;
          int new_iy = position_y - new_position_y + iy;
          // writefln("  [%d][%d] = [%d][%d] (%d)", new_ix, new_iy, ix, iy, matrix[ix][iy]);
          new_matrix[new_ix][new_iy] = matrix[ix][iy];
        }
      }
      
      matrix = new_matrix;
      position_x = new_position_x;
      position_y = new_position_y;
      width = new_width;
      height = new_height;
    }
  }
  
  // Adjust size to minimize area with !.has_value elements
  void contract(){}
  
  override T* get(Vector2!V vector){
    int x = cast(int)(vector.x) - position_x;
    int y = cast(int)(vector.y) - position_y;
    if( (0 <= x) && (0 <= y) && (x < width) && (y < height) ){
      if(matrix[x][y].has_value)
        return &(matrix[x][y].value);
      else
        return null;
    }
    else
      return null;
  }
  
  override int opApply(scope int delegate(ref T) dg){
    int ret = 0;
    for(int x = 0; x < width; x++){
      for(int y = 0; y < height; y++){
        Element el = matrix[x][y];        
        if(el.has_value){
          ret = dg(el.value);
          if(ret)
            return ret;
        }
      }
    }
    return ret;
  }
  
  override void set(T value, Vector2!V vector){
    int vx = cast(int)vector.x;
    int vy = cast(int)vector.y;
    extend_to_encompass(vx, vy);
    int xi = vx - position_x;
    int yi = vy - position_y;
    // writefln("set matrix[%d][%d] size ((%d, %d), (%d, %d))", xi, yi, 0, width, 0, height);
    matrix[xi][yi].value = value;
    matrix[xi][yi].has_value = true;
  }
  
  override void remove(Vector2!V vector){
    int x = cast(int)vector.x - position_x;
    int y = cast(int)vector.y - position_y;
    if( (0 <= x) && (0 <= y) && (x < width) && (y < height) ){
      matrix[x][y].value = T.init;
      matrix[x][y].has_value = false;
    }
  }
  
  override bool exists(Vector2!V vector){
    int x = cast(int)vector.x - position_x;
    int y = cast(int)vector.y - position_y;
    if( (0 <= x) && (0 <= y) && (x < width) && (y < height) )
      return matrix[x][y].has_value;
    return false;
  }
  
  override int length(){
    return width * height;
  }
  
}

unittest {
  class A {int id; this(int id_){id = id_;}}
  Array_grid2!(A, int) grid = new Array_grid2!(A, int);
  grid.set(new A(3), Vector2i(0, 0));
  A* a1p = grid.get(Vector2i(0, 0));
  assert(a1p !is null && (*a1p).id == 3);
  assert(grid.exists(Vector2i(0, 0)));
  assert(!grid.exists(Vector2i(1, 0)));
  grid.set(new A(111), Vector2i(100, 100));
  a1p = grid.get(Vector2i(100, 100));
  assert(a1p !is null && (*a1p).id == 111);
  assert(grid.width == 101);
  assert(grid.height == 101);
  assert(grid.exists(Vector2i(100, 100)));
  assert(!grid.exists(Vector2i(50, 50)));
  assert(!grid.exists(Vector2i(101, 101)));
  assert(!grid.exists(Vector2i(-1, 0)));
}


/*
  A Grid2f hybrid dictionary-array type
  A compromise between dict_grid2 and array_grid2
  Uses an associative array to store 2d grids of uniform dimensions
  
  Untested!
*/
class Dict_array_grid2(T, V, int width, int height) : Grid2!(T, V) {
  
  static const(float) widthf  = cast(float)width;
  static const(float) heightf = cast(float)height;
  
  static if(is(V == int))
    V floor(V x){ return x; }
  
  struct Element {
    bool has_value = false;
    T value;
  }
  
  alias Internal_grid = Element[width][height];
  Internal_grid[Vector2!V] dictionary;
  
  // Internal_grid* get_internal_grid(Vector2!V vector){
  //   return (Vector2!V(floor(vector.x / width) * width, floor(vector.y / height) * height) in dictionary);
  // }
  
  Vector2!V get_block_vector(Vector2!V vector){
    // return Vector2!V(
      // cast(V)floor(vector.x / width)  * width, 
      // cast(V)floor(vector.y / height) * height
    // );
    return Vector2!V(
      cast(V)(std.math.floor(cast(float)vector.x / widthf ) * widthf ), 
      cast(V)(std.math.floor(cast(float)vector.y / heightf) * heightf)
    );
  }
  
  override T* get(Vector2!V vector){
    // This returns null if it doesn't exist
    Vector2!V block_vector = get_block_vector(vector);
    Internal_grid* grid = (block_vector in dictionary);
    if(grid !is null){
      int inx = cast(int)floor(vector.x - block_vector.x);
      int iny = cast(int)floor(vector.y - block_vector.y);
      if((*grid)[inx][iny].has_value)
        return &((*grid)[inx][iny].value);
      else
        return null;
    }
    else
      return null;
  }
  
  override int opApply(scope int delegate(ref T) dg){
    int ret = 0;
    foreach(Internal_grid grid; dictionary){
      for(int x = 0; x < width; x++){
        for(int y = 0; y < height; y++){
          if(grid[x][y].has_value){
            ret = dg(grid[x][y].value);
            if(ret)
              return ret;
          }
        }
      }
    }
    return ret;
  }
  
  override void set(T value, Vector2!V vector){
    Vector2!V block_vector = get_block_vector(vector);
    Internal_grid* grid = (block_vector in dictionary);
    if(grid !is null){
      int inx = cast(int)floor(vector.x - block_vector.x);
      int iny = cast(int)floor(vector.y - block_vector.y);
      (*grid)[inx][iny].has_value = true;
      (*grid)[inx][iny].value = value;
    }
    else {
      Internal_grid new_grid;
      int inx = cast(int)floor(vector.x - block_vector.x);
      int iny = cast(int)floor(vector.y - block_vector.y);
      // writefln("(%s, %s, %s, %s) [%d, %d] v [%d, %d]", to!string(vector.x), to!string(vector.y), to!string(block_vector.x), to!string(block_vector.y), inx, iny, width, height);
      new_grid[inx][iny].has_value = true;
      new_grid[inx][iny].value = value;
      dictionary[block_vector] = new_grid;
    }
  }
  
  override void remove(Vector2!V vector){
    Vector2!V block_vector = get_block_vector(vector);
    Internal_grid* grid = (block_vector in dictionary);
    if(grid !is null){
      int inx = cast(int)floor(vector.x - block_vector.x);
      int iny = cast(int)floor(vector.y - block_vector.y);
      (*grid)[inx][iny].has_value = false;
      (*grid)[inx][iny].value = T.init;
    }
  }
  
  override bool exists(Vector2!V vector){
    Vector2!V block_vector = get_block_vector(vector);
    Internal_grid* grid = (block_vector in dictionary);
    if(grid !is null){
      int inx = cast(int)floor(vector.x - block_vector.x);
      int iny = cast(int)floor(vector.y - block_vector.y);
      // writefln("(%d, %d) in block (%d, %d) -> [%d, %d] in [[%d, %d]]", vector.x, vector.y, block_vector.x, block_vector.y, inx, iny, width, height);
      return (*grid)[inx][iny].has_value;
    }
    else {
      return false;
    }
  }
  
  override int length(){
    return dictionary.length;
  }
}

unittest {
  class A {int id; this(int id_){id = id_;}}
  Dict_array_grid2!(A, int, 10, 10) grid = new Dict_array_grid2!(A, int, 10, 10);
  grid.set(new A(3), Vector2i(0, 0));
  A* a1p = grid.get(Vector2i(0, 0));
  assert(a1p !is null && (*a1p).id == 3);
  assert(grid.exists(Vector2i(0, 0)));
  assert(!grid.exists(Vector2i(1, 0)));
  grid.set(new A(111), Vector2i(55, 55));
  a1p = grid.get(Vector2i(55, 55));
  assert(a1p !is null && (*a1p).id == 111);
  assert(grid.exists(Vector2i(55, 55)));
  assert(!grid.exists(Vector2i(50, 50)));
  assert(!grid.exists(Vector2i(101, 101)));
  assert(!grid.exists(Vector2i(-1, 0)));
}