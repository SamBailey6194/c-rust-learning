# code/src/c/Makefile — run one make target across every C exercise.
#
#	make -C code/src/c			build every exercise (same as `all`)
#	make -C code/src/c test			build and run every exercise's tests
#	make -C code/src/c san			tests again under AddressSanitizer + UBSan
#	make -C code/src/c memcheck		tests again under valgrind
#	make -C code/src/c lint			compile everything with gcc's -fanalyzer
#	make -C code/src/c clean		delete every exercise's build/ folder
#
# One exercise on its own:	make -C code/src/c/ms001-hello test
#
# This file holds no build rules. The rules live once, in mk/exercise.mk, and each
# exercise's own Makefile includes them; this file only walks the exercises in order and
# runs the same target in each. A new exercise folder named msNNN-kebab-name/ is picked up
# with no edit here, once it holds its Makefile.
#
# The walk stops at the first exercise that fails and names it, so the one line to re-run
# is on screen. Variables given on the command line (`make -C code/src/c test CC=clang`)
# reach every exercise, because make passes them down to sub-makes by itself.

# Every folder named like ms001-hello/ that holds a Makefile, in name order. A folder with
# no Makefile is not an exercise here: usually one whose sources are on another branch or
# stashed, leaving only its gitignored build/ behind. It is skipped with a warning rather
# than failing every target with "No rule to make target".
EXERCISES := $(sort $(dir $(wildcard ms[0-9][0-9][0-9]-*/Makefile)))
STRAYS := $(filter-out $(EXERCISES),$(sort $(wildcard ms[0-9][0-9][0-9]-*/)))

GOALS := all test san memcheck lint clean

.DEFAULT_GOAL := all
.PHONY: $(GOALS)

# $@ is whichever goal was asked for; the same recipe serves all six.
$(GOALS):
	@for dir in $(STRAYS); do \
		echo "c: skipping $${dir%/}: no Makefile (a leftover build/ from another branch?)" >&2; \
	done
	@if [ -z "$(EXERCISES)" ]; then \
		echo "c: no exercise folders (ms###-name/) found under $(CURDIR)" >&2; \
		exit 1; \
	fi
	@for dir in $(EXERCISES); do \
		echo "==> $${dir%/}: make $@"; \
		$(MAKE) --no-print-directory -C $$dir $@ || { \
			echo "c: 'make $@' FAILED in $${dir%/}" >&2; \
			echo "c: re-run it alone with: make -C code/src/c/$${dir%/} $@" >&2; \
			exit 1; \
		}; \
	done
