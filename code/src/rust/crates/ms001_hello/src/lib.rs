//! `ms001_hello` — the library half of the first Rust exercise.
//!
//! The same greeting as `code/src/c/ms001-hello/`, written the Rust way: the function
//! returns an owned `String`, so there is no caller-supplied buffer, no length to get wrong
//! and no truncation case to report. Comparing the two is the point of the exercise.

/// Returns the greeting `Hello, <name>!`.
///
/// An empty `name` greets the world, so `greet("")` and `greet("world")` agree.
///
/// # Examples
///
/// ```
/// use ms001_hello::greet;
///
/// assert_eq!(greet("Sam"), "Hello, Sam!");
/// assert_eq!(greet(""), "Hello, world!");
/// ```
#[must_use]
pub fn greet(name: &str) -> String {
    let name = if name.is_empty() { "world" } else { name };
    format!("Hello, {name}!")
}

#[cfg(test)]
mod tests {
    use super::greet;

    #[test]
    fn greets_by_name() {
        assert_eq!(greet("Sam"), "Hello, Sam!");
    }

    #[test]
    fn empty_name_greets_the_world() {
        assert_eq!(greet(""), "Hello, world!");
    }

    #[test]
    fn keeps_non_ascii_names_intact() {
        // A &str is UTF-8, so a multi-byte name needs no special handling here —
        // unlike a byte-counted C buffer, where "é" costs two bytes.
        assert_eq!(greet("Zoë"), "Hello, Zoë!");
    }
}
