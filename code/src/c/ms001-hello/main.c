// SPDX-License-Identifier: GPL-2.0-only
/*
 * main.c - the hello program: prints a greeting for argv[1], or for "world".
 *
 *	$ ./build/hello
 *	Hello, world!
 *	$ ./build/hello Sam
 *	Hello, Sam!
 */
#include <stdio.h>
#include <stdlib.h>

#include "greet.h"

int main(int argc, char *argv[])
{
	char buf[64];
	const char *name = argc > 1 ? argv[1] : "world";

	if (greet(buf, sizeof(buf), name) < 0) {
		fprintf(stderr, "hello: cannot greet \"%s\": name too long\n",
			name);
		return EXIT_FAILURE;
	}

	puts(buf);
	return EXIT_SUCCESS;
}
