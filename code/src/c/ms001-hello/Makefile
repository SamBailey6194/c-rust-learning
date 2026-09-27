# code/src/c/ms001-hello/Makefile — the first exercise: a greeting, a library and its tests.
#
# An exercise Makefile only NAMES things; the rules live once in ../mk/exercise.mk.
#
#	make			build build/hello and build/test_greet
#	make test		build, then run ./build/test_greet
#	make san		the tests again, under AddressSanitizer + UBSan (build/san/)
#	make memcheck		the tests again, under valgrind
#	make lint		compile everything with -fanalyzer (build/lint/)
#	make clean		delete build/
#	./build/hello Sam	run the program by hand once it is built

# The program: build/hello.
PROG := hello

# Every source of the program. main.c holds main(); greet.c is the "library" part,
# which the test binary links against as well.
SRCS := greet.c main.c

# One test binary per file: test_greet.c becomes build/test_greet.
TEST_SRCS := test_greet.c

include ../mk/exercise.mk
