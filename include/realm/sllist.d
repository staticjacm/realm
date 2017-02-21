
module sllist;

/++
A very simple linked list library
++/

import std.random;
import std.stdio;
import std.conv;

class LList(T) {
  
  /++
  A single element of the llist
  ++/
  class Element {
    Element prev, next;
    T value;
    
    this(T t){ value = t; }
    ~this(){}
    
    override string toString(){
      return "llist_element("~value.to!string~")";
    }
  }
  
  /++
  A location in the llist that acts like a proper index in the list
  ++/
  struct Index {
    bool valid = false;
    LList list;
    Element element;
    
    this(LList list_, Element element_){
      valid = true;
      list = list_;
      element = element_;
      // writeln("+element ", element.value, " in list ", list.id);
    }
    
    void remove(){
      if(valid) {
        // writeln("-element ", element.value, " in list ", list.id);
        list.remove(element);
        valid = false;
      }
    }
    
    T value(){
      return element.value;
    }
  }
  
  Element first, last;
  static int gid = 0; int id = 0;
  int length = 0;
  
  this(){ id = gid++; }
  this(T[] tlist){
    this();
    foreach(T t; tlist) add(t);
  }
  
  ~this(){
    Element cel = first, nel;
    while(cel !is null){
      nel = cel.next;
      remove(cel);
      cel = nel;
    }
  }
  
  override string toString(){
    string ret = "";
    Element cel = first;
    while(cel !is null){
      ret ~= cel.toString;
      if(cel !is last)
        ret ~= "<->";
      cel = cel.next;
    }
    return ret;
  }
  
  int opApply(scope int delegate(ref T) dg){
    int result = 0;
    Element cel = first;
    Element nel; // next element
    while(cel !is null){
      nel = cel.next;
      result = dg(cel.value);
      if(result) break;
      cel = nel;
    }
    return result;
  }
  
  int opApply(scope int delegate(ref Index) dg){
    int result = 0;
    Index cin = Index(this, first);
    Index nin; // next element
    while(cin.element !is null){
      nin.element = cin.element.next;
      result = dg(cin);
      if(result) break;
      cin.element = nin.element;
    }
    return result;
  }
  
  enum {
    ITER_CONTINUE,
    ITER_DELETE,
    ITER_BREAK
  }
  void iterate(scope int delegate(ref T) dg){
    Element nel, cel = first;
    while(cel !is null){
      switch(dg(cel.value)){
        default:
        case ITER_CONTINUE: nel = cel.next;              break;
        case ITER_DELETE:   nel = cel.next; remove(cel); break;
        case ITER_BREAK:    return;
      }
      cel = nel;
    }
  }
  
  T opIndex(Index i){
    return i.element.value;
  }
  
  Index add_first(T t){
    first = new Element(t);
    last = first;
    length = 1;
    return Index(this, first);
  }
  
  Index add(T t){
    // Empty
    if(first is null){
      // writeln("first is null");
      return add_first(t);
    }
    // Nonempty
    else {
      // writeln("first isnt null");
      // writeln("first: ", first);
      Element old_last = last;
      last = new Element(t);
      connect(old_last, last);
      length++;
      return Index(this, last);
    }
  }
  
  Index add_front(T t){
    // Empty
    if(first is null)
      return add_first(t);
    // Nonempty
    else {
      Element old_first = first;
      first = new Element(t);
      connect(first, old_first);
      length++;
      return Index(this, first);
    }
  }
  
  void connect(Element a, Element b){
    if(a !is null)
      a.next = b;
    if(b !is null)
      b.prev = a;
  }
  
  void remove(Element element){
    if(element is first)
      first = element.next;
    else if(element is last)
      last = element.prev;
    connect(element.prev, element.next);
    length--;
    element.destroy;
  }
  void remove(Index index){
    index.remove;
  }
  
}

// Add unittest
unittest {
  alias intlist = LList!int;
  intlist a = new intlist;
  a.add(3);
  assert( a.first.value == 3 );
  assert( a.last.value == 3 );
  a.add(11);
  assert( a.last.value == 11 );
  assert( a.first.value == 3 );
  intlist.Index x = a.add(5);
  assert( a[x] == 5 );
  int sum = 0;
  foreach(int i; a){
    sum += i;
  }
  assert( sum == 19 );
}

bool contains(T)(LList!T list, T value){
  foreach(T t; list){
    static if(__traits(compiles, t is value)){
      if(t is value)
        return true;
    }
    else {
      if(t == value)
        return true;
    }
  }
  return false;
}

/*
  Creates a new list of n elements sampled randomly and uniformly only once from list
  I discovered this algorithm heuristically. There is no guarantee that it produces
  a truly uniform sample of a distribution (although my testing on distributions like
  Range[_Integer] (ie {0, 1, ..., N}) indicates that it is uniform or very nearly so)
  Some errors:
    Might be very slightly more likely to give runs of sequential elements
*/
LList!T random_sample(T)(LList!T list, int n){
  LList!T ret = new LList!T;
  int i = 0;
  foreach(T value; list){
    if( uniform!"[]"(0, 1) < cast(float)(n - ret.length + 1)/cast(float)(list.length - i + 1) )
      ret.add(value);
    i++;
    if(ret.length >= n)
      break;
  }
  return ret;
}

unittest {
  LList!int list1 = new LList!int;
  for(int i = 0; i < 10000; i++){
    list1.add(i);
  }
  LList!int list2 = list1.random_sample(100);
  assert(list2.length == 100);
  float mean = 0;
  foreach(int i; list2)
    mean += cast(float)i;
  mean /= cast(float)list2.length;
  assert(abs(mean - 5000.0f) < 1000.0f ) // :^)
}

/*
  This should really be T* return type but it complicates use
*/
T random_choice(T)(LList!T list){
  if(list.length > 0){
    int i = 0;
    foreach(T value; list){
      if( uniform!"[]"(0, 1) < 1.0f/cast(float)(list.length - i + 1) )
        return value;
      i++;
    }
    return list.last.value;
  }
  else
    return T.init;
}

/*
  Same as above but uses prob as the probability at each step
*/
T random_choice(T)(LList!T list, float delegate(int) prob){
  if(list.length > 0){
    int i = 0;
    foreach(T value; list){
      if( uniform!"[]"(0, 1) < prob(i) )
        return value;
      i++;
    }
    return list.last.value;
  }
  else
    return T.init;
}

/*
  Same as above but prob is constant
*/
T random_choice(T)(LList!T list, float prob){
  if(list.length > 0){
    foreach(T value; list){
      if( uniform!"[]"(0, 1) < prob )
        return value;
    }
    return list.last.value;
  }
  else
    return T.init;
}