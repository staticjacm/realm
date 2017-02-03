module item;

import entity;
import validatable;
import animation;

class Item : Validatable {
  
  static enum {
    subtype_item,
    subtype_weapon,
    subtype_armor,
    subtype_accessory,
    subtype_token
  }
  
  Animation animation;
  float tier = 0;
  
  this(){
    super();
  }
  
  string name(){ return "item"; }
  string description(){ return "An undefined item"; }
  string standard_article(){ return "an"; }
  
  void use(Entity entity){}
  
  int item_subtype_id(){ return subtype_item; }
  
}