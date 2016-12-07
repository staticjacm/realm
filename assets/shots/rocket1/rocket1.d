module rocket1;

/// This guy should actually be under structured entities, but it doesn't really matter for now

import std.stdio;
import std.math;
import std.string;
import std.random;
import animation;
import vector;
import game;
import wall;
import shot;
import entity;
import sgogl;
import sgogl_interface;
import fireball1;

alias Vector2f = Vector2!float;

class Rocket1 : Shot {
  static uint image_1;
  static bool type_initialized = false;
  
  static initialize_type(){
    if(!type_initialized){
      image_1 = gr_load_image("assets/shots/rocket1/rocket1_1.png".toStringz, 0);
    }
  }
  
  long fire_time;
  long fire_delay = 500;
  bool firing = false;
  float spin = 0;
  
  this(Vector2f _position, float _size){
    super(_position, _size);
    animation = new Animation([image_1], 1, Vector2f(0.5, 0.5), Vector2f(1, 1));
    friction = 0;
    spin = uniform(-15.0, 15.0);
    fire_time = game_time + fire_delay;
  }
  
  override float render_angle(){ return -45.0; }
  
  override void update(){
    super.update;
    if(firing){
      friction = 0;
      Vector2f acceleration_vector = cs2d(angle);
      accelerate(acceleration_vector*50);
      for(int i = 0; i < uniform(0, 2); i++){
        Fireball1 exhaust = new Fireball1(position, 1);
        exhaust.world = world;
        exhaust.set_lifetime = 200;
        exhaust.velocity = -acceleration_vector*10.0;
      }
    }
    else if(fire_time < game_time){
      firing = true;
    }
    angle += spin * frame_delta;
    spin *= 0.99;
  }
  
  void explode(){
    for(int i = 0; i < uniform(5, 10); i++){
      Fireball1 exhaust = new Fireball1(position, 1);
      exhaust.world = world;
      exhaust.velocity = cs2(uniform(-PI, PI));
    }
    destroy;
  }
  
  override void collide(Wall wall){
    super.collide(wall);
    static float explode_angle = PI/2;
    // This is to calculate the angle of collision ( the arccos of the dot product of the normal direction and normal position difference )
    Vector2f p_dif = ((wall.position + Vector2f(.5, .5)) - position).normalize;
    gr_draw_line(position, position + p_dif, 1.0);
    Vector2f direction = cs2d(angle);
    float dprod = p_dif.dot(direction);
    float collision_angle = acos(dprod);
    spin = -200*angle3(direction, p_dif);
    if( firing && abs(collision_angle) < explode_angle || velocity.norm > 100.0)
      explode;
  }
  
  // override void render(){
    // gr_draw_line(position, position + cs2d(angle), 1.0);
    // super.render;
  // }
}