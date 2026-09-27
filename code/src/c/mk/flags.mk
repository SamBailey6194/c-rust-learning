# code/src/c/mk/flags.mk — the compiler and tool flags every C exercise builds with.
#
# Included by mk/exercise.mk, never used on its own. Each variable holds ONE kind of flag,
# so a target can combine exactly the sets it needs and nothing else:
#
#	make / make test	CSTD + WARN + DBG
#	make san		CSTD + WARN + DBG + SAN + SAN_HALT	(output in build/san/)
#	make lint		CSTD + WARN + DBG + ANALYZE		(output in build/lint/)
#	make memcheck		the plain build above, run under $(VALGRIND) $(VALGRIND_FLAGS)
#
# The full reasoning lives in code/docs/BUILD.md. The comments here say why each flag
# exists at the point where it is set, because a flag nobody can explain is a flag nobody
# dares remove.
#
# Anything set here can be overridden for one run from the command line, which is the
# quickest way to see what a flag does:
#
#	make -C code/src/c/ms001-hello clean all WARN=-Wall	# watch fewer warnings fire
#	make -C code/src/c/ms001-hello clean all CC=clang	# a second compiler, once installed

# ---------------------------------------------------------------------------------------
# The compiler
# ---------------------------------------------------------------------------------------

# GNU make predefines CC as `cc` (its origin is "default"), so a bare `CC ?= gcc` would
# never fire: `?=` only assigns to a variable that is not defined at all. Undefining the
# built-in first lets `?=` do what it reads as — use gcc unless the environment or the
# command line chose something else. `make CC=clang` and `CC=clang make` both still win.
ifeq ($(origin CC),default)
undefine CC
endif
CC ?= gcc

# ---------------------------------------------------------------------------------------
# The language standard
# ---------------------------------------------------------------------------------------

# ISO C17 with GNU extensions switched OFF. gcc 13 defaults to -std=gnu17, which quietly
# accepts GNU-only constructs (statement expressions, zero-length arrays, `typeof`); with
# -std=c17 plus -Wpedantic below, non-portable code is reported instead of accepted.
# Decision and the C23 question: project-management/src/08-DECISIONS/
# ADR-MS001-C-STANDARD-C17-27-09-2026.md
CSTD := -std=c17

# ---------------------------------------------------------------------------------------
# Warnings — every one of them is an error
# ---------------------------------------------------------------------------------------

# -Wall                 the "commonly useful" set. Despite the name it is NOT all warnings.
# -Wextra               the next set: unused parameters, signed/unsigned comparisons, and more.
# -Wpedantic            everything ISO C requires a diagnostic for; with -std=c17 it rejects
#                       extensions in their plain spelling (statement expressions, zero-length
#                       arrays) rather than silently compiling them. The __attribute__ and
#                       __typeof__ spellings, and anything after __extension__, still pass:
#                       the gcc manual says it finds "some non-ISO practices, but not all".
# -Wshadow              a local that hides an outer variable of the same name — the source of
#                       "I set it, and nothing changed".
# -Wconversion          implicit conversions that can change a value (long -> int, int -> char,
#                       and in C it also turns on -Wsign-conversion for signed <-> unsigned).
# -Wstrict-prototypes   in C17, `int f()` means "unspecified arguments", not "no arguments".
#                       Write `int f(void)`; this makes the compiler insist.
# -Wformat=2            -Wformat plus -Wformat-nonliteral, -Wformat-security and -Wformat-y2k:
#                       printf-family format/argument mismatches, and format strings that are
#                       not literals (the classic format-string vulnerability).
# -Werror               warnings become errors. A warning that can be ignored is a warning
#                       that will be ignored; here the build simply stops.
WARN := -Wall -Wextra -Wpedantic -Wshadow -Wconversion -Wstrict-prototypes -Wformat=2 -Werror

# ---------------------------------------------------------------------------------------
# Debugging
# ---------------------------------------------------------------------------------------

# -g3   the most debug information gcc emits, including macro definitions, so gdb can
#       expand and print macros (plain -g is level 2 and leaves them out).
# -O0   no optimisation: every source line maps to the instructions gdb steps through, and
#       valgrind and sanitiser reports point at the line that is really at fault.
#       The cost, accepted knowingly: a few warnings (notably -Wmaybe-uninitialized) only
#       fire when the optimiser runs its data-flow analysis. Try
#       `make clean all DBG="-g3 -O2"` now and then to see whether anything new appears.
DBG := -g3 -O0

# ---------------------------------------------------------------------------------------
# Runtime checking: sanitisers (make san)
# ---------------------------------------------------------------------------------------

# -fsanitize=address      AddressSanitizer: instruments every load and store to catch
#                         out-of-bounds access, use-after-free and double free; its
#                         LeakSanitizer half reports leaks when the program exits.
# -fsanitize=undefined    UndefinedBehaviorSanitizer: runtime checks for signed overflow,
#                         invalid shifts, misaligned or NULL pointer use, and more.
# -fno-omit-frame-pointer keeps the frame pointer so sanitiser stack traces are complete.
# These flags go on BOTH the compile and the link line: the link pulls in the runtimes.
SAN := -fsanitize=address,undefined -fno-omit-frame-pointer

# UBSan's default is to print a report and carry on, so a program full of undefined
# behaviour can still exit 0 and a test run would pass. Turning recovery off makes the
# first report fatal with a non-zero exit, so `make san` fails when it finds something.
# (ASan already stops at its first error.) Kept apart from SAN so each variable holds one
# idea: SAN chooses the checks, SAN_HALT decides what a finding does to the exit status.
SAN_HALT := -fno-sanitize-recover=all

# ---------------------------------------------------------------------------------------
# Static analysis (make lint)
# ---------------------------------------------------------------------------------------

# GCC's own static analyser: it follows paths through and across functions looking for
# double free, use after free, leaks, NULL dereference and similar. It is slow, so it runs
# only for `make lint`, into build/lint/. Its findings are -Wanalyzer-* warnings, which
# -Werror above turns into a failed build.
ANALYZE := -fanalyzer

# ---------------------------------------------------------------------------------------
# Header dependencies
# ---------------------------------------------------------------------------------------

# -MMD  while compiling foo.c, also write foo.d: a make rule listing every project header
#       foo.c includes (system headers are left out). mk/exercise.mk includes those files,
#       so editing greet.h rebuilds every object that includes it — without anyone listing
#       headers by hand.
# -MP   add an empty rule for each header, so deleting or renaming a header does not stop
#       the build with "No rule to make target 'greet.h'".
DEPFLAGS := -MMD -MP

# ---------------------------------------------------------------------------------------
# valgrind (make memcheck)
# ---------------------------------------------------------------------------------------

# Runs on the PLAIN build in build/, never on build/san/: valgrind and AddressSanitizer
# both take over memory allocation, and a binary carrying ASan does not run cleanly under
# valgrind.
#
# --leak-check=full              report each leak with the stack that allocated it
# --show-leak-kinds=all          show every kind: definite, indirect, possible, reachable
# --errors-for-leak-kinds=all    and count every kind as an ERROR, not only "definite" —
#                                memory still reachable at exit was never freed either
# --error-exitcode=1             exit 1 when valgrind reports any error, so make stops
#
# Chasing an uninitialised read? Run valgrind by hand with one more flag to see where the
# value came from: `valgrind --track-origins=yes ./build/test_greet`.
VALGRIND ?= valgrind
VALGRIND_FLAGS := --leak-check=full --show-leak-kinds=all --errors-for-leak-kinds=all \
	--error-exitcode=1
