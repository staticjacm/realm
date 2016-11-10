
import vector;

alias Vector2f = Vector2!float;

/++
Represents a physical object that can inhabit a realm.
A conceptual abstract of floating (can move freely between grid locations) and fixed (affixed to the grid) objects
Each physical has a size for collision detection purposes
++/
class Dynamical {
  Vector2f velocity = Vector2f(0, 0);
  float mass = 1;
  float restitution = 0; /// Set to zero for inelastic collisions
  
  
}