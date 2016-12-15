module armor;

import item;
import agent;
import entity;
import shot;
import wall;
import ground;

class Armor : Item {

  this(){
    super();
  }
  
  override int item_subtype_id(){ return Item.subtype_armor; }
  
  /*
  When a structured entity is wearing an armor item and collides with something, the 
  agent's collide functions are triggered then these functions are triggered:
  */
  void collide(Entity entity){}
  void collide(Shot shot){}
  void collide(Wall wall){}
  void collide(Ground ground){}
}