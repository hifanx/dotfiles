//! Crate-level doc comment: exercises the isekai palette.
//! See https://doc.rust-lang.org/book/ for details.

#![allow(dead_code)]

use std::collections::HashMap;
use std::fmt::{self, Display};

// TODO: todo marker
// FIXME: fixme marker
// NOTE: note marker
// WARNING: warning marker

const MAX_RETRIES: u32 = 3;
static GREETING: &str = "hello\tworld\n";
static RAW: &str = r#"raw "quoted" string"#;
static BYTES: &[u8] = b"bytes\x00";
const LETTER: char = 'a';
const NEWLINE: char = '\n';
const RATIO: f64 = 0.5e-3;
const MASK: u8 = 0b1010_1010;
const HEX: i64 = 0xFF_FF;

/// A shape with a lifetime-bound label.
#[derive(Debug, Clone, PartialEq)]
pub enum Shape<'a> {
    Circle { radius: f64, label: &'a str },
    Square(f64),
    Empty,
}

pub trait Area {
    fn area(&self) -> f64;
}

impl<'a> Area for Shape<'a> {
    fn area(&self) -> f64 {
        match self {
            Shape::Circle { radius, .. } => std::f64::consts::PI * radius * radius,
            Shape::Square(side) if *side > 0.0 => side * side,
            _ => 0.0,
        }
    }
}

impl Display for Shape<'_> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:?} -> {:.2}", self, self.area())
    }
}

#[derive(Default)]
struct Registry<T: Area + Clone> {
    items: Vec<T>,
    index: HashMap<String, usize>,
}

impl<T> Registry<T>
where
    T: Area + Clone,
{
    fn new() -> Self {
        Self {
            items: Vec::new(),
            index: HashMap::new(),
        }
    }

    fn insert(&mut self, key: impl Into<String>, item: T) -> Option<usize> {
        let id = self.items.len();
        self.items.push(item);
        self.index.insert(key.into(), id)
    }

    fn total(&self) -> f64 {
        self.items.iter().map(|s| s.area()).sum()
    }
}

macro_rules! square {
    ($x:expr) => {
        $x * $x
    };
}

async fn fetch(id: u32) -> Result<String, Box<dyn std::error::Error>> {
    if id == 0 {
        return Err("invalid id".into());
    }
    Ok(format!("item-{id}"))
}

unsafe fn raw_read(ptr: *const i32) -> i32 {
    *ptr
}

fn main() {
    let mut registry: Registry<Shape> = Registry::new();
    registry.insert(
        "circle",
        Shape::Circle {
            radius: 1.5,
            label: "c",
        },
    );
    registry.insert(String::from("square"), Shape::Square(2.0));

    let mut attempts = 0;
    'outer: loop {
        for n in 0..MAX_RETRIES {
            attempts += 1;
            if n % 2 == 0 && attempts >= 2 {
                break 'outer;
            }
        }
        while attempts < 10 {
            attempts <<= 1;
        }
    }

    let value = 42;
    let read = unsafe { raw_read(&value as *const i32) };
    let flag = true != false;
    let maybe: Option<&Shape> = registry.items.first();

    if let Some(shape) = maybe {
        println!("{shape} total={:.3} sq={}", registry.total(), square!(read));
    } else {
        eprintln!("{GREETING}{RAW}{BYTES:?}{LETTER}{NEWLINE}{RATIO}{MASK}{HEX}{flag}");
    }

    assert_eq!(Shape::Empty.area(), 0.0);
    let _ = std::mem::size_of::<Shape>();
    let _fut = fetch(1);
}
