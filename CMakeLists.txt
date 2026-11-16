cmake_minimum_required(VERSION 3.16)

# Fester Compiler: gcc.
# Achtung: greift nur beim ersten Konfigurieren - ein bereits mit einem
# anderen Compiler konfiguriertes build/ muss vorher geloescht werden.
set(CMAKE_C_COMPILER gcc)

project(demo C)

# Standard-Build-Typ, falls beim Konfigurieren keiner angegeben wurde.
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# Optimierung/Debug-Infos je Build-Typ (statt fest verdrahtetem -O2).
#   Debug   -> -O0 -g3   (volles Debugging)
#   Release -> -O2 -DNDEBUG
set(CMAKE_C_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_C_FLAGS_RELEASE "-O2 -DNDEBUG")

# Strikte Sprachversion: C17 (-std=c17).
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Beim Konfigurieren compile_commands.json fuer clangd erzeugen.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(demo
    app/main.c
)

target_include_directories(demo PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/lib
)

target_compile_options(demo PRIVATE -Wall -Wextra)
target_compile_definitions(demo PRIVATE _DEFAULT_SOURCE)

# Statische raylib-Bibliothek (Wayland-Backend, OpenGL 3.3) aus lib/.
set(RAYLIB_LIB ${CMAKE_CURRENT_SOURCE_DIR}/lib/libraylib.a)
if(NOT EXISTS ${RAYLIB_LIB})
    message(FATAL_ERROR "raylib nicht gefunden: ${RAYLIB_LIB}")
endif()

# libraylib.a bindet GLFW ein und laedt OpenGL/Wayland zur Laufzeit per
# dlopen - Link-Abhaengigkeiten sind daher nur noch libraylib und libm.
# OpenGL, pthread, dl, rt und die Wayland-Bibliotheken werden nicht gegen
# den Linker gebunden.
target_link_libraries(demo PRIVATE
    ${RAYLIB_LIB}
    m
)
