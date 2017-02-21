module misc;

import std.stdio;
import std.math;
import std.random;

bool contains(T)(T[] list, T y){
  foreach(T x; list){
    if(x == y)
      return true;
  }
  return false;
}

/*
  Look in SLList for the original implementation
  
  Untested!
*/
T[] random_sample(T)(T[] list, int n){
  T[] ret;
  ret.length = n;
  int i = 0;
  int current_n = 0;
  for(int i = 0; i < list.length; i++){
    if( uniform!"[]"(0, 1) < cast(float)(n - current_n + 1)/cast(float)(list.length - i + 1) ){
      ret[current_n] = list[i];
      current_n++;
    }
    i++;
    if(current_n >= n)
      break;
  }
  return ret;
}

/*
  This should really be T* return type but it complicates use
*/
T random_choice(T)(T[] list){
  if(list.length > 0){
    int i = 0;
    for(int i = 0; i < list.length; i++){
      if( uniform!"[]"(0, 1) < 1.0f/cast(float)(list.length - i + 1) )
        return list[i];
    }
    return list[$-1];
  }
  else
    return T.init;
}

/*
  Same as above but uses prob as the probability at each step
*/
T random_choice(T)(T[] list, float delegate(int) prob){
  if(list.length > 0){
    for(int i = 0; i < list.length; i++){
      if( uniform!"[]"(0, 1) < prob(i) )
        return list[i];
    }
    return list[$-1];
  }
  else
    return T.init;
}

/*
  Same as above but prob is constant
*/
T random_choice(T)(T[] list, float prob){
  if(list.length > 0){
    for(int i = 0; i < list.length; i++){
      if( uniform!"[]"(0, 1) < prob )
        return list[i];
    }
    return list[$-1];
  }
  else
    return T.init;
}