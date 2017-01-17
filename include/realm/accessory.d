module accessory;

import item;
import entity;
import shot;
import wall;
import ground;

class Accessory : Item {
  
  this(){
    super();
  }
  
  float modify_damage(float damage){ return damage; }
  
  /*
  When a structured entity is wearing an accessory item and collides with something, the 
  agent's collide functions are triggered then these functions are triggered:
  */
  void collide(Entity entity){}
  void collide(Shot shot){}
  void collide(Wall wall){}
  void collide(Ground ground){}
  
  override int item_subtype_id(){ return Item.subtype_accessory; }
}