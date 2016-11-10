
module sllist;

/++
A very simple linked list library
++/

import std.stdio;

class LList(T) {
  
  /++
  A single element of the llist
  ++/
  class Element {
    Element prev, next;
    T value;
    
    this(T t){ value = t; }
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
    }
    
    void remove(){
      if(valid) {
        list.remove(element);
        valid = false;
      }
    }
  }
  
  Element first, last;
  int length = 0;
  
  this(){}
  this(T[] tlist){
    foreach(T t; tlist) add(t);
  }
  
  int opApply(scope int delegate(ref T) dg){
    int result = 0;
    Element cel = first;
    while(cel !is null){
      result = dg(cel.value);
      if(result) break;
    }
    return result;
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
    if(first is null)
      return add_first(t);
    // Nonempty
    else {
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
    a.next = b;
    b.prev = a;
  }
  
  void remove(Element element){
    if(element is last){
      last = element.prev;
      if(element.prev !is null)
        element.prev.next = element.next;
    }
    else if(element is first){
      first = element.next;
      if(element.next !is null)
        element.next.prev = element.prev;
    }
    length--;
    object.destroy(element);
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
  assert( sum == 18 );
}