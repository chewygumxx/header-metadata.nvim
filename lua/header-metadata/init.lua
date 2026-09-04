#!/usr/bin/env lua
-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only
-- luacheck: globals vim

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/lua/header-metadata/init.lua
--
--

--
-- [Neovim Plugin] Handles bespoke-formatted header metadata
--

local M = {}

---@type header-metadata.Config
M.config = require("header-metadata.config").defaults

local trim_lines = function(lines)
    for i = 1, #lines, 1 do
        lines[i] = lines[i]:gsub("[ \t]+$", "")
    end
    return lines
end

---@param file string | nil
---@param buf  number | nil
---@param opt  { commentstring: string? } | nil
M.insert = function(file, buf, opt)
    local modeline = require("header-metadata.modeline")
    local shebang  = require("header-metadata.shebang")
    local git      = require("header-metadata.git")

    file = file or vim.fn.expand("%")
    buf  = buf or 0
    opt  = opt or {}

    local commentstring = opt.commentstring or vim.bo[buf].commentstring
    if commentstring == "" then
        return
    end

    local lines = {}

    -- Shebang
    lines[#lines + 1] = shebang.get(file, buf, {
        source_dirs = M.config.source_dirs,
        shebangs    = M.config.shebangs,
    })

    -- Modeline
    lines[#lines + 1] = modeline.base({
        et = true,
        sw = 4,
        ft = vim.bo[buf].filetype,
        commentstring = commentstring,
    })

    -- License
    if M.config.license then
        lines[#lines + 1] = string.format(commentstring, M.config.license)
    end

    -- (Slug and) Path
    local slug
    local path = git.path(file)
    if path:find(":", 1, true) == 1 then
        slug = git.slug(file)
    end
    for _, rule in ipairs(M.config.path_rules or {}) do
        if path:find(rule.match, 1, true) == 1 then
            slug = rule.slug
            path = path:gsub(rule.gsub[1], rule.gsub[2])
            break
        end
    end

    if path then
        lines[#lines + 1] = ""
        lines[#lines + 1] = string.format(commentstring, "")
        lines[#lines + 1] = string.format(commentstring, "")
        if slug then
            lines[#lines + 1] = string.format(commentstring, "~" .. slug .. ".git")
            lines[#lines + 1] = string.format(commentstring, "::: " .. path)
        else
            lines[#lines + 1] = string.format(commentstring, path)
        end
        lines[#lines + 1] = string.format(commentstring, "")
        lines[#lines + 1] = string.format(commentstring, "")
    end

    -- Trailing Newline
    lines[#lines + 1] = ""

    vim.api.nvim_buf_set_lines(buf, 0, 0, false, trim_lines(lines))
end

M.command = function()
    M.insert(vim.fn.expand("%"), vim.api.nvim_get_current_buf())
end

M._autocmd = function()
    vim.api.nvim_create_autocmd("BufNewFile", {
        group = vim.api.nvim_create_augroup("header-metadata.mark_pending", { clear = true }),
        desc = "Designates new file buffer for pending header insertion.",
        callback = function(opts)
            vim.b[opts.buf].header_metadata_pending = true
        end,
    })

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("header-metadata.apply_insert", { clear = true }),
        desc = "Inserts templated header into new file buffer once filetype is known.",
        callback = function(opts)
            if vim.b[opts.buf].header_metadata_pending then
                vim.b[opts.buf].header_metadata_pending = nil
                M.insert(opts.file, opts.buf)
            end
        end,
    })
end

---@param opts header-metadata.Config | nil
M.setup = function(opts)
    local config_mod = require("header-metadata.config")
    M.config         = vim.tbl_deep_extend("force", vim.deepcopy(config_mod.defaults), opts or {})

    local ok, err = config_mod.validate(M.config)
    if not ok then
        vim.notify(err, vim.log.levels.ERROR)
        return
    end

    if M.config.autocmd then
        M._autocmd()
    end

    vim.api.nvim_create_user_command(M.config.command_name, M.command, {
        desc = "Prepend buffer with a header, templated according to filepath and extension.",
    })
end

return M
