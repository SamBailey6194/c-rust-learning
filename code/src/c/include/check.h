/* SPDX-License-Identifier: GPL-2.0-only */
/*
 * check.h - a tiny, header-only test harness for the C exercises.
 *
 * No library to install and nothing to link: a test file includes this header,
 * calls the CHECK macros from as many test functions as it likes, and returns
 * check_summary() from main():
 *
 *	#include "check.h"
 *	#include "greet.h"
 *
 *	static void test_greet_world(void)
 *	{
 *		char buf[32];
 *
 *		CHECK_EQ_INT(greet(buf, sizeof(buf), "world"), 13);
 *		CHECK_STR_EQ(buf, "Hello, world!");
 *	}
 *
 *	int main(void)
 *	{
 *		test_greet_world();
 *		return check_summary();
 *	}
 *
 * Argument order is always (actual, expected), so a failure reads
 * "got <actual>, expected <expected>". Each argument is evaluated exactly
 * once, because the macros hand their arguments to functions.
 *
 * Every macro is an expression that yields 1 on a pass and 0 on a failure, so
 * a test can stop early when a later check would be meaningless:
 *
 *	if (!CHECK(p != NULL))
 *		return;
 *
 * Failures go to stderr as "file:line: ..." - the same shape as a compiler
 * diagnostic, so an editor can jump straight to the line. The summary goes to
 * stdout.
 *
 * Why hand-rolled: writing the harness is itself an early exercise in macros,
 * the preprocessor's # operator and __FILE__/__LINE__. The decision is recorded
 * in project-management/src/08-DECISIONS/ADR-MS001-C-TEST-HARNESS-CHECK-H-27-09-2026.md
 */
#ifndef CHECK_H
#define CHECK_H

#include <stdio.h>
#include <string.h>

struct check_state {
	int passed;
	int failed;
};

/*
 * One counter pair per test program. A static local inside a static inline
 * function gives each translation unit its own copy without a global variable
 * that would warn as "defined but not used" in a file that never calls it.
 */
static inline struct check_state *check_state(void)
{
	static struct check_state state;

	return &state;
}

static inline int check_record(int ok)
{
	struct check_state *s = check_state();

	if (ok)
		s->passed++;
	else
		s->failed++;
	return ok;
}

static inline int check_true(int ok, const char *expr, const char *file,
			     int line)
{
	if (!ok)
		fprintf(stderr, "%s:%d: CHECK(%s) failed\n", file, line, expr);
	return check_record(ok);
}

static inline int check_eq_int(long long actual, long long expected,
			       const char *actual_expr,
			       const char *expected_expr, const char *file,
			       int line)
{
	int ok = actual == expected;

	if (!ok)
		fprintf(stderr,
			"%s:%d: CHECK_EQ_INT(%s, %s) failed: got %lld, expected %lld\n",
			file, line, actual_expr, expected_expr, actual,
			expected);
	return check_record(ok);
}

/* Two NULL pointers compare equal; NULL against a string does not. */
static inline int check_str_eq(const char *actual, const char *expected,
			       const char *actual_expr,
			       const char *expected_expr, const char *file,
			       int line)
{
	int ok;

	if (!actual || !expected)
		ok = actual == expected;
	else
		ok = strcmp(actual, expected) == 0;

	if (!ok)
		fprintf(stderr,
			"%s:%d: CHECK_STR_EQ(%s, %s) failed: got \"%s\", expected \"%s\"\n",
			file, line, actual_expr, expected_expr,
			actual ? actual : "(null)",
			expected ? expected : "(null)");
	return check_record(ok);
}

/* A true/false condition, e.g. CHECK(len < sizeof(buf)). */
#define CHECK(cond) check_true((cond) != 0, #cond, __FILE__, __LINE__)

/* Two integers, compared as long long and printed on failure. */
#define CHECK_EQ_INT(actual, expected)                                   \
	check_eq_int((actual), (expected), #actual, #expected, __FILE__, \
		     __LINE__)

/* Two NUL-terminated strings, compared with strcmp() and printed on failure. */
#define CHECK_STR_EQ(actual, expected)                                   \
	check_str_eq((actual), (expected), #actual, #expected, __FILE__, \
		     __LINE__)

/*
 * Print the pass/fail counts and return the exit status for main(): 0 when
 * every check passed, 1 when any failed. A program that ran no checks at all
 * also returns 1 - a test that checks nothing proves nothing.
 */
static inline int check_summary(void)
{
	const struct check_state *s = check_state();

	printf("check: %d passed, %d failed\n", s->passed, s->failed);
	if (s->passed + s->failed == 0) {
		fprintf(stderr, "check: no checks ran\n");
		return 1;
	}
	return s->failed ? 1 : 0;
}

#endif /* CHECK_H */
