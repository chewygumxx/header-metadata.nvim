#!/usr/bin/env lua
-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only
-- luacheck: globals vim

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/plugin/header-metadata.lua
--
--

--
-- Auto-init entrypoint: lets the plugin configure itself from
-- vim.g.header_metadata without requiring an explicit setup() call,
-- per the "Initialization" section of the Neovim best-practices doc.
-- Consumers who call require("header-metadata").setup(opts) explicitly
-- (and never touch vim.g.header_metadata) are unaffected: this script
-- only acts when vim.g.header_metadata has been set.
--

if vim.g.loaded_header_metadata then
    return
end
vim.g.loaded_header_metadata = true

if vim.g.header_metadata ~= nil then
    require("header-metadata")._auto_init()
end
