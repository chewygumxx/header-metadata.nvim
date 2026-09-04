#!/bin/false
-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only
-- luacheck: globals vim

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/lua/header-metadata/modeline.lua
--
--

--
-- Helper functions for vim modeline resolution
--

local M = {}

-- Neovim-native nil-coalescing; vim.F.if_nil() pre-0.13, vim.nonnil()
-- from 0.13 onward.
local nonnil = vim.nonnil or vim.F.if_nil

M.base = function(opt)
    opt       = opt or {}
    local buf = opt.buf or 0
    -- The following three options may be set false for elision
    local et = nonnil(opt.et, opt.expandtab, vim.bo[buf].expandtab)
    local sw = nonnil(opt.sw, opt.shiftwidth, vim.bo[buf].shiftwidth, 4)
    local ft = nonnil(opt.ft, opt.filetype, vim.bo[buf].filetype)
    -- For additional :set options not provided for
    local append        = opt.append
    local commentstring = opt.commentstring or (vim.bo[buf].commentstring ~= "" and vim.bo[buf].commentstring) or "%s"

    local modeline = "vim:set"
    modeline       = modeline .. (et and " expandtab" or "")
    modeline       = modeline .. (sw and " shiftwidth=" .. tostring(sw) or "")
    modeline       = modeline .. (ft and ft ~= "" and " filetype=" .. ft or "")
    modeline       = modeline .. (append or "")

    modeline = modeline .. ":"

    return string.format(commentstring, modeline)
end

return M
