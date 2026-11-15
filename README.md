# raylib C-Vorlage (CMake)

Einfache Projekt-Vorlage für raylib 6 (C), vorkompiliert für **Wayland-pur**.
Gebaut wird mit **CMake + Ninja** und **gcc**.

## Inhalt

| Datei | Zweck |
|---|---|
| `lib/libraylib.a` | Statische raylib-Bibliothek (Wayland-Backend, OpenGL 3.3) |
| `lib/raylib.h` | Haupt-Header (inkludiert die Kern-API) |
| `lib/raymath.h` | Vektor-/Matrizen-Mathematik (Header-only) |
| `lib/rlgl.h` | Optionale Low-Level-OpenGL-API |
| `lib/rcamera.h` | Optionale Kamera-Hilfsfunktionen |
| `lib/rgestures.h` | Optionale Gestenerkennung |
| `lib/external/glad.h` | Wird nur von `rlgl.h` benötigt |
| `CMakeLists.txt` | Build-Definition (Ziel: `build/demo`) |
| `Makefile` | Bequeme Wrapper um den CMake-Build |
| `.clangd` | Verweist clangd auf `build/compile_commands.json` |
| `app/main.c` | Hier startet dein Programm |

> **Hinweis:** Die Wayland-Protokoll-Header (`wayland-client-protocol.h`, …) sind
> Build-Artefakte der Bibliothek und daher **nicht** enthalten – sie stecken
> bereits fertig kompiliert in `lib/libraylib.a`.

## Schnellstart

1. `app/main.c` anlegen (oder ergänzen), z. B.:

   ```c
   #include "raylib.h"

   int main(void)
   {
       InitWindow(800, 600, "raylib C-Vorlage");

       while (!WindowShouldClose())
       {
           BeginDrawing();
           ClearBackground(RAYWHITE);
           DrawText("Hallo Wayland!", 190, 200, 20, LIGHTGRAY);
           EndDrawing();
       }

       CloseWindow();
       return 0;
   }
   ```

2. Konfigurieren und kompilieren:

   ```bash
   make cmake
   ```

3. Starten:

   ```bash
   make cmake-run     # oder direkt: ./build/demo
   ```

## Makefile-Targets

```bash
make cmake         # konfiguriert (Release) und baut build/demo
make cmake-debug   # konfiguriert (Debug) und baut build/demo
make cmake-init    # nur konfigurieren (cmake -S . -B build -G Ninja)
make cmake-run     # baut und startet build/demo
make cmake-clean   # build/ entfernen
```

## Direkt mit CMake

```bash
cmake -S . -B build -G Ninja
cmake --build build
```

Das Programm liegt danach unter `build/demo`.

Nach Code-Änderungen genügt:

```bash
cmake --build build
```

Der Build-Typ ist standardmäßig `Release` (`-O2 -DNDEBUG`). Für einen
Debug-Build mit vollen Debug-Infos (`-O0 -g3`):

```bash
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

Ein Wechsel des Build-Typs funktioniert auch in einem bestehenden `build/`
über `cmake -S . -B build -DCMAKE_BUILD_TYPE=...`; im Zweifel `rm -rf build`
und neu konfigurieren.

Neu konfigurieren muss man nur, wenn sich `CMakeLists.txt` ändert, neue
Dateien hinzukommen oder `build/` gelöscht wurde.

> Hinweis: Der Compiler ist in `CMakeLists.txt` fest auf `gcc` gesetzt. Ein
> bereits mit einem anderen Compiler konfiguriertes `build/` muss vorher
> gelöscht werden (`rm -rf build`). Überschreiben lässt sich der Compiler mit
> `-DCMAKE_C_COMPILER=...`.

## Editor

`.vscode/` und `.zed/` enthalten fertige Build-Tasks und Debug-Konfigurationen
für den CMake-Build (`build/demo`):

- VS Code: Tasks `CMake: Init (Ninja)`, `CMake: Build Release`,
  `CMake: Build Debug`, `CMake: Run (Release)`, `CMake: Clean`;
  Launch-Konfigurationen `CMake: Debug Demo (GCC)` und `CMake: Run Demo (Release)`.
- Zed: dieselben Tasks in `.zed/tasks.json`, Debug über `.zed/debug.json`
  (CodeLLDB baut vorher den Debug-Build).

## clangd / compile_commands.json

CMake erzeugt `build/compile_commands.json`, weil `CMAKE_EXPORT_COMPILE_COMMANDS`
in `CMakeLists.txt` aktiviert ist. clangd findet die Datei über den Eintrag
`CompilationDatabase: build` in `.clangd`; VS Code nutzt sie über
`C_Cpp.default.compileCommands`. Ein Symlink im Projektwurzelverzeichnis ist
nicht nötig.

## Manuelles Kompilieren (ohne CMake)

```bash
gcc app/main.c -Ilib -Llib -lraylib -lm -o program
```

`-lGL`, `-lpthread`, `-ldl`, `-lrt` und die Wayland-Bibliotheken sind beim
Linken nicht nötig: GLFW steckt in `libraylib.a`, und OpenGL sowie das
Wayland-Backend werden zur Laufzeit per `dlopen` geladen (pthread/dl liegen
seit glibc 2.34 in `libc`).

## Wichtige Hinweise

- Die Bibliothek ist **Wayland-pur** gebaut (kein X11-Codepfad). Das System muss
  eine laufende Wayland-Session haben (`$WAYLAND_DISPLAY` gesetzt).
- `libwayland-client`, `libwayland-cursor`, `libwayland-egl` und `libxkbcommon`
  werden erst **zur Laufzeit** per `dlopen` geladen – sie müssen im System
  vorhanden sein (bei jeder Wayland-Desktop-Sitzung der Fall).
- Kompiliert wurde gegen `gcc`, `-std=c99`, OpenGL 3.3.
