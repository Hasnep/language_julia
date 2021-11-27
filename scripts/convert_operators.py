import json
from pathlib import Path
import functools
import operator
from typing import List, Any


def escape_regex_characters(s: str) -> str:
    characters_to_escape = [
        "[",
        "]",
        "(",
        ")",
        "{",
        "}",
        "*",
        "+",
        "?",
        "|",
        "^",
        "$",
        ".",
        "\\",
    ]
    for c in characters_to_escape:
        s = s.replace(c, "\\" + c)
    return s


with open(Path(".") / "data" / "operators.json", "r") as f:
    operators = json.load(f)

operators = operators + ["." + s for s in operators]

operators.sort()

operators = map(escape_regex_characters, operators)

operators_lua_string = "|".join(operators)

with open(Path(".") / "operators.lua", "w") as f:
    f.write(
        f'local operators_regex_pattern = "(?:{operators_lua_string})"\n\nreturn operators_regex_pattern\n'
    )
