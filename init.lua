-- mod-version:2 -- lite-xl 2.0
local core = require "core"
local syntax = require "core.syntax"
local autocomplete = require "plugins.autocomplete"
local substitutions = require "plugins.language_julia.substitutions"
local patterns = require "plugins.language_julia.patterns"
local symbols = require "plugins.language_julia.symbols"

-- Syntax highlighting

syntax.add {
    files = {"%.jl$"},
    headers = "^#!.*[ /]julia",
    comment = "#",
    patterns = patterns,
    symbols = symbols
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
    local partial = string.match(line_text, "(\\%S-)$") or string.match(line_text, "%s(%S-)$") or line_text

    -- Get the text to replace it with
    local text = suggestion["info"]

    -- Perform the substitution
    doc:insert(line, col, text)
    doc:remove(line, col, line, col - #partial)
    doc:set_selection(line, col + #text - #partial)

    -- Return true because the substitution has already happened
    return true
end

local autocomplete_items = {}

for name, data in pairs(substitutions) do
    autocomplete_items[name] = {
        info = data["character"],
        desc = data["name"],
        onselect = substitute_symbol
    }
end

autocomplete.add {
    name = "julia",
    items = autocomplete_items
}
