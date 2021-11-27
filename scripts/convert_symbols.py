import json
from pathlib import Path


def symbol_name_to_key_value(symbol_name: str, symbol_type: str) -> str:
    return f'    ["{symbol_name}"] = "{symbol_type}"'


with open(Path(".") / "data" / "keywords.json", "r") as f:
    keywords = json.load(f)

with open(Path(".") / "data" / "literals.json", "r") as f:
    literals = json.load(f)


symbols_table_str = (
    ",\n".join(map(lambda s: symbol_name_to_key_value(s, "keyword"), keywords))
    + ",\n"
    + ",\n".join(map(lambda s: symbol_name_to_key_value(s, "literal"), literals))
)

with open(Path(".") / "symbols.lua", "w") as f:
    f.write(
        f"""\
local symbols = {{
{symbols_table_str}
}}

return symbols
"""
    )
