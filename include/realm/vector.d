
module vector;
import std.math;
import std.stdio;

struct Vector2(T) {
  T x; T y;
  
  Vector2!T opBinary(string op)(T scalar){
    static if(op == "*"){
      return Vector2!T(x * scalar, y * scalar);
    }
    else static if(op == "/"){
      return Vector2!T(x / scalar, y / scalar);
    }
  }
  
  Vector2!T opBinary(string op)(Vector2!T other){
    static if(op == "+"){
      return Vector2!T(x + other.x, y + other.y);
    }
    else static if(op == "-"){
      return Vector2!T(x - other.x, y - other.y);
    }
  }
  
  Vector2!T opUnary(string op : "-")(){
    return Vector2!T(-x, -y);
  }
  
  T dot(Vector2!T other){ return x*other.x + y*other.y; }
  T norm(){ return sqrt(this.dot(this)); }
  Vector2!T normalize(){ return this/this.norm; }
}
  
unittest {
  alias Vector2f = Vector2!float;
  Vector2f a = Vector2f(5.0f, 7.0f);
  Vector2f b = a*12.0f;
  assert( b.x == 60.0f );
  assert( b.y == 84.0f );
  b = b/6;
  assert( b.x == 10.0f );
  assert( b.y == 14.0f );
}
  
unittest {
  alias Vector2f = Vector2!float;
  Vector2f a = Vector2f(5.0f, 7.0f);
  Vector2f b = Vector2f(2.0f, 3.0f);
  Vector2f c = a + b;
  assert( c.x == 7.0f );
  assert( c.y == 10.0f );
  c = a - b;
  assert( c.x == 3.0f );
  assert( c.y == 4.0f );
}

unittest {
  alias Vector2f = Vector2!float;
  Vector2f a = Vector2f(5.0f, 7.0f);
  Vector2f c = -a;
  assert( c.x == -5.0f );
  assert( c.y == -7.0f );
}
  
unittest {
  alias Vector2f = Vector2!float;
  Vector2f a = Vector2f(3.0f, 4.0f);
  Vector2f b = Vector2f(2.0f, 4.0f);
  float c = a.dot(b);
  assert( c == 22.0f );
  c = a.norm;
  assert( c == 5.0f );
  Vector2f d = a.normalize;
  assert( d.x == 0.6f );
  assert( d.y == 0.8f );
}


struct Vector3(T) {
  T x; T y; T z;
  
  
  Vector3!T opBinary(string op)(T scalar){
    static if(op == "*"){
      return Vector3!T(x * scalar, y * scalar, z * scalar);
    }
    else static if(op == "/"){
      return Vector3!T(x / scalar, y / scalar, z / scalar);
    }
  }
  
  Vector3!T opBinary(string op)(Vector3!T other){
    static if(op == "+"){
      return Vector3!T(x + other.x, y + other.y, z + other.z);
    }
    else static if(op == "-"){
      return Vector3!T(x - other.x, y - other.y, z - other.z);
    }
  }
  
  Vector3!T opUnary(string op : "-")(){
    return Vector3!T(-x, -y, -z);
  }
  
  T dot(Vector3!T other){ return x*other.x + y*other.y + z*other.z; }
  T norm(){ return sqrt(this.dot(this)); }
  Vector3!T normalize(){ return this/this.norm; }
}
  
unittest {
  alias Vector3f = Vector3!float;
  Vector3f a = Vector3f(5.0f, 7.0f, 11.0f);
  Vector3f b = a*12.0f;
  assert( b.x == 60.0f );
  assert( b.y == 84.0f );
  assert( b.z == 132.0f );
  b = b/6;
  assert( b.x == 10.0f );
  assert( b.y == 14.0f );
  assert( b.z == 22.0f );
}
  
unittest {
  alias Vector3f = Vector3!float;
  Vector3f a = Vector3f(5.0f, 7.0f, 1.0f);
  Vector3f b = Vector3f(2.0f, 3.0f, 9.0f);
  Vector3f c = a + b;
  assert( c.x == 7.0f );
  assert( c.y == 10.0f );
  assert( c.z == 10.0f );
  c = a - b;
  assert( c.x == 3.0f );
  assert( c.y == 4.0f );
  assert( c.z == -8.0f );
}
  
unittest {
  alias Vector3f = Vector3!float;
  Vector3f a = Vector3f(5.0f, 7.0f, 11.0f);
  Vector3f c = -a;
  assert( c.x == -5.0f );
  assert( c.y == -7.0f );
  assert( c.z == -11.0f );
}  

unittest {
  alias Vector3f = Vector3!float;
  Vector3f a = Vector3f(1.0f, 2.0f, 2.0f);
  Vector3f b = Vector3f(2.0f, 4.0f, 3.0f);
  float c = a.dot(b);
  assert( c == 16.0f );
  c = a.norm;
  assert( c == 3.0f );
  Vector3f d = a.normalize;
  assert( d.x == 1.0f/3.0f );
  assert( d.y == 2.0f/3.0f );
  assert( d.z == 2.0f/3.0f );
}