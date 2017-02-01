module drop;

import std.stdio;
import agent;
import item;

class Drop : Agent {
  Item[] items;
  int item_number = 0;
  
  this(){
    super();
    items.length = 8;
  }
  ~this(){
    if(items !is null)
      foreach(Item item; items)
        if(item !is null && item.valid)
          destroy(item);
  }
  
  override string name(){ return "drop"; }
  override string description(){ return "An undefined drop"; }
  override string standard_article(){ return "a"; }
  
  void add_item(Item item){
    for(int i = 0; i < items.length; i++){
      if(items[i] is null){
        items[i] = item;
        return;
      }
    }
  }
  
  bool destroy_on_empty(){ return true; }
  
  // Checks if it has an item
  bool has_item(){
    bool item_found = false;
    for(int j = 0; j < items.length; j++){
      if(items[j] !is null){
        item_found = true;
        break;
      }
    }
    return item_found;
  }
  
  void remove_item(int i){
    items[i] = null;
    if(destroy_on_empty && !has_item){
      kill;
      destroy(this);
    }
  }
  
  override int agent_subtype_id(){ return Agent.subtype_drop; }
  
}