module decoration;

import game;
import renderable;
import sllist;

class Decoration_list : LList!Decoration {}

/*
  Decorations:
    only update when they are rendered (override to update)
    have a maximum lifetime
    cannot interact with anything
*/
class Decoration : Renderable {
  
  Decoration_list.Index area_index;
  long death_time = 0;
  
  this(){
    super();
    death_time = game_time + lifetime;
  }
  ~this(){
    area_index.remove;
  }
  
  long lifetime(){ return 1000;}
  
  override void render(){
    if(death_time < game_time)
      destroy(this);
    else
      super.render;
  }
  
}