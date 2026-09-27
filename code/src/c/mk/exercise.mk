# code/src/c/mk/exercise.mk — the shared rules every C exercise includes.
#
# An exercise Makefile sets three variables and includes this file, nothing more:
#
#	PROG      := hello			# the program, built as build/hello
#	SRCS      := greet.c main.c		# every program source, main() included
#	TEST_SRCS := test_greet.c		# one test binary per file, each with its own main()
#	include ../mk/exercise.mk
#
# Optional: MAIN (default main.c) names the SRCS file that holds main(). Every other file
# in SRCS is "library" code, which each test binary links against — that is how a test
# calls greet() without dragging in the program's own main().
#
# Targets (the same six at the top level, where they run in every exercise):
#
#	all		(default) build build/$(PROG) and every test binary
#	test		build, then run each build/test_* binary; the first failure stops it
#	san		rebuild into build/san/ with AddressSanitizer + UBSan, run the tests there
#	memcheck	run the plain build/test_* binaries under valgrind
#	lint		compile every source with -fanalyzer into build/lint/
#	clean		delete build/
#
# Everything lands in the exercise's own build/ folder (gitignored), so a clean checkout
# holds source only and `make clean` is a single rm. Flags come from flags.mk beside this
# file; the reasoning is in code/docs/BUILD.md.

# Where this file lives, worked out before anything else is included: MAKEFILE_LIST ends
# with the file being read right now. From the exercise folder it is `../mk/`.
MK_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(MK_DIR)flags.mk

# The shared headers (check.h) sit beside mk/: `../mk/` becomes `../include`.
INC_DIR := $(patsubst %mk/,%include,$(MK_DIR))

# No built-in implicit rules. Every rule this build uses is written out below, so nothing
# surprising (such as make linking main.c straight into ./main) can happen behind it.
MAKEFLAGS += --no-builtin-rules

# If a recipe fails half-way, delete the half-written target. Without this, a truncated
# object file survives with a fresh timestamp and the next `make` believes it is current.
.DELETE_ON_ERROR:

# ---------------------------------------------------------------------------------------
# Inputs — checked early, with a message that says what to do
# ---------------------------------------------------------------------------------------

MAIN ?= main.c

ifeq ($(strip $(PROG)),)
$(error PROG is not set: set PROG, SRCS and TEST_SRCS before 'include ../mk/exercise.mk')
endif
ifeq ($(strip $(SRCS)),)
$(error SRCS is not set: list every program source, including $(MAIN))
endif

# ---------------------------------------------------------------------------------------
# Derived names
# ---------------------------------------------------------------------------------------

BUILD_DIR := build
SAN_DIR   := $(BUILD_DIR)/san
LINT_DIR  := $(BUILD_DIR)/lint

# Program sources minus the one holding main(): what a test binary links against.
LIB_SRCS := $(filter-out $(MAIN),$(SRCS))
ALL_SRCS := $(SRCS) $(TEST_SRCS)

# Plain build (build/): used by all, test and memcheck.
OBJS      := $(SRCS:%.c=$(BUILD_DIR)/%.o)
LIB_OBJS  := $(LIB_SRCS:%.c=$(BUILD_DIR)/%.o)
TEST_OBJS := $(TEST_SRCS:%.c=$(BUILD_DIR)/%.o)
TEST_BINS := $(TEST_SRCS:%.c=$(BUILD_DIR)/%)

# Sanitised build (build/san/): a separate tree, so it never mixes with the valgrind one.
SAN_OBJS      := $(SRCS:%.c=$(SAN_DIR)/%.o)
SAN_LIB_OBJS  := $(LIB_SRCS:%.c=$(SAN_DIR)/%.o)
SAN_TEST_OBJS := $(TEST_SRCS:%.c=$(SAN_DIR)/%.o)
SAN_TEST_BINS := $(TEST_SRCS:%.c=$(SAN_DIR)/%)

# Analyser build (build/lint/): objects only, nothing is linked or run.
LINT_OBJS := $(ALL_SRCS:%.c=$(LINT_DIR)/%.o)

# Objects depend on the makefiles too, so changing a flag in flags.mk rebuilds everything
# instead of leaving objects compiled under the old flags. Captured here, before the .d
# files are included at the bottom and join MAKEFILE_LIST.
MK_FILES := $(MAKEFILE_LIST)

