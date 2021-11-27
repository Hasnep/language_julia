import json
from pathlib import Path
import functools
import operator
from typing import List, Any


def get_utf8_character(codepoint: str) -> str:
    return chr(int(codepoint, 16))


def escape_backslashes(s: str) -> str:
    return s.replace("\\", "\\\\")


def replace_punctuation(s: str) -> str:
    return s.replace("+", "plus")


def convert(x) -> List[str]:
    characters = "".join(get_utf8_character(codepoint) for codepoint in x["codepoint"])
    name = x["name"]
    return [
        '    ["'
        + escape_backslashes(replace_punctuation(sequence))
        + '"] = {["character"] = "'
        + characters
        + '", ["name"] = "'
        + name
        + '"},'
        for sequence in x["sequence"]
    ]


def flatten(x: List[List[str]]) -> List[str]:
    return functools.reduce(operator.concat, x)


with open(Path(".") / "data" / "substitutions.json", "r") as f:
    substitutions = json.load(f)


substitutions_str = "\n".join(flatten(convert(x) for x in substitutions))

with open(Path(".") / "substitutions.lua", "w") as f:
    f.write(
        f"""\
local substitutions = {{
{substitutions_str}
}}
return substitutions
"""
    )
