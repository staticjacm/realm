
module vector;
import std.random;
import std.conv;
import std.stdio;
import std.math;
import std.traits;

alias Vector2f = Vector2!float;

Vector2f rvector(float r){
  return Vector2f(uniform(-r, r), uniform(-r, r));
}

Vector2f cs2(float angle){
  return Vector2f(cos(angle), sin(angle));
}

Vector2f cs2d(float angle){
  return cs2(angle*(PI/180));
}

// Calculates small angles respecting direction (ccw -> position, cw -> negative)
float angle3(Vector2f a, Vector2f b){
  return 2.0*atan((a.y - b.y)/(a.x - b.x));
}

Vector2f rotate_by(Vector2f v, float angle){
  return Vector2f( v.x * cos(angle) - v.y * sin(angle), v.x * sin(angle) + v.y * cos(angle));
}
Vector2f rotate_perpendicular(Vector2f v){
  return Vector2f(v.x, -v.y);
}

/++
An arbitrary 2-Tuple of values of type T
++/
struct Vector2(T) {
  T x; T y;
  
  string toString(){ return "("~x.to!string~", "~y.to!string~")"; }
  
  static if(isNumeric!T){
    Vector2!T opBinary(string op)(T scalar){
      static if(op == "*"){
        return Vector2!T(x * scalar, y * scalar);
      }
      else static if(op == "/"){
        return Vector2!T(x / scalar, y / scalar);
      }
    }
    
    Vector2!T opOpAssign(string op)(T scalar){
      return this = this.opBinary!op(scalar);
    }
    
    Vector2!T opBinary(string op)(Vector2!T other){
      static if(op == "+"){
        return Vector2!T(x + other.x, y + other.y);
      }
      else static if(op == "-"){
        return Vector2!T(x - other.x, y - other.y);
      }
    }
    Vector2!T opOpAssign(string op)(Vector2!T other){
      return this = this.opBinary!op(other);
    }
    
    Vector2!T opUnary(string op : "-")(){
      return Vector2!T(-x, -y);
    }
  
    T dot(Vector2!T other){ return x*other.x + y*other.y; }
    static if(isFloatingPoint!T){
      T norm(){ return sqrt(this.dot(this)); }
      Vector2!T normalize(){
        float r = this.norm;
        if(r == 0) r = 1;
        return this/r; 
      }
      float angle(){ return atan2(y, x); }
      float angled(){ return atan2(y, x)*(180/PI); }
      Vector2!T reflect(Vector2!T other){
        return this - other*(dot(other)/other.dot(other))*2;
      }
    }
  }
}

Vector2!T floor(T)(Vector2!T vector){
  return Vector2!T(std.math.floor(vector.x), std.math.floor(vector.y));
}

// opBinary!"*"(T) Scalar multiplication unittest
unittest {
  alias Vector2f = Vector2!float;
  Vector2f a = Vector2f(5.0f, 7.0f);
  Vector2f b = a*12.0f;
  assert( b.x == 60.0f );
  assert( b.y == 84.0f );
  b = b/6;
  assert( b.x == 10.0f );
  assert( b.y == 14.0f );
  a *= 12.0f;
  assert( a.x == 60.0f );
  assert( a.y == 84.0f );
}

// opBinary!op(Vector2!T) Vector Addition/Subtraction unittest
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
  a += b;
  assert( a.x == 7.0f );
  assert( a.y == 10.0f );
}

// opUnary!"-"(Vector2!T) Vector inversion unittest
unittest {
  alias Vector2f = Vector2!float;
  Vector2f a = Vector2f(5.0f, 7.0f);
  Vector2f c = -a;
  assert( c.x == -5.0f );
  assert( c.y == -7.0f );
}

// dot, norm, normalize unittests
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

// floor unittest
unittest {
  alias Vector2f = Vector2!float;
  Vector2f a = Vector2f(3.567f, 4.183f);
  a = floor(a);
  assert( a.x == 3.0f );
  assert( a.y == 4.0f );
}

// toString
unittest {
  alias Vector2f = Vector2!int;
  Vector2f a = Vector2f(0, 1);
  assert( a.toString == "(0, 1)");
}


/++
An arbitrary 3-Tuple of values of type T
++/
struct Vector3(T) {
  T x; T y; T z;
  
  string toString(){ return "("~x.to!string~", "~y.to!string~", "~z.to!string~")"; }
  
  static if(isNumeric!T){
    Vector3!T opBinary(string op)(T scalar){
      static if(op == "*"){
        return Vector3!T(x * scalar, y * scalar, z * scalar);
      }
      else static if(op == "/"){
        return Vector3!T(x / scalar, y / scalar, z / scalar);
      }
    }
    
    Vector3!T opOpAssign(string op)(T scalar){
      return this = this.opBinary!op(scalar);
    }
    
    Vector3!T opBinary(string op)(Vector3!T other){
      static if(op == "+"){
        return Vector3!T(x + other.x, y + other.y, z + other.z);
      }
      else static if(op == "-"){
        return Vector3!T(x - other.x, y - other.y, z - other.z);
      }
    }
    
    Vector3!T opOpAssign(string op)(Vector3!T other){
      return this = this.opBinary!op(other);
    }
    
    Vector3!T opUnary(string op : "-")(){
      return Vector3!T(-x, -y, -z);
    }
    
    T dot(Vector3!T other){ return x*other.x + y*other.y + z*other.z; }
    static if(isFloatingPoint!T){
      T norm(){ return sqrt(this.dot(this)); }
      Vector3!T normalize(){ return this/this.norm; }
    }
  }
}

Vector3!T floor(T)(Vector3!T vector){
  return Vector3!T(std.math.floor(vector.x), std.math.floor(vector.y), std.math.floor(vector.z));
}

// opBinary!"*"(T) Scalar multiplication unittest
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
  a *= 12.0f;
  assert( a.x == 60.0f );
  assert( a.y == 84.0f );
  assert( a.z == 132.0f );
}

// opBinary!op(Vector3!T), opOpAssign!op Vector Addition/Subtraction unittest
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
  a += b;
  assert( a.x == 7.0f );
  assert( a.y == 10.0f );
  assert( a.z == 10.0f );
}

// opUnary!"-"(Vector3!T) Vector inversion unittest
unittest {
  alias Vector3f = Vector3!float;
  Vector3f a = Vector3f(5.0f, 7.0f, 11.0f);
  Vector3f c = -a;
  assert( c.x == -5.0f );
  assert( c.y == -7.0f );
  assert( c.z == -11.0f );
}  

// dot, norm, normalize unittests
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

// floor unittest
unittest {
  alias Vector3f = Vector3!float;
  Vector3f a = Vector3f(3.567f, 4.183f, 8.278f);
  a = floor(a);
  assert( a.x == 3.0f );
  assert( a.y == 4.0f );
  assert( a.z == 8.0f );
}

// toString
unittest {
  alias Vector3f = Vector3!int;
  Vector3f a = Vector3f(0, 1, 2);
  assert( a.toString == "(0, 1, 2)");
}