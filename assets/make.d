module make;

/*
  This is a ease of use module which allows creation of an instance
  of any class without importing the corresponding module to that class
  (except for here; the module needs to be import here)
  
  There should also be (eventually) functions which can create any class at runtime
*/

import std.stdio;

import item;
import accessory;
import armor;
import weapon;
import agent;
import entity;
import structured_entity;
import drop;
import portal;
import shot;
import decoration;
import ground;
import wall;
import world;

// accessories
import dev_ring;
import ring_of_defence;
import ring_of_speed;

// armors
import shirt;

// weapons
import fire_staff;

// agents
import brazier;
import token_generator;
import fire_turret;

// drops
import drop_tiers;

// entities
import commoner;
import free_soul;

// portals
import character_generator_portal;
import kernel_portal;

// shots
import fireball;
import rocket;

// structured entities
import commoner;

// decorations
import twinkle;

// grounds
import brick_path;
import makeshift_brick_path;
import blue_carpet;
import portal_carpet;
import red_carpet;
import checkered_floor;
import dead_dirt;
import dirt;
import grass;
import marble_floor;
import fountain_wall;
import sand;
import stone_ground;
import fountain_water;
import rocky_ground;

// walls
import blank_impassable_wall;
import cactus;
import kernel_house_short;
import kernel_house_tall;
import marble_column;
import marble_wall;
import stability_boundary;
import dead_stone_wall;
import stone_wall;
import white_fence;

// worlds
import testing_world;
import kernel;
// import island_world;
import entry_world;
import dead_world;

pragma(inline){
  void initialize_type(string type)(){ mixin(type ~ ".initialize_type;"); }
  auto make_type(string type)(){ mixin("return new " ~ type ~ ";"); }
  
  // Items
  Item make_item(string type)(){ mixin("return new " ~ type ~ ";"); }
  Accessory make_accessory(string type)(){ mixin("return new " ~ type ~ ";"); }
  Armor make_armor(string type)(){ mixin("return new " ~ type ~ ";"); }
  Weapon make_weapon(string type)(){ mixin("return new " ~ type ~ ";"); }
  
  // Agents
  Agent make_agent(string type)(){ mixin("return new " ~ type ~ ";"); }
  Drop make_drop(string type)(){ mixin("return new " ~ type ~ ";"); }
  Entity make_entity(string type)(){ mixin("return new " ~ type ~ ";"); }
  Portal make_portal(string type)(){ mixin("return new " ~ type ~ ";"); }
  Shot make_shot(string type)(){ mixin("return new " ~ type ~ ";"); }
  Structured_entity make_structured_entity(string type)(){ mixin("return new " ~ type ~ ";"); }
  
  // Decoration
  Decoration make_decoration(string type)(){ mixin("return new " ~ type ~ ";"); }
  
  // Rooted
  Ground make_ground(string type)(){ mixin("return new " ~ type ~ ";"); }
  Wall make_wall(string type)(){ mixin("return new " ~ type ~ ";"); }
  
  // World
  World make_world(string type)(){ mixin("return new " ~ type ~ ";"); }
}


