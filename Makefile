################################################################################
# This file is under MIT License                                               #
# https://mit-license.org/                                                     #
#                                                                              #
# Copyright (c) 2024 - 2026 Totema                                             #
# https://github.com/TotemaM                                                   #
################################################################################

CXX = g++
VER =

GCC_FLGS = -Wuseless-cast -Wcast-align=strict -Woverloaded-virtual=2 \
	-Wformat-overflow=2 -Wformat-truncation=2 -Wimplicit-fallthrough=5 \
	-Wduplicated-cond -Wduplicated-branches -Wlogical-op

FLGS = -Wall -Wextra -Wpedantic -pedantic-errors -Og -g3 \
	-fno-omit-frame-pointer -Wshadow -Wconversion -Wsign-conversion \
	-Wdouble-promotion -Wold-style-cast -Wcast-qual -Wnon-virtual-dtor \
	-Wsuggest-override -Wnull-dereference -Wformat=2 \
	-Wmisleading-indentation -Wmissing-declarations -Wredundant-decls \
	-Wundef -Wextra-semi -Wzero-as-null-pointer-constant -Wunused \
	-Wuninitialized -D_GLIBCXX_ASSERTIONS -fstack-protector-strong \
	-fstack-clash-protection $(GCC_FLGS)

BLDD = build

################################################################################
# DEFAULT ENVIRONMENT                                                          #
################################################################################
NAME = $(BLDD)/program
SRCD = src
SRCS := $(shell find $(SRCD) -type f -name "*.cpp")
OBJS = $(patsubst $(SRCD)/%.cpp, $(BLDD)/$(SRCD)/%.o, $(SRCS))
INCS = -I $(SRCD)
LNKS =
LIBS =
DEPS = $(OBJS:.o=.d)

$(NAME): $(OBJS)
	@ echo "$@"
	@ $(CXX) $(VER) $(FLGS) $^ -o $@ $(INCS) $(LNKS) $(LIBS)

$(BLDD)/$(SRCD)/%.o: $(SRCD)/%.cpp
	@ mkdir -p $(@D)
	@ echo "$<"
	@ $(CXX) $(VER) $(FLGS) -MMD -MP -c $< -o $@ $(INCS)

-include $(DEPS)

################################################################################
# TESTING ENVIRONMENT                                                          #
################################################################################
T_NAME = $(BLDD)/tester
T_SRCD = test
T_SRCS := $(shell find $(T_SRCD) -type f -name "*.cpp")
T_OBJS = $(patsubst $(T_SRCD)/%.cpp, $(BLDD)/$(T_SRCD)/%.o, $(T_SRCS))
T_OBJS += $(filter-out $(BLDD)/$(SRCD)/main.o, $(OBJS))
T_INCS = $(INCS) -I $(T_SRCD)
T_LNKS = $(LNKS)
T_LIBS = $(LIBS)
T_DEPS = $(T_OBJS:.o=.d)

$(T_NAME): $(T_OBJS)
	@ echo "$@"
	@ $(CXX) $(VER) $(FLGS) $^ -o $@ $(T_INCS) $(T_LNKS) $(T_LIBS)

$(BLDD)/$(T_SRCD)/%.o: $(T_SRCD)/%.cpp
	@ mkdir -p $(@D)
	@ echo "$<"
	@ $(CXX) $(VER) $(FLGS) -MMD -MP -c $< -o $@ $(T_INCS)

-include $(T_DEPS)

################################################################################
# FAKE TARGETS                                                                 #
################################################################################
.PHONY: all clean fclean re san tsan prod

all: $(NAME) $(T_NAME)

clean:
	rm -rf $(BLDD)

fclean: clean
	rm -rf $(NAME) $(T_NAME)

re: fclean $(NAME)

san: FLGS += -fsanitize=leak,address,undefined
san: all

tsan: FLGS += -fsanitize=thread,undefined
tsan: all

prod: FLGS = -O3
prod: all

run: $(NAME)
	@ ./$<

test: $(T_NAME)
	@ ./$<
