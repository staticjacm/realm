
module validatable;
import std.stdio;

/++
  A class which contains a single stupid variable which should be true when valid and false when invalid
++/
class Validatable {
  bool valid = false;
  this(){
    valid = true;
  }
}

unittest {
  class A : Validatable {
    int x;
  }
  A a = new A;
  destroy(a);
  assert(!a.valid);
}