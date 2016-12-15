module item;

import entity;
import validatable;

class Item : Validatable {
  
  static enum {
    subtype_none,
    subtype_weapon,
    subtype_armor,
    subtype_accessory
  }
  
  this(){
    super();
  }
  
  void use(Entity entity){}
  
  int item_subtype_id(){ return subtype_none; }
}