module commoner;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.string;
import animation;
import vector;
import entity;
import sgogl;

alias Vector2f = Vector2!float;

class Commoner : Entity {
  static string directory = "/assets/characters/commoner/";
  static uint image_standing, image_walking_1, image_walking_2, image_hurt;
  static  Vector2f image_dimensions;
  
  static this(){
    image_dimensions = Vector2f(1, 1);
    image_standing  = gr_load_image((directory ~ "standing.png").toStringz, 0);
    image_walking_1 = gr_load_image((directory ~ "walking_1.png").toStringz, 0);
    image_walking_2 = gr_load_image((directory ~ "walking_2.png").toStringz, 0);
    image_hurt      = gr_load_image((directory ~ "hurt.png").toStringz, 0);
  }
  
  Animation animation_standing, animation_walking, animation_hurt;
  
  this(Vector2f _position, float _size){
    super(_position, _size);
    animation_standing = new Animation([image_standing], 1, Vector2f(0.5, 0), image_dimensions);
    animation_walking  = new Animation([image_walking_1, image_walking_2], 2, Vector2f(0.5, 0), image_dimensions);
    animation_hurt     = new Animation([image_hurt], 1, Vector2f(0.5, 0), image_dimensions);
    animation = animation_standing;
  }
  
  override int entity_subtype_id(){ return 1; }
  
}