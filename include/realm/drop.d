module drop;

import agent;
import item;

class Drop : Agent {
  Item[] items;
  
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
  
  void add_item(Item item){
    for(int i = 0; i < items.length; i++){
      if(items[i] !is null){
        items[i] = item;
        break;
      }
    }
  }
  
  override int agent_subtype_id(){ return Agent.subtype_drop; }
  
}