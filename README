# Project

## Table of content
- [Prerequisits](#prerequisits)
- [Compiling targets](#compiling-targets)
- [Execute](#execute)

## Prerequisits

GNU Make is required to compile the project.

## Compiling targets
| Command      | Description                                                                |
| :----------- | :------------------------------------------------------------------------- |
| `make`       | Compile main program and test environment                                  |
| `make prog`  | Compile main program                                                       |
| `make test`  | Compile test environment and linking it with main program components       |
| `make clear` | Delete all previous compiled files                                         |
| `make lsan`  | Compile main and test environment with address and memory leak sanitizers  |
| `make tsan`  | Compile main and test environment with thread sanitizer                    |
| `make prod`  | Compile main program only with level 3 optimization flag                   |

It's recommended to `make clear` before compiling with different flags to avoid *bad linkings*.

## Execute

The main program and test executable are both compiled inside the `out` directory.