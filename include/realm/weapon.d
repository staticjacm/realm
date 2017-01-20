module weapon;

import item;
import structured_entity;
import animation;

class Weapon : Item {
  
  // Animation attacking_animation;
  
  this(){
    super();
  }
  
  void equipped(Structured_entity entity){}
  void dequipped(Structured_entity entity){}
  
  override int item_subtype_id(){ return Item.subtype_weapon; }
}