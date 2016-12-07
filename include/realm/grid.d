module grid;

import vector;

abstract class Grid2(T, V) {  
  T* get(Vector2!V);
  int opApply(scope int delegate(ref T));
  void set(T, Vector2!V);
  void remove(Vector2!V);
  bool exists(Vector2!V);
}

/// A Grid2 type which uses a hash based dictionary to store values
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
}

/// A Grid2 type which uses an array of arrays to store values
class Array_grid2(T, V): Grid2!(T, V) {
  
}

// Get/set/remove/exists unittest
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