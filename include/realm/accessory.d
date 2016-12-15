module accessory;

import item;

class Accessory : Item {
  
  this(){
    super();
  }
  
  override int item_subtype_id(){ return Item.subtype_accessory; }
}