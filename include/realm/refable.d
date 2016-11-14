
module refable;

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