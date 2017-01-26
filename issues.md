
* Due to the simplicity of the collision detector fast moving objects can phase through walls




## Optimization

The following is a list of slow / often ran code sections and functions:

Naively speaking, module realm's `` void update() `` takes the most time of any function per call because of the `` Thread.sleep(...)`` call. However, this function also takes up a large amount of time without the sleep call.

All classes: `` void render() `` - can't really be helped except by waiting to render frames (limiting the framerate)

Module animation's `` void gr_draw(...) `` override in particular takes the most running time of all the functions.

Area class collision checks are ran infrequently but have more subroutines