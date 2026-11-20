################################################################################
# This file is under MIT License                                               #
# https://mit-license.org/                                                     #
#                                                                              #
# Copyright (c) 2024 - 2026 Totema                                             #
# https://github.com/TotemaM                                                   #
################################################################################

cmake_minimum_required(VERSION 3.20)

project("Project" LANGUAGES CXX)

# Choose binary output folder
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")

# Default C++ standard, can be overridden with -DCMAKE_CXX_STANDARD=<version>
set(CMAKE_CXX_STANDARD 23 CACHE STRING "C++ standard")
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	set(FLGS
		-Wall -Wextra -Wpedantic -pedantic-errors -Og -g3
		-fno-omit-frame-pointer -Wshadow -Wconversion -Wsign-conversion
		-Wdouble-promotion -Wold-style-cast -Wcast-qual -Wnon-virtual-dtor
		-Wsuggest-override -Wnull-dereference -Wformat=2
		-Wmisleading-indentation -Wmissing-declarations -Wredundant-decls
		-Wundef -Wextra-semi -Wzero-as-null-pointer-constant -Wunused
		-Wuninitialized  -fstack-protector-strong -fstack-clash-protection
		-Wuseless-cast -Wcast-align=strict -Woverloaded-virtual=2
		-Wformat-overflow=2 -Wformat-truncation=2 -Wimplicit-fallthrough=5
		-Wduplicated-cond -Wduplicated-branches -Wlogical-op -D_GLIBCXX_ASSERTIONS
	)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
	set(FLGS
		-Wall -Wextra -Wpedantic -pedantic-errors -Og -g3
		-fno-omit-frame-pointer -Wshadow -Wconversion -Wsign-conversion
		-Wdouble-promotion -Wold-style-cast -Wcast-qual -Wnon-virtual-dtor
		-Wsuggest-override -Wnull-dereference -Wformat=2
		-Wmisleading-indentation -Wmissing-declarations -Wredundant-decls
		-Wundef -Wextra-semi -Wzero-as-null-pointer-constant -Wunused
		-Wuninitialized -fstack-protector-strong -fstack-clash-protection
	)
elseif(MSVC)
	set(FLGS "")
endif()

# Apply only when no build type mentioned
set(FLGS "$<$<STREQUAL:$<CONFIG>,>:${FLGS}>")

################################################################################
# DEFAULT ENVIRONMENT                                                          #
################################################################################
set(NAME "program")
set(SRCD "src")

file(GLOB_RECURSE SRCS CONFIGURE_DEPENDS
	"${CMAKE_CURRENT_SOURCE_DIR}/${SRCD}/*.cpp"
)

list(REMOVE_ITEM SRCS "${CMAKE_CURRENT_SOURCE_DIR}/${SRCD}/main.cpp")

add_executable(${NAME}
	${SRCD}/main.cpp
	${SRCS}
)

target_include_directories(${NAME} PRIVATE
	${CMAKE_CURRENT_SOURCE_DIR}/${SRCD}
)

target_compile_options(${NAME} PRIVATE "${FLGS}")

################################################################################
# TESTING ENVIRONMENT                                                          #
################################################################################
set(T_NAME "tester")
set(T_SRCD "tests")

file(GLOB_RECURSE T_SRCS CONFIGURE_DEPENDS
	"${CMAKE_CURRENT_SOURCE_DIR}/${T_SRCD}/*.cpp"
)

add_executable(${T_NAME}
	${SRCS}
	${T_SRCS}
)

target_include_directories(${T_NAME} PRIVATE
	${CMAKE_CURRENT_SOURCE_DIR}/${SRCD}
	${CMAKE_CURRENT_SOURCE_DIR}/${T_SRCD}
)

target_compile_options(${T_NAME} PRIVATE "${FLGS}")
