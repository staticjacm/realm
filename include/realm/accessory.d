module accessory;

import item;
import entity;
import structured_entity;
import shot;
import wall;
import ground;

/*
  An item that is for usually passive stat bonuses or effects which are outside the direct control of the entity
  This is one of the three types of items that Structured_entities can equip
  It is only useful when it is equipped, so it is only useful for structured entities
  Examples: rings, non-armor clothing, etc
*/
class Accessory : Item {
  
  override string name(){ return "accessory"; }
  override string description(){ return "An undefined accessory"; }
  override string standard_article(){ return "an"; }
  
  // This modifies incoming damage when equipped by a structured entity
  float modify_damage(float damage){ return damage; }
  
  // These are called when a structured entity equips or dequips it respectively
  void equipped(Structured_entity entity){}
  void dequipped(Structured_entity entity){}
  
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