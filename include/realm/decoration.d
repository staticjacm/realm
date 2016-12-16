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
  static total_number = 0;
  
  Decoration_list.Index area_index;
  long death_time = 0;
  
  this(){
    super();
    total_number++;
    death_time = game_time + lifetime;
  }
  ~this(){
    total_number--;
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