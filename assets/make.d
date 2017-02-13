module make;

/*
  This is a ease of use module which allows creation of an instance
  of any class without importing the corresponding module to that class
  (except for here; the module needs to be import here)
  
  There should also be (eventually) functions which can create any class at runtime
*/

import std.stdio;
import std.string;

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
import token;

/*
  This constructs a string for all the imports
*/
string asset_registry_modules_import_mixin(){
  string instring = import("asset_registry.txt");
  string[] lines = instring.splitLines;
  string ret = "";
  foreach(string line; lines){
    if(line[0] != '/'){
      string[] words = line.split;
      if(words.length == 2 && words[0] == "module"){
        // import fire_staff;
        ret ~= "import " ~ words[1] ~ ";\n";
      }
    }
  }
  return ret;
}

mixin(asset_registry_modules_import_mixin);

// // // // //
// // // // // Compile time make
// // // // //

pragma(inline, true){
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
  
  // Token
  Token make_token(string type)(){ mixin("return new " ~ type ~ ";"); }
}

// // // // //
// // // // // Run time make
// // // // //

/*
  This constructs a string for make_<super_class> functions to mixin
  It populates all the make_<super_class> function switch statements with the correct class string -> return statement cases
  example:
    make_weapon("Dev_ring_1")  (not make_weapon!"Fire_staff_1" !)
    reduces to switch("Dev_ring_1"){ default: return null; case "Ring_of_defence_1": return Ring_of_defence_1; ... case "Dev_ring_1": return Dev_ring_1; ...}
    which reduces to return Dev_ring_1;
*/
string asset_registry_classes_make_mixin(string super_class)(){
  string instring = import("asset_registry.txt");
  string[] lines = instring.splitLines;
  string ret = "";
  foreach(string line; lines){
    if(line[0] != '/'){
      string[] words = line.split;
      if(words.length == 2 && words[0] == "class"){
        // checks if the class is a subclass of super_class
        // static if(is(Fire_staff_1 : Agent)) {case "Fire_staff_1": return new Fire_staff_1;}
        ret ~= "static if(is(" ~ words[1] ~ ":" ~ super_class ~ ")) { case \"" ~ words[1] ~"\": return new " ~ words[1] ~ ";}\n";
        // ret ~= "static if(is(" ~ words[1] ~ ":" ~ super_class ~ ")) { pragma(msg, \"" ~ words[1] ~" allowed in " ~ super_class ~"\"); case \"" ~ words[1] ~"\": return new " ~ words[1] ~ ";}\n";
      }
    }
  }
  return ret;
}

/*
  This constructs a string for the initialize_type function to mixin
  It populates the initialize_type function switch statements with the correct class string -> initialize statements
  example:
    initialize_type("Dev_ring_1")  (not initialize_type!"Fire_staff_1" !)
    reduces to switch("Dev_ring_1"){ default: return; case "Ring_of_defence_1": Ring_of_defence_1.initialize_type; break; ... case "Dev_ring_1": Dev_ring_1.initialize_type; break; ...}
    which reduces to Dev_ring_1.initialize_type;
*/
string asset_registry_classes_initialize_type_mixin(){
  string instring = import("asset_registry.txt");
  string[] lines = instring.splitLines;
  string ret = "";
  foreach(string line; lines){
    if(line[0] != '/'){
      string[] words = line.split;
      if(words.length == 2 && words[0] == "class"){
        // checks if the class is a subclass of super_class
        ret ~= "case \"" ~ words[1] ~"\": " ~ words[1] ~ ".initialize_type; return;\n";
      }
    }
  }
  return ret;
}

pragma(inline){
  void initialize_type(string class_name){ switch(class_name){ default: return; mixin(asset_registry_classes_initialize_type_mixin); } }
  
  // Items
  Item make_item(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Item"); } }
  Armor make_armor(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Armor"); } }
  Weapon make_weapon(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Weapon"); } }
  Accessory make_accessory(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Accessory"); } }
  
  // Agents
  Agent make_agent(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Agent"); } }
  Entity make_entity(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Entity"); } }
  Structured_entity make_structured_entity(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Structured_entity"); } }
  Shot make_shot(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Shot"); } }
  Portal make_portal(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Portal"); } }
  Drop make_drop(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Drop"); } }
  
  // Decoration
  Decoration make_decoration(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Decoration"); } }
  
  // Rooteds
  Ground make_ground(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Ground"); } }
  Wall make_wall(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Wall"); } }
  
  // World
  World make_world(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"World"); } }
  
  // Token
  Token make_token(string class_name){ switch(class_name){ default: return null; mixin(asset_registry_classes_make_mixin!"Token"); } }
}