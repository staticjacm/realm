
module refable;
import std.stdio;

/++
  A class which can be used for guaranteed accurate validity checks on objects
  
  Refable has a reference count which Ref!T increases and decreases
  Refable.destroy can only use object.destroy if its count is 0
  Ref!T automatically destroys object if it is no longer valid
++/
class Refable {
  uint ref_count = 0;
  bool valid = true;
  
  void destroy(){
    valid = false;
    if(ref_count == 0)
      object.destroy(this);
  }
}

struct Ref(T) {
  T object;
  alias object this;
  
  this(T _object){
    this = _object;
  }
  ~this(){
    unassign;
  }
  
  void opAssign(T _object){
    unassign;
    if(_object !is null && _object.valid){
      object = _object;
      object.ref_count++;
    }
  }
  
  void unassign(){
    if(object !is null){
      object.ref_count--;
      object.destroy;
    }
    object = null;
  }
  
  bool valid(){
    return object !is null && object.valid;
  }
  
  T get(){
    return object;
  }
}

unittest {
  class A : Refable {
    int plus1(int x){ return x+1; }
  }
  A aobj   = new A;
  Ref!A ar = aobj;
  assert(ar.valid);
  aobj.destroy; aobj = null;
  assert(!ar.valid);
  assert(ar.get.ref_count == 1);
}

unittest {
  class A : Refable {
    int x;
    void xp1(){ writeln("xp1 ", x+1); }
  }
  Ref!A ar;
  A a1 = new A;
  A a2 = new A;
  a2.x=10;
  ar=a1;
  ar.xp1;
  ar=a2;
  ar.xp1;
}