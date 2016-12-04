@echo off
@del realm.exe
REM Use the following line for an optimized build
REM @dmd -release -O -inline -noboundscheck -odobj realm ^
@dmd -g -profile -odobj realm ^
include/sgogl ^
include/realm/game ^
include/realm/timer ^
include/realm/sgogl_interface ^
include/realm/agent ^
include/realm/refable ^
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
assets/entities/commoner/commoner ^
assets/shots/fireball1/fireball1 ^
assets/shots/fireball2/fireball2 ^
assets/grounds/rocky/rocky_ground ^
assets/walls/cactus1/cactus1 ^
assets/worlds/testing_world/testing_world ^
-Iinclude lib/sgogl.lib