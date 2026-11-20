# C++ Project Template

## Table of contents
- [Prerequisites](#prerequisites)
- [Project layout](#project-layout)
- [Compiling](#compiling)
	- [GNU Make](#gnu-make)
	- [CMake](#cmake)

## Prerequisites
- GNU Make, or CMake 3.20 or newer
- `g++` 11 or newer, or `clang++` 17 or newer (needed for the default C++23 standard)
	- With GNU Make, `g++` is used by default. To use `clang++`, set `CXX = clang++` and empty the `GCC_FLGS` variable, which holds GCC-only warning flags.
	- With CMake, the compiler is detected automatically and the matching flags are chosen.

## Project layout
| Path           | Content                                                                    |
| :-             | :-                                                                         |
| `src/`         | Sources of the main program, `src/main.cpp` being its entrypoint           |
| `tests/`       | Sources of the test program, with its own `main()`                         |
| `build/`       | Build outputs (ignored by git)                                             |

The test program is built from every file in `tests/` plus every file in `src/` except `src/main.cpp`. Do not put functions the tests need inside `src/main.cpp`, since the test program cannot see them.

`tests/` must contain at least one source file with a `main()`. Otherwise the test program cannot be built (`make all` fails at link time and CMake fails at configure time).

Both build systems use the same development flags : strict warnings, `-Og -g3` debug info, and hardening options (stack protector, `_GLIBCXX_ASSERTIONS` on GCC).

Both build systems default to *C++23*, the latest standard fully accepted by current `g++` and `clang++`. If you need an older one (old compiler, legacy code), keep these limits in mind :
- Some old code no longer compiles in newer standards. For example, `std::auto_ptr`, `register` and dynamic exception specifications (`throw(X)`) were removed in C++17, and `u8"..."` literals changed type in C++20.
- Below C++11, `-Wsuggest-override` warns on every overriding virtual function without a way to fix it, and `long long`, `<cstdint>` and `nullptr` are not available.

## Compiling
### GNU Make
You should rename the `NAME` and `T_NAME` variables inside the [Makefile](Makefile).  
By default their values are set to `program` and `tester` respectively, and are built inside the `BLDD` folder (`build/`).

The C++ standard is set by the `VER` variable (`-std=c++23` by default). Edit it, or override it for one build with `make VER=-std=c++17` (run `make clean` first).  
Extra library search paths go in `LNKS` (e.g. `-L path/to/lib`) and libraries in `LIBS` (e.g. `-lpthread`). The test program reuses them through `T_LNKS` and `T_LIBS`.

Compile lines are hidden, you can check them using `make -n`.
| Command                    | Description                                                                         |
| :-                         | :-                                                                                  |
| `make`                     | Compile the main program only                                                       |
| `make all`                 | Compile the main and test programs                                                  |
| `make run`                 | Compile then run the main program                                                   |
| `make test`                | Compile then run the test program                                                   |
| `make clean`               | Delete the `BLDD` folder (including the executables if they are built inside it)    |
| `make fclean`              | Call `clean` and delete the executables (useful if they are built outside `BLDD`)   |
| `make re`                  | Call `fclean` then compile the main program                                         |
| `make san`                 | Call `all` with address, leak and undefined behavior sanitizers                     |
| `make tsan`                | Call `all` with thread and undefined behavior sanitizers                            |
| `make prod`                | Call `all` with level 3 optimization flag only                                      |

Do not use `make re` with the `-j` flag : `fclean` and the build could run at the same time and break it. Use `make fclean` then `make -j` instead.

Object files are not rebuilt when only the flags change. Run `make clean` before switching between `make`, `san`, `tsan` and `prod`, otherwise you may get *bad linkings* or a binary built with the previous flags.

If a ThreadSanitizer binary stops with `FATAL: ThreadSanitizer: unexpected memory mapping`, the cause is the system, not the build. Recent kernels randomize memory addresses more than older TSan runtimes (e.g. GCC 13) support. Run the binary with address randomization disabled: `setarch $(uname -m) -R ./build/program`.

### CMake
You should rename the project in `project(...)` and the `NAME` and `T_NAME` variables inside the [CMakeLists.txt](CMakeLists.txt).  
By default the executables are named `program` and `tester`, and are built inside the build folder given to `cmake -B`.  
To store them elsewhere, change `CMAKE_RUNTIME_OUTPUT_DIRECTORY`. A relative path (e.g. `"bin"`) is relative to the build folder, use `"${CMAKE_SOURCE_DIR}/bin"` for a folder at the root of the project.

The C++ standard defaults to `23` through `CMAKE_CXX_STANDARD`. Change it there, or pass `-DCMAKE_CXX_STANDARD=<version>` when configuring. GNU extensions are disabled, so `20` gives `-std=c++20` and not `-std=gnu++20`.

Source files are collected automatically. New `.cpp` files are picked up at the next build, no need to re-run the configure step.

The development flags are only applied when **no build type** is given. Any build type (`Debug`, `Release`, `RelWithDebInfo`, `MinSizeRel`) uses CMake's own flags instead :
| Build type          | Flags used                         | GNU Make equivalent |
| :-                  | :-                                 | :-                  |
| *(none)*            | Development flags                  | `make all`          |
| `Debug`             | `-g`                               |                     |
| `Release`           | `-O3 -DNDEBUG`                     | `make prod`         |
| `RelWithDebInfo`    | `-O2 -g -DNDEBUG`                  |                     |
| `MinSizeRel`        | `-Os -DNDEBUG`                     |                     |

Use one build folder per configuration. Each folder keeps its own flags, so there is no need to clean when switching.
| Command                                                                          | Description                                              |
| :-                                                                               | :-                                                       |
| `cmake -B build/cmake`                                                           | Configure with the development flags                     |
| `cmake -B build/release -DCMAKE_BUILD_TYPE=Release`                              | Configure a release build                                |
| `cmake -B build/san -DCMAKE_CXX_FLAGS="-fsanitize=leak,address,undefined"`       | Configure with sanitizers (same as `make san`)           |
| `cmake -B build/tsan -DCMAKE_CXX_FLAGS="-fsanitize=thread,undefined"`            | Configure with sanitizers (same as `make tsan`)          |
| `cmake -B build/cmake -DCMAKE_CXX_STANDARD=17`                                   | Choose the C++ standard (same as `VER = -std=c++17`)     |
| `cmake -B build/cmake -DCMAKE_CXX_COMPILER=clang++`                              | Choose the compiler (only on a fresh build folder)       |
| `cmake --build build/cmake -j`                                                   | Compile the main and test programs                       |
| `cmake --build build/cmake --target program`                                     | Compile one program only                                 |
| `cmake --build build/cmake --verbose`                                            | Compile and show the compile lines                       |
| `cmake --build build/cmake --target clean`                                       | Delete the compiled files                                |
| `./build/cmake/program`, `./build/cmake/tester`                                  | Run the main or test program                             |

Keep the CMake build folders out of the `build/` root used by GNU Make, or the executables of both would overwrite each other. Note that `make clean` deletes the whole `build/` folder, CMake ones included.

The ThreadSanitizer note from the [GNU Make](#gnu-make) section applies to CMake builds too.
