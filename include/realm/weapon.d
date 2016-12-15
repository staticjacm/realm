module weapon;

import item;

class Weapon : Item {
  this(){
    super();
  }
  
  override int item_subtype_id(){ return Item.subtype_weapon; }
}