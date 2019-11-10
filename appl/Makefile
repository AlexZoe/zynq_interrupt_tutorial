#-------------------------------------------------------------------------------
#
#  @author	Alexander Zoellner
#  @date	2019/07/21
#  @mail	zoellner.contact<at>gmail.com
#  @file	Makefile
#
#
#  brief	Makefile template for building application for interrupt test
#			using hardware timer residing on FPGA.
#
#-------------------------------------------------------------------------------

TARGET := timer

CC := gcc
CFLAGS += -O2

SRC_DIR := .
BUILD_DIR := build

# Add all source files found in the source directory (change file ending as
# required). You may also list them explicitly if you want to.
SRCS := $(wildcard $(SRC_DIR)/*.c)
# Add object file for each source file
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)


# Makefile targets
.PHONY: all analyze clean
# Default target
.DEFAULT_GOAL := all

all: $(BUILD_DIR) $(TARGET)

$(TARGET): $(OBJS)
	@echo '    ' LD '    ' $@
	@$(CC) $(LDFLAGS) -o $(TARGET) $^ $(LDLIBS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@echo '    ' CC '    ' $@
	@$(CC) $(CFLAGS) -c -o $@ $<

# Create build directory if it does not exist
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Remove all generated files
clean:
	@rm -rf $(TARGET)
	@rm -rf $(BUILD_DIR)/*.o
	@rm -rf $(BUILD_DIR)
