module structured_entity;

import weapon;
import armor;
import accessory;
import item;
import drop;
import entity;

class Structured_entity : Entity {
  
  Weapon weapon;
  Armor armor;
  Accessory accessory;
  Item[] items;
  
  this(){
    super();
    items.length = 8;
  }
  ~this(){
    // drop weapon, armor, accessory and items as drops
    if(world !is null){
      Drop drop = new Drop;
      drop.world = world;
      drop.position = position;
      int itemi = 0;
      if(weapon !is null && weapon.valid){
        drop.items[itemi] = weapon;
        itemi++;
      }
      if(armor !is null && armor.valid){
        drop.items[itemi] = armor;
        itemi++;
      }
      if(accessory !is null && accessory.valid){
        drop.items[itemi] = accessory;
        itemi++;
      }
      bool drop_another = false;
      int drop_another_index = 0;
      for(int i = 0; i < items.length; i++){
        if(itemi >= 8){
          drop_another = true;
          drop_another_index = i;
          itemi = 0;
          break;
        }
        else if(items[i] !is null && items[i].valid){
          drop.items[itemi] = items[i];
          itemi++;
        }
      }
      if(drop_another){
        Drop another_drop = new Drop;
        another_drop.world = world;
        another_drop.position = position;
        for(int i = drop_another_index; i < items.length; i++){
          if(items[i] !is null && items[i].valid){
            drop.items[itemi] = items[i];
            itemi++;
          }
        }
      }
    }
  }
}