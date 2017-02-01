module armor;

import item;
import agent;
import entity;
import structured_entity;
import shot;
import wall;
import ground;

class Armor : Item {

  this(){
    super();
  }
  
  override string name(){ return "armor"; }
  override string description(){ return "An undefined piece of armor"; }
  override string standard_article(){ return "an"; }
  
  override int item_subtype_id(){ return Item.subtype_armor; }
  
  float modify_damage(float damage){ return damage; }
  
  void equipped(Structured_entity entity){}
  void dequipped(Structured_entity entity){}
  
  /*
  When a structured entity is wearing an armor item and collides with something, the 
  agent's collide functions are triggered then these functions are triggered:
  */
  void collide(Entity entity){}
  void collide(Shot shot){}
  void collide(Wall wall){}
  void collide(Ground ground){}
}