
module refable;

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
  
  this(T _object){
    this = _object;
  }
  ~this(){
    unassign;
  }
  
  void unassign(){
    if(object !is null){
      if(object.valid)
        object.ref_count--;
      else
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
  
  void opAssign(T _object){
    unassign;
    if(_object !is null && _object.valid){
      object = _object;
      object.ref_count++;
    }
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