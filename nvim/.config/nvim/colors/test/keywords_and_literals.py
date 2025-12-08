# Treesitter demo: Python keywords, literals, attributes, constructors
# This file is meant to exercise many of the @variable.*, @constant.*, @type.*, @attribute.*,
# @function.*, @keyword.*, @boolean, @number, @number.float and @string.* groups.
# Each interesting bit has a trailing comment naming the intended highlight group.

import math  # 'import': @keyword.import, math: @module.builtin
from dataclasses import (
    dataclass,
)  # 'from'/'import': @keyword.import, dataclass: @attribute.builtin
from pathlib import Path  # Path: @type
import re  # re: @module

PI = 3.1415  # PI: @constant, 3.1415: @number.float
MAX_RETRIES = 5  # MAX_RETRIES: @constant
DEBUG_ENABLED = True  # True: @boolean


PATH = Path("/tmp/data.txt")  # string: @string, path-like: @string.special.path
URL = "https://example.com/demo"  # @string.special.url


@dataclass  # @attribute.builtin
class Point:  # Point: @type.definition
    x: float  # x: @variable.member, float: @type.builtin
    y: float

    def __init__(
        self, x: float, y: float
    ) -> None:  # __init__: @constructor.python, def: @keyword.function
        self.x = x  # self: @variable.builtin, x: @variable.parameter
        self.y = y  # y: @variable.parameter

    def length(self) -> float:
        return (self.x**2 + self.y**2) ** 0.5  # '**', '+': @operator


def math_test():
    test = math.acos(PI)
    print(test)


def documented_add(x: int, y: int) -> int:
    """@string.documentation simple documented function adding two numbers."""
    # x, y: @variable.parameter
    return x + y  # return: @keyword.return


def safe_divide(x: float, y: float) -> float:
    """Demonstrate exceptions: try/except/raise -> @keyword.exception."""
    try:  # try: @keyword.exception
        return x / y
    except ZeroDivisionError:  # except: @keyword.exception
        raise ValueError(
            "cannot divide by zero"
        )  # raise: @keyword.exception, string: @string


async def fetch_point(scale: float) -> Point:
    """Async function to show coroutine-related keywords."""
    # async def / await: @keyword.coroutine, @keyword.function
    base = Point(1.0, 2.0)
    await some_async_side_effect()  # await: @keyword.coroutine, call: @function.call
    return Point(base.x * scale, base.y * scale)


def some_async_side_effect() -> None:
    """Placeholder for an async library function (often @lsp.typemod.function.defaultLibrary)."""
    pass  # pass: @keyword


def regex_examples() -> None:
    pattern = re.compile(
        r"\w+\s+value"
    )  # raw string: @string.regexp, '\\w', '\\s': @string.escape
    text = (
        "line1\\nline2\tend"  # standard string: @string, '\\n', '\\t': @string.escape
    )
    match = pattern.search(text)  # search(): @function.method.call
    if match:  # if: @keyword.conditional
        print(match.group(0))  # print: @function.builtin


def boolean_and_ternary(flag: bool) -> int:
    # flag: @variable.parameter, bool: @type.builtin
    value = 10 if flag else 0  # inline if/else: @keyword.conditional.ternary
    return value


def modifier_and_type_keywords(x: int | None) -> int:
    # 'None' is a built-in constant: @constant.builtin
    if x is None:  # is: @keyword.operator
        x = 0
    final_result: int = (
        x + 1
    )  # type annotation 'int': @type.builtin, 'final_result': @variable
    return final_result


if __name__ == "__main__":  # __name__: @variable.builtin, string: @string
    p = Point(3.0, 4.0)  # Point(): @constructor.python call
    print("length:", p.length())
