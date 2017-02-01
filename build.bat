@echo off
if exist realm.exe del realm.exe
REM Use the following line for an optimized build
REM @dmd -release -O -inline -noboundscheck -odobj realm ^
dmd -g -profile -odobj realm ^
include/sgogl ^
include/realm/dbg ^
include/realm/text ^
include/realm/game ^
include/realm/timer ^
include/realm/collision ^
include/realm/sgogl_interface ^
include/realm/agent ^
include/realm/validatable ^
include/realm/animation ^
include/realm/renderable ^
include/realm/ground ^
include/realm/wall ^
include/realm/rooted ^
include/realm/area ^
include/realm/grid ^
include/realm/material ^
include/realm/world ^
include/realm/sllist ^
include/realm/vector ^
include/realm/entity ^
include/realm/portal ^
include/realm/effect ^
include/realm/shot ^
include/realm/player ^
include/realm/accessory ^
include/realm/armor ^
include/realm/decoration ^
include/realm/drop ^
include/realm/item ^
include/realm/metaobject ^
include/realm/structured_entity ^
include/realm/weapon ^
assets/decorations/twinkle1/twinkle1 ^
assets/structured_entities/commoner/commoner ^
assets/agents/turret/turret ^
assets/portals/kernel_portal/kernel_portal ^
assets/shots/fireball1/fireball1 ^
assets/shots/fireball2/fireball2 ^
assets/shots/rocket1/rocket1 ^
assets/weapons/staff/fire_staff ^
assets/armors/shirt/shirt ^
assets/accessories/ring/ring_of_defence ^
assets/accessories/ring/ring_of_speed ^
assets/accessories/ring/dev_ring ^
assets/drops/drop_tiers ^
assets/grounds/rocky/rocky_ground_1 ^
assets/grounds/stone/stone_ground_1 ^
assets/grounds/sand/sand_1 ^
assets/grounds/dirt/dirt_1 ^
assets/grounds/brick/brick_path_1 ^
assets/grounds/brick/makeshift_brick_path_1 ^
assets/grounds/carpet/portal_carpet_1 ^
assets/grounds/carpet/red_carpet_1 ^
assets/grounds/water/fountain_water_1 ^
assets/grounds/grass/grass_1 ^
assets/grounds/grass/matted_grass_1 ^
assets/grounds/grass/grass_with_flowers_1 ^
assets/grounds/misc/fountain_wall_1 ^
assets/walls/cactus1/cactus1 ^
assets/walls/stone_wall/stone_wall_1 ^
assets/walls/kernel_house/kernel_house_tall_1 ^
assets/walls/kernel_house/kernel_house_short_1 ^
assets/walls/blank_impassable/blank_impassable ^
assets/walls/white_fence/white_fence_1 ^
assets/walls/stability_boundary/stability_boundary_1 ^
assets/worlds/testing_world/testing_world ^
-J"assets/worlds/testing_world" ^
assets/worlds/kernel/kernel ^
-J"assets/worlds/kernel" ^
-Iinclude lib/sgogl.lib