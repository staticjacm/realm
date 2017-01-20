module turret;

import std.string;
import vector;
import game;
import animation;
import fireball1;
import agent;
import sgogl;

class Fire_turret_1 : Agent {
  static bool type_initialized = false;
  static uint deactivated_image, activated_image_1, activated_image_2;
  
  static void initialize_type(){
    if(!type_initialized){
      type_initialized = true;
      Fireball1.initialize_type;
      deactivated_image = gr_load_image("assets/agents/turret/fire_turret_1_deactivated_1.png".toStringz, 0);
      activated_image_1 = gr_load_image("assets/agents/turret/fire_turret_1_activated_1.png".toStringz, 0);
      activated_image_2 = gr_load_image("assets/agents/turret/fire_turret_1_activated_2.png".toStringz, 0);
    }
  }
  
  bool activated = false;
  long deactivation_time;
  long deactivation_delay = 100;
  Animation deactivated_animation, activated_animation;
  
  this(){
    deactivated_animation = new Animation([deactivated_image], 1.0f, Vector2f(0.5f, 0.0f), Vector2f(1.0f, 1.0f));
    activated_animation = new Animation([activated_image_1, activated_image_2], 0.1f, Vector2f(0.5f, 0.0f), Vector2f(1.0f, 1.0f));
    animation = deactivated_animation;
  }
  
  override void update(){
    if(activated){
      if(deactivation_time < game_time){
        animation = deactivated_animation;
        activated = false;
      }
      Fireball1 fireball = new Fireball1;
      fireball.position = this.position;
      if(world !is null)
        world.place_agent(fireball);
      fireball.velocity = rvector(5);
      fireball.faction_id = faction_id;
    }
    super.update;
  }
  
  override void activate(Agent agent){
    faction_id = agent.faction_id;
    activated = true;
    deactivation_time = game_time + deactivation_delay;
    animation = activated_animation;
  }
}