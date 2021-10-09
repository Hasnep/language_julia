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
    files = {"%.jl$"}, headers = "^#!.*[ /]julia", comment = "#", patterns = patterns, symbols = symbols
}

local on_text_input = RootView.on_text_input
local on_text_remove = Doc.remove
local update = RootView.update
local draw = RootView.draw

RootView.on_text_input = function(...)
    on_text_input(...)
    -- core.log("aaaaa")
end

Doc.remove = function(self, line1, col1, line2, col2)
    on_text_remove(self, line1, col1, line2, col2)
    -- core.log("bbbbb")
end

-- RootView.update = function(...)
--    update(...)
--     core.log("cccccc")
-- end

-- RootView.draw = function(...)
--     draw(...)
--     core.log("dddddd")
-- end

command.add("core.docview", {
    ["julia:substitute"] = function()
        local doc = core.active_view.doc
        local line, col = doc:get_selection()
        local line_text = doc:get_text(line, 0, line, col)
        local text_to_substitute = string.match(line_text, "(\\.-)$")
        core.log(text_to_substitute)
        local text = "α"
        core.log("remove")
        doc:remove(line, col, line, col - #text_to_substitute)
        core.log("insert")
        doc:insert(line, col, text)
        core.log("set_selection")
        doc:set_selection(line, col + #text - #text_to_substitute)
    end
})

keymap.add {["ctrl+shift+\\"] = "julia:substitute"}
