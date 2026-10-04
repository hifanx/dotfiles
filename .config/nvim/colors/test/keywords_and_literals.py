import math
from dataclasses import (
    dataclass,
)
from pathlib import Path
import re

PI = 3.1415
MAX_RETRIES = 5
DEBUG_ENABLED = True
PATH = Path("/tmp/data.txt")
URL = "https://example.com/demo"


@dataclass
class Point:
    x: float
    y: float

    def __init__(self, x: float, y: float) -> None:
        self.x = x
        self.y = y

    def length(self) -> float:
        return (self.x**2 + self.y**2) ** 0.5


def math_test():
    test = math.acos(PI)
    print(test)


def documented_add(x: int, y: int) -> int:
    """@string.documentation simple documented function adding two numbers."""
    return x + y


def safe_divide(x: float, y: float) -> float:
    """Demonstrate exceptions: try/except/raise -> @keyword.exception."""
    try:
        return x / y
    except ZeroDivisionError:
        raise ValueError("cannot divide by zero")


async def fetch_point(scale: float) -> Point:
    """Async function to show coroutine-related keywords."""
    base = Point(1.0, 2.0)
    await some_async_side_effect()
    return Point(base.x * scale, base.y * scale)


def some_async_side_effect() -> None:
    """Placeholder for an async library function (often @lsp.typemod.function.defaultLibrary)."""
    pass


def regex_examples() -> None:
    pattern = re.compile(r"\w+\s+value")
    text = "line1\\nline2\tend"
    match = pattern.search(text)
    if match:
        print(match.group(0))


def boolean_and_ternary(flag: bool) -> int:
    value = 10 if flag else 0
    return value


def modifier_and_type_keywords(x: int | None) -> int:
    if x is None:
        x = 0
    final_result: int = x + 1
    return final_result


if __name__ == "__main__":
    p = Point(3.0, 4.0)
    print("length:", p.length())