# The preprocessor flags every compile gets: the shared include folder, plus -MMD -MP so
# each object also writes its .d header-dependency file.
CPPFLAGS += -I$(INC_DIR) $(DEPFLAGS)
CFLAGS   += $(CSTD) $(WARN) $(DBG)

# ---------------------------------------------------------------------------------------
# The six targets
# ---------------------------------------------------------------------------------------

.DEFAULT_GOAL := all
.PHONY: all test san memcheck lint clean require-tests

all: $(BUILD_DIR)/$(PROG) $(TEST_BINS)

# A test target with no tests would pass having checked nothing, and a gate that cannot
# fail is worse than no gate, because it is believed. So an empty TEST_SRCS is an error.
require-tests:
	@if [ -z "$(strip $(TEST_SRCS))" ]; then \
		echo "$(notdir $(CURDIR)): TEST_SRCS is empty — add a test_*.c file first" >&2; \
		exit 1; \
	fi

test: require-tests $(TEST_BINS)
	@for t in $(TEST_BINS); do \
		echo "--- $(notdir $(CURDIR)): ./$$t"; \
		./$$t || exit 1; \
	done

san: require-tests $(SAN_DIR)/$(PROG) $(SAN_TEST_BINS)
	@for t in $(SAN_TEST_BINS); do \
		echo "--- $(notdir $(CURDIR)): ./$$t (AddressSanitizer + UBSan)"; \
		./$$t || exit 1; \
	done

memcheck: require-tests $(TEST_BINS)
	@for t in $(TEST_BINS); do \
		echo "--- $(notdir $(CURDIR)): $(VALGRIND) ./$$t"; \
		$(VALGRIND) $(VALGRIND_FLAGS) ./$$t || exit 1; \
	done

lint: $(LINT_OBJS)
	@echo "--- $(notdir $(CURDIR)): -fanalyzer found nothing in $(ALL_SRCS)"

clean:
	rm -rf $(BUILD_DIR)

# ---------------------------------------------------------------------------------------
# How each file is made
# ---------------------------------------------------------------------------------------
# Static pattern rules (`targets: target-pattern: prereq-pattern`) apply ONLY to the
# targets listed in front of them, so there is never a question of which rule builds
# which file. `| dir` is an order-only prerequisite: the folder has to exist first, but
# its timestamp (which changes whenever a file is added to it or removed from it) never
# forces a rebuild.

# Plain objects and links.
$(OBJS) $(TEST_OBJS): $(BUILD_DIR)/%.o: %.c $(MK_FILES) | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/$(PROG): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(TEST_BINS): $(BUILD_DIR)/%: $(BUILD_DIR)/%.o $(LIB_OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ $(LDLIBS) -o $@

# Sanitised objects and links: SAN on the compile line to instrument the code, and again
# on the link line to pull in the sanitiser runtimes.
$(SAN_OBJS) $(SAN_TEST_OBJS): $(SAN_DIR)/%.o: %.c $(MK_FILES) | $(SAN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(SAN) $(SAN_HALT) -c $< -o $@

$(SAN_DIR)/$(PROG): $(SAN_OBJS)
	$(CC) $(CFLAGS) $(SAN) $(SAN_HALT) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(SAN_TEST_BINS): $(SAN_DIR)/%: $(SAN_DIR)/%.o $(SAN_LIB_OBJS)
	$(CC) $(CFLAGS) $(SAN) $(SAN_HALT) $(LDFLAGS) $^ $(LDLIBS) -o $@

# Analyser objects: compiled only so -fanalyzer runs (it needs a real compile; with
# -fsyntax-only it never starts).
$(LINT_OBJS): $(LINT_DIR)/%.o: %.c $(MK_FILES) | $(LINT_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(ANALYZE) -c $< -o $@

$(BUILD_DIR) $(SAN_DIR) $(LINT_DIR):
	mkdir -p $@

# The .d files written by -MMD: each one says which headers an object includes. The
# leading `-` means "fine if missing" — on a clean tree none exist yet, and everything is
# being built anyway.
-include $(OBJS:.o=.d) $(TEST_OBJS:.o=.d) $(SAN_OBJS:.o=.d) $(SAN_TEST_OBJS:.o=.d)
-include $(LINT_OBJS:.o=.d)
