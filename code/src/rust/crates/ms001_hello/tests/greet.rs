//! Integration tests: they see the crate exactly as another crate would — the public
//! library API, and the built binary run as a separate process.

use std::error::Error;
use std::process::Command;

use ms001_hello::greet;

#[test]
fn library_greets_by_name() {
    assert_eq!(greet("Sam"), "Hello, Sam!");
}

#[test]
fn library_greets_the_world_for_an_empty_name() {
    assert_eq!(greet(""), "Hello, world!");
}

/// Runs the compiled binary and returns what it printed. Cargo sets
/// `CARGO_BIN_EXE_<name>` to the binary's path when it builds integration tests.
///
/// Errors travel back with `?` instead of panicking in a helper: a test that returns
/// `Result` fails, with the error printed, when it gets an `Err`.
fn run_binary(args: &[&str]) -> Result<String, Box<dyn Error>> {
    let output = Command::new(env!("CARGO_BIN_EXE_ms001_hello"))
        .args(args)
        .output()?;
    if !output.status.success() {
        return Err(format!("the binary exited with {}", output.status).into());
    }
    Ok(String::from_utf8(output.stdout)?)
}

#[test]
fn binary_greets_the_world_with_no_argument() -> Result<(), Box<dyn Error>> {
    assert_eq!(run_binary(&[])?, "Hello, world!\n");
    Ok(())
}

#[test]
fn binary_greets_its_first_argument() -> Result<(), Box<dyn Error>> {
    assert_eq!(run_binary(&["Sam"])?, "Hello, Sam!\n");
    Ok(())
}
