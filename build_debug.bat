dub\dub.exe build --build=debugprofile realm
@move trace.log debug\trace.log
@move tracedm.log debug\tracedm.log
@move trace.def debug\trace.def
@rmdir /S /Q .dub