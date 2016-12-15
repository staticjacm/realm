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
        if(item.valid)
          destroy(item);
  }
  
  override int agent_subtype_id(){ return Agent.subtype_drop; }
  
}