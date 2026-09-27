//! The `ms001_hello` binary: prints a greeting for the first argument, or for "world".
//!
//! ```text
//! $ cargo run -p ms001_hello
//! Hello, world!
//! $ cargo run -p ms001_hello -- Sam
//! Hello, Sam!
//! ```

use std::env;

fn main() {
    // args() yields the program name first, so the first real argument is nth(1).
    let name = env::args().nth(1).unwrap_or_else(|| String::from("world"));
    println!("{}", ms001_hello::greet(&name));
}
