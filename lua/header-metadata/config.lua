#!/bin/false
-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only
-- luacheck: globals vim

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/lua/header-metadata/config.lua
--
--

--
-- Config schema (declarations) and defaults (values), kept separate so
-- lua-language-server can flag missing/misspelled fields in user opts
-- without also complaining about the internal defaults table.
--

---@class header-metadata.PathRule
---@field match string   Plain-text prefix to match against the resolved path (e.g. "~/.config")
---@field slug  string   Slug to use for this path, in "owner/repo" form
---@field gsub  string[] { from, to } pair passed to string.gsub on the path

---@class header-metadata.Config
---@field command_name string                     User command name registered by setup()
---@field autocmd      boolean                    Auto-insert on BufNewFile/FileType
---@field license      string | nil               License line text; nil omits the line entirely
---@field shebangs     table<string, string>      filetype -> shebang line
---@field source_dirs  string[]                   Tilde-relative dir paths (e.g. "~/.config/nvim/lua") that force "#!/bin/false"
---@field path_rules   header-metadata.PathRule[] Repo-relative path/slug rewrite rules

local M = {}

---@type header-metadata.Config
M.defaults = {
    command_name = "InsertHeader",
    autocmd      = false,
    license      = nil,
    shebangs     = {
        sh     = "#!/bin/sh",
        bash   = "#!/usr/bin/env bash",
        lua    = "#!/usr/bin/env lua",
        python = "#!/usr/bin/env python3",
        zsh    = "#!/usr/bin/env zsh",
    },
    source_dirs  = {},
    path_rules   = {},
}

---@param cfg header-metadata.Config
---@return boolean ok
---@return string | nil err
function M.validate(cfg)
    local ok, err = pcall(vim.validate, {
        command_name = { cfg.command_name, "string" },
        autocmd      = { cfg.autocmd, "boolean" },
        license      = { cfg.license, { "string", "nil" } },
        shebangs     = { cfg.shebangs, "table" },
        source_dirs  = { cfg.source_dirs, "table" },
        path_rules   = { cfg.path_rules, "table" },
    })
    if not ok then
        return false, "header-metadata.setup: " .. err
    end
    return true, nil
end

return M
