# C++ Project Template

## Table of contents
- [Prerequisites](#prerequisites)
- [Compiling targets](#compiling-targets)

## Prerequisites
- GNU Make
- `g++` (or `clang++`, after emptying the `GCC_FLGS` variable which holds GCC-only warning flags)

## Compiling targets
Entrypoint of the source program must be `src/main.cpp` and should not contain functions the test program could not see.

You should rename the `NAME` and `T_NAME` variables inside the [Makefile](Makefile).  
By default their values are set to `program` and `tester` respectively, and are built inside the `BLDD` folder.

The C++ standard is left to the compiler's default. Set the `VER` variable (e.g. `VER = -std=c++20`) to choose one.

Compile lines are hidden, you can check them using `make -n`.
| Command                    | Description                                                                         |
| :-                         | :-                                                                                  |
| `make`                     | Compile the main program only                                                       |
| `make all`                 | Compile the main and test programs                                                  |
| `make clean`               | Delete the `BLDD` folder (including the executables if they are built inside it)    |
| `make fclean`              | Call `clean` and delete the executables (useful if they are built outside `BLDD`)   |
| `make re`                  | Call `fclean` then `all`                                                            |
| `make san`                 | Call `all` with address, leak and undefined behavior sanitizers                     |
| `make tsan`                | Call `all` with thread and undefined behavior sanitizers                            |
| `make prod`                | Call `all` with level 3 optimization flag only                                      |

Do not use `make re` with the `-j` flag: `fclean` and `all` could run at the same time and break the build. Use `make fclean` then `make -j` instead.

Object files are not rebuilt when only the flags change. Run `make clean` before switching between `make`, `san`, `tsan` and `prod`, otherwise you may get *bad linkings* or a binary built with the previous flags.
