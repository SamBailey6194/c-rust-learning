/* SPDX-License-Identifier: GPL-2.0-only */
/*
 * greet.h - the interface of ms001-hello: one function that formats a greeting.
 *
 * A header holds the declarations other files need and nothing else. The
 * include guard below stops a second #include of this file in the same
 * translation unit from declaring everything twice.
 */
#ifndef GREET_H
#define GREET_H

#include <stddef.h>

/*
 * greet - write "Hello, <name>!" into buf
 * @buf:  destination buffer
 * @len:  size of buf in bytes, including room for the terminating NUL
 * @name: who to greet
 *
 * Return: the number of characters written, not counting the terminating NUL,
 * or -1 if buf or name is NULL, len is 0, or the greeting did not fit in len
 * bytes. On truncation buf still holds a NUL-terminated prefix.
 */
int greet(char *buf, size_t len, const char *name);

#endif /* GREET_H */
