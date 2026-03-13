################################################################################
# This file is under MIT License                                               #
# https://mit-license.org/                                                     #
#                                                                              #
# Copyright (c) 2024 - 2026 Totema                                             #
# https://github.com/TotemaM                                                   #
################################################################################

CXX = g++
VER = -std=c++20
FLG = -Wall -Wextra -Wpedantic -O0 -g3 -fno-omit-frame-pointer \
		-Wcast-align=strict -Wcast-qual -Wconversion -Wsign-conversion \
		-Wctor-dtor-privacy -Wdisabled-optimization -Wdouble-promotion \
		-Wduplicated-cond -Wduplicated-branches -Wformat=2 -Winit-self \
		-Wlogical-op -Wmissing-declarations -Wmissing-include-dirs -Wnoexcept \
		-Wnon-virtual-dtor -Wold-style-cast -Woverloaded-virtual \
		-Wredundant-decls -Wshadow -Wsign-promo -Wstrict-null-sentinel \
		-Wundef -Wuninitialized -Wuseless-cast -Wzero-as-null-pointer-constant \
		-fstack-protector-strong

PRG_OUT = prog
TST_OUT = test

OUT_DIR = out
BLD_DIR = $(OUT_DIR)/build
$(shell mkdir -p $(BLD_DIR))

all: $(OUT_DIR)/$(PRG_OUT) $(OUT_DIR)/$(TST_OUT)

################################################################################
# DEFAULT ENVIRONMENT                                                          #
################################################################################
PRG_DIR = src
PRG_SRC = $(shell find $(PRG_DIR) -type f -name *.cpp)
PRG_OBJ = $(patsubst $(PRG_DIR)/%.cpp, $(BLD_DIR)/$(PRG_DIR)/%.o, $(PRG_SRC))
PRG_INC = -I $(PRG_DIR)
PRG_LIB =
PRG_DEP = $(PRG_OBJ:.o=.d)

$(OUT_DIR)/$(PRG_OUT): $(PRG_OBJ)
	@ echo "$@"
	@ $(CXX) $(VER) $(FLG) $^ -o $@ $(PRG_LIB) $(PRG_INC)

$(BLD_DIR)/$(PRG_DIR)/%.o: $(PRG_DIR)/%.cpp
	@ mkdir -p $(@D)
	@ echo "$<"
	@ $(CXX) $(VER) $(FLG) -MMD -MP -c $< -o $@ $(PRG_INC)

-include $(PRG_DEP)

################################################################################
# TESTING ENVIRONMENT                                                          #
################################################################################
TST_DIR = test
TST_SRC = $(shell find $(TST_DIR) -type f -name '*.cpp')
TST_OBJ = $(patsubst $(TST_DIR)/%.cpp, $(BLD_DIR)/$(TST_DIR)/%.o, $(TST_SRC))
TST_OBJ += $(filter-out $(BLD_DIR)/$(PRG_DIR)/main.o \
	$(BLD_DIR)/$(PRG_DIR)/main.d, $(PRG_OBJ))
TST_INC = $(PRG_INC) -I $(TST_DIR)
TST_LIB = $(PRG_LIB)
TST_DEP = $(TST_OBJ:.o=.d)

$(OUT_DIR)/$(TST_OUT): $(TST_OBJ)
	@ echo "$@"
	@ $(CXX) $(VER) $(FLG) $^ -o $@ $(TST_LIB) $(TST_INC)

$(BLD_DIR)/$(TST_DIR)/%.o: $(TST_DIR)/%.cpp
	@ mkdir -p $(@D)
	@ echo "$<"
	@$(CXX) $(VER) $(FLG) -MMD -MP -c $< -o $@ $(TST_INC)

-include $(TST_DEP)

################################################################################
# FAKE TARGETS                                                                 #
################################################################################
.PHONY: clean fclean lsan tsan prod

clean:
	rm -rf $(BLD_DIR)

fclean:
	rm -rf $(OUT_DIR)

lsan: FLG += -fsanitize=leak,address,undefined
lsan: all

tsan: FLG += -fsanitize=thread,undefined
tsan: all

prod: FLG = -O3
prod: all
