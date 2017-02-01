module structured_entity;

import animation;
import game;
import weapon;
import armor;
import accessory;
import drop_tiers;
import item;
import drop;
import entity;

class Structured_entity : Entity {
  
  Weapon weapon;
  Armor armor;
  Accessory accessory;
  
  this(){
    super();
  }
  ~this(){
    // drop weapon, armor, accessory and items as drops
    if(world !is null){
      if(weapon !is null || armor !is null || accessory !is null){
        Drop drop;
        if(weapon !is null)
          drop = drop_decide_tier(weapon.tier);
        else if(armor !is null)
          drop = drop_decide_tier(armor.tier);
        else if(accessory !is null)
          drop = drop_decide_tier(accessory.tier);
        drop.position = position;
        world.place_agent(drop);
        drop.items[0] = cast(Item)weapon;
        drop.items[1] = cast(Item)armor;
        drop.items[2] = cast(Item)accessory;
        weapon = null; armor = null; accessory = null;
      }
    }
  }
  
  override string description(){ return "An undefined entity with equipment"; }
  
  override int entity_subtype_id(){ return Entity.subtype_structured_entity; }
  
  override void update(){
    if(regular_attack_started && weapon !is null && weapon.valid)
      weapon.use(this);
    super.update;
  }
  
  override void render(){
    if(weapon !is null && weapon.animation !is null && weapon.animation.valid){
      Vector2f display_offset = Vector2f(0.5f, 0.5f + height);
      if(y_shift){
        if(flip_horizontally){
          display_offset.x *= -1;
          gr_draw_flipped_horizontally(weapon.animation.update(game_time), position + display_offset, render_depth + position.y, angle + render_angle, 0.75f);
        }
        else
          gr_draw(weapon.animation.update(game_time), position + display_offset, render_depth + position.y, angle + render_angle, 0.75f);
      }
      else {
        if(flip_horizontally){
          display_offset.x *= -1;
          gr_draw_flipped_horizontally(weapon.animation.update(game_time), position + display_offset, render_depth, angle + render_angle, 0.75f);
        }
        else
          gr_draw(weapon.animation.update(game_time), position + display_offset, render_depth, angle + render_angle, 0.75f);
      }
    }
    super.render;
  }
  
  override void apply_damage(float damage){
    float real_damage = damage;
    if(armor !is null && armor.valid)
      real_damage = armor.modify_damage(real_damage);
    if(accessory !is null && accessory.valid)
      real_damage = accessory.modify_damage(real_damage);
    super.apply_damage(damage);
  }
  
  void equip_weapon(Weapon new_weapon){
    if(weapon !is null && weapon.valid)
      weapon.dequipped(this);
    if(new_weapon !is null && new_weapon.valid){
      weapon = new_weapon;
      weapon.equipped(this);
    }
  }
  void equip_armor(Armor new_armor){
    if(armor !is null && accessory.valid)
      armor.dequipped(this);
    if(new_armor !is null && new_armor.valid){
      armor = new_armor;
      armor.equipped(this);
    }
  }
  void equip_accessory(Accessory new_accessory){
    if(accessory !is null && accessory.valid)
      accessory.dequipped(this);
    if(new_accessory !is null && new_accessory.valid){
      accessory = new_accessory;
      accessory.equipped(this);
    }
  }
}