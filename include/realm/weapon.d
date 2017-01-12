module weapon;

import item;
import animation;

class Weapon : Item {
  
  // Animation attacking_animation;
  
  this(){
    super();
  }
  
  override int item_subtype_id(){ return Item.subtype_weapon; }
}