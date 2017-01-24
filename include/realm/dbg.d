module dbg;

import std.stdio;

// Idea taken from dmd language docs
void write_location_debug(int line = __LINE__, string mod = __MODULE__, string fun = __PRETTY_FUNCTION__){
  writefln("%d %s %s", line, mod, fun);
}

