-- mod-version:2 -- lite-xl 2.0
local syntax = require "core.syntax"

local patterns = {
    {pattern = {"#=", "=#"}, type = "comment"}, -- Multiline comment
    {pattern = {"#", "\n"}, type = "comment"}, -- Single line comment
    {pattern = "%->", type = "operator"}, -- Arrow
    {pattern = "<%-", type = "operator"}, -- Arrow
    {pattern = "%-%->", type = "operator"}, -- Arrow
    {pattern = "=>", type = "operator"}, -- Arrow
    {pattern = "<:", type = "operator"}, -- Subtype
    {pattern = "%f[:]:%w+", type = "string"}, -- Symbol
    {pattern = "::%f[%w]", type = "operator"}, -- Typehint
    {
        pattern = "[" ..
            table.concat({"%+", "%-", "=", "/", "%*", "%^", ":"}, "") .. "]", type = "operator"
    }, -- Operator
    {pattern = "%-?0b[01]+", type = "number"}, -- Binary number
    {pattern = "%-?0x[%dabcdef]+", type = "number"}, -- Hex number
    {pattern = "%-?0o[0-7]+", type = "number"}, -- Octal number
    {pattern = "%-?%d*%.?%d+", type = "number"}, -- Decimal number with numbers after decimal point
    {pattern = "%-?%d+%.?%d*", type = "number"}, -- Decimal number with numbers before decimal point
    {pattern = "%-?%d+", type = "number"}, -- Decimal number without decimal point
    {pattern = {'[brv]?"""', '"""[^"]'}, type = "string"}, -- Multiline string
    {pattern = {'[brv]?"', '"', "\\"}, type = "string"}, -- String
    {pattern = "'\\[uU].+'", type = "string"}, -- Character with espace string
    {pattern = "'.'", type = "string"}, -- Character
    {pattern = "[%a_][%w_]*!?%f[({]", type = "function"}, -- Function
    {pattern = "@[%a_][%w_]*!?", type = "function"}, -- Macro call
    {pattern = "@?[%a_][%w_]*!?", type = "symbol"}

}

local keywords = {
    "abstract%s+type", "baremodule", "begin", "break", "catch", "const", "continue", "do", "else", "elseif", "end",
    "export", "finally", "function", "global", "if", "import", "Inf", "let", "local", "macro", "module",
    "mutable%s+struct", "NaN", "primitive%s+type", "quote", "return", "struct", "try", "using", "where", "while"
}

local literals = {"true", "false", "nothing", "missing"}

local symbols = {}

for _, keyword in ipairs(keywords) do
    symbols[keyword] = "keyword"
end

for _, literal in ipairs(literals) do
    symbols[literal] = "literal"
end

syntax.add {
    files = {"%.jl$"},
    headers = "^#!.*[ /]julia",
    comment = "#",
     patterns = patterns,
    symbols = symbols
}
