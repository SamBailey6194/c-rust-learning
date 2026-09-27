// SPDX-License-Identifier: GPL-2.0-only
/*
 * greet.c - the implementation behind greet.h.
 */
#include <stdio.h>

#include "greet.h"

int greet(char *buf, size_t len, const char *name)
{
	int n;

	if (!buf || !name || len == 0)
		return -1;

	/*
	 * snprintf() never writes more than len bytes, NUL included, and
	 * returns the length the full string WOULD have had. A return value of
	 * len or more therefore means the greeting was cut short.
	 */
	n = snprintf(buf, len, "Hello, %s!", name);
	if (n < 0 || (size_t)n >= len)
		return -1;

	return n;
}
