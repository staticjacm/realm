module token;

import item;
import entity;
import structured_entity;
import shot;
import wall;
import ground;

/*
  A respawn token
  When the player dies with this in their token spot they will respawn as the entity
  the token represents
*/
class Token : Item {
  
  override string name(){ return "Token"; }
  override string description(){ return "An undefined token"; }
  override string standard_article(){ return "a"; }
  
  Entity make_entity(){ return null; }
  
  override int item_subtype_id(){ return Item.subtype_token; }
}