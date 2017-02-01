module metaobject;

import sllist;
import validatable;
import vector;
import world;

class Metaobject_list : LList!Metaobject {}

/*
  Metaobjects can be used for world generation
*/
class Metaobject : Validatable {
  
  Vector2f position;
  World world;
  Metaobject_list.Index world_index;
  
  this(){
    super();
  }
  ~this(){
    world_index.remove;
  }
  
  string name(){ return "metaobject"; }
  string description(){ return "An undefined metaobject"; }
  string standard_article(){ return "a"; }
  
  // finalize is called when the metaobject should do its thing, may cause the metaobject to be deleted
  void finalize(){}
  
  void update(){}
  
}