#!/bin/false
-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only
-- luacheck: globals vim

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/lua/header-metadata/health.lua
--
--

local M = {}

M.check = function()
    vim.health.start("header-metadata")

    if vim.fn.executable("git") == 1 then
        vim.health.ok("git found on PATH")
    else
        vim.health.warn("git not found on PATH -- slug/path resolution in git.lua will no-op")
    end

    local config_mod = require("header-metadata.config")
    local ok, err    = config_mod.validate(require("header-metadata").config)
    if ok then
        vim.health.ok("current config is valid")
    else
        vim.health.error(err)
    end
end

return M
