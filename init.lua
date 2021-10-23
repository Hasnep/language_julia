-- mod-version:2 -- lite-xl 2.0
local command = require "core.command"
local common = require "core.common"
local config = require "core.config"
local core = require "core"
local Doc = require "core.doc"
local RootView = require "core.rootview"
local style = require "core.style"
local syntax = require "core.syntax"
local View = require "core.view"
local keymap = require "core.keymap"
local autocomplete = require "plugins.autocomplete"
local substitutions = require "plugins.language_julia.substitution_data"
local operators_regex_pattern = require "plugins.language_julia.substitution_data"

local patterns = {
    {pattern = {"#=", "=#"}, type = "comment"}, -- Multiline comment
    {pattern = {"#", "\n"}, type = "comment"}, -- Single line comment
    {pattern = "::%f[%w]", type = "operator"}, -- Typehint
    {regex = operators_regex_pattern, type = "operator" }, -- Operator
    {pattern = "%f[:]:%w+", type = "string"}, -- Symbol
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
  "for",  "abstract%s+type", "baremodule", "begin", "break", "catch", "const", "continue", "do", "else", "elseif", "end",
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
    files = {"%.jl$"}, headers = "^#!.*[ /]julia", comment = "#", patterns = patterns, symbols = symbols
}

-- Substitutions

local function substitute_symbol(_index, suggestion)
    local doc = core.active_view.doc
    local line, col = doc:get_selection()
    local line_text = doc:get_text(line, 1, line, col)

    -- Find the text to replace
    -- Try to find the last string of characters after a backslash
    -- Otherwise find the last string of characters after a whitespace character
    -- Otherwise return the entire line
    local partial = string.match(line_text, "(\\%S-)$") or
                        string.match(line_text, "%s(%S-)$") or line_text

    -- Get the text to replace it with
    local text = suggestion["info"]

    -- Perform the substitution
    doc:insert(line, col, text)
    doc:remove(line, col, line, col - #partial)
    doc:set_selection(line, col + #text - #partial)

    -- Return true because the substitution has already happened
    return true
end

local symbols = {}

for name, data in pairs(substitutions) do
    symbols[name] = {        ["info"] = data["character"], ["desc"] = data["name"], ["onselect"] = substitute_symbol    }
end

autocomplete.add {name = "julia", items = symbols}
