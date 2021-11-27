local operators_regex_pattern = require "plugins.language_julia.substitutions"

local patterns = {
    { pattern = {"#=", "=#"}, type = "comment" }, -- Multiline comment
    { pattern = {"#", "\n"}, type = "comment" }, -- Single line comment
    { pattern = "::%f[%w]", type = "operator" }, -- Typehint
--    { regex = operators_regex_pattern, type = "operator" }, -- Operator
    { pattern = "%f[:]:%w+", type = "string" }, -- Symbol
    { pattern = "%-?0b[01]+", type = "number" }, -- Binary number
    { pattern = "%-?0x[%dabcdef]+", type = "number" }, -- Hex number
    { pattern = "%-?0o[0-7]+", type = "number" }, -- Octal number
    { pattern = "%-?%d*%.?%d+", type = "number" }, -- Decimal number with numbers after decimal point
    { pattern = "%-?%d+%.?%d*", type = "number" }, -- Decimal number with numbers before decimal point
    { pattern = "%-?%d+", type = "number" }, -- Decimal number without decimal point
    { pattern = {"[brv]?\"\"\"", "\"\"\"[^\"]"}, type = "string" }, -- Multiline string
    { pattern = {"[brv]?\"", "\"" }, type = "string" }, -- String
    { pattern = "'\\[uU].+'", type = "string" }, -- Character with escape string
    { pattern = "'.'", type = "string" }, -- Character
    { pattern = "%S+!?%f[({]", type = "function" }, -- Function
    { pattern = "@%S+!?", type = "function" }, -- Macro call
    { pattern = "%S+!?", type = "symbol" },
}

return patterns
