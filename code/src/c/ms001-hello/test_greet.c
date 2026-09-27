// SPDX-License-Identifier: GPL-2.0-only
/*
 * test_greet.c - tests for greet(), built as build/test_greet.
 *
 * Each test states one behaviour from the contract in greet.h. The expected
 * values are written out by hand rather than computed the way greet()
 * computes them, so a bug in the formatting cannot hide in the test as well.
 */
#include "check.h"
#include "greet.h"

/* The normal case: the greeting fits, and its length comes back. */
static void test_greet_normal(void)
{
	char buf[32];

	CHECK_EQ_INT(greet(buf, sizeof(buf), "world"), 13);
	CHECK_STR_EQ(buf, "Hello, world!");

	CHECK_EQ_INT(greet(buf, sizeof(buf), "Sam"), 11);
	CHECK_STR_EQ(buf, "Hello, Sam!");
}

/* NULL in, -1 out - and no crash. */
static void test_greet_null(void)
{
	char buf[32];

	CHECK_EQ_INT(greet(NULL, sizeof(buf), "world"), -1);
	CHECK_EQ_INT(greet(buf, sizeof(buf), NULL), -1);
}

/* A zero-length buffer has no room even for the terminating NUL. */
static void test_greet_zero_length(void)
{
	char buf[32];

	CHECK_EQ_INT(greet(buf, 0, "world"), -1);
}

/*
 * The boundary: "Hello, world!" is 13 characters and needs 14 bytes with its
 * NUL. Exactly 14 fits; 13 is one byte short and must report truncation.
 * Off-by-one mistakes live here, so both sides of the line are tested.
 */
static void test_greet_truncation(void)
{
	char buf[32];

	CHECK_EQ_INT(greet(buf, 14, "world"), 13);
	CHECK_STR_EQ(buf, "Hello, world!");

	CHECK_EQ_INT(greet(buf, 13, "world"), -1);

	/* snprintf() still NUL-terminates what it had room for. */
	CHECK_EQ_INT(greet(buf, 5, "world"), -1);
	CHECK_STR_EQ(buf, "Hell");
}

int main(void)
{
	test_greet_normal();
	test_greet_null();
	test_greet_zero_length();
	test_greet_truncation();

	return check_summary();
}
