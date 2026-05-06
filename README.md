# Project

## Table of content
- [Prerequisits](#prerequisits)
- [Compiling targets](#compiling-targets)

## Prerequisits
- GNU Make
- `g++` (or `clang`)

## Compiling targets
You should rename the `PRG_OUT` and `TST_OUT` variables inside the [Makefile](Makefile).  
By default their values are set to `prog` and `test_prog` respectively.

Compile lines are hidden, you can check them using `make -n`.
| Command                    | Description                                                                |
| :-                         | :-                                                                         |
| `make` and `make all`      | Calling the targets to compile the main and test program                   |
| `make clean`               | Delete all intermidiate compile files                                      |
| `make fclean`              | Calling `clean` and deleting compiled executables                          |
| `make lsan`                | Calling `all` with environment with address and memory leak sanitizers     |
| `make tsan`                | Calling `all` with thread sanitizer                                        |
| `make prod`                | Calling `all` with level 3 optimization flag only                          |

It's recommended to `make clean` before compiling with different flags to avoid *bad linkings*.