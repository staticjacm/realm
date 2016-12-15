@echo off
if exist realm.exe del realm.exe
REM Use the following line for an optimized build
REM @dmd -release -O -inline -noboundscheck -odobj realm ^
dmd -g -profile -odobj realm ^
include/sgogl ^
include/realm/game ^
include/realm/timer ^
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
assets/entities/commoner/commoner ^
assets/shots/fireball1/fireball1 ^
assets/shots/fireball2/fireball2 ^
assets/shots/rocket1/rocket1 ^
assets/grounds/rocky/rocky_ground ^
assets/walls/cactus1/cactus1 ^
assets/worlds/testing_world/testing_world ^
-Iinclude lib/sgogl.lib