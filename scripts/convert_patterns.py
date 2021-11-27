import json
from pathlib import Path
from typing import Iterable, List, Union


def pattern_to_table_str(pattern: dict) -> str:
    pattern_type = pattern["type"]

    pattern_name = pattern.get("name", None)
    if pattern_name is None:
        pattern_name = ""
    else:
        pattern_name = " -- " + pattern_name

    if "pattern" in pattern:
        pattern_pattern: Union[str, List[str]] = pattern["pattern"]
        if type(pattern_pattern) is str:
            pattern_pattern = f'"{pattern_pattern}"'
        elif type(pattern_pattern) is list:
            pattern_pattern = list(map(lambda x: f'"{x}"', pattern_pattern))
            pattern_pattern = "{" + ", ".join(pattern_pattern) + "}"
        else:
            raise ValueError(f"Pattern is the wrong type: {type(pattern_pattern)}.")
        return f'    {{ pattern = {pattern_pattern}, type = "{pattern_type}" }},{pattern_name}'
    elif "regex" in pattern:
        pattern_regex: str = pattern["regex"]
        return f'--    {{ regex = {pattern_regex}, type = "{pattern_type}" }},{pattern_name}'
    else:
        raise KeyError("Neither pattern nor regex found")


with open(Path(".") / "data" / "patterns.json", "r") as f:
    patterns = json.load(f)

patterns_table_str = "\n".join(pattern_to_table_str(pattern) for pattern in patterns)

with open(Path(".") / "patterns.lua", "w") as f:
    f.write(
        f"""\
local operators_regex_pattern = require "plugins.language_julia.substitutions"

local patterns = {{
{patterns_table_str}
}}

return patterns
"""
    )
