
* Due to the simplicity of the collision detector fast moving objects can phase through walls

* Mouse presses and releases should be registered separately


## Optimization

The following is a list of slow / often ran code sections and functions:

Naively speaking, module realm's `` void update() `` takes the most time of any function per call because of the `` Thread.sleep(...)`` call. However, this function also takes up a large amount of time without the sleep call.

All classes: `` void render() `` - can't really be helped except by waiting to render frames (limiting the framerate)

Module animation's `` void gr_draw(...) `` override in particular takes the most running time of all the functions

Area class: `` void update(long time, float dt) `` is ran an incredibly huge number of times, its ran exactly N times per frame where N is the number of areas. Since the world is usually rectangular, N is usually W * H which is very similar to or exactly like some number N = S^2 - so this is really a very slow operation. A system for controlling which areas get updated could be used to decrease this. Obviously the best this will ever be is N = floor(s * S^2) where 's' is some (hopefully) small real number

Area class collision checks are ran infrequently but have more subroutines