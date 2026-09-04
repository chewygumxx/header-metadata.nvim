#!/bin/false
-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only
-- luacheck: globals vim

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/lua/header-metadata/shebang.lua
--
--

--
-- Helper functions for shebang resolution
--

local M = {}

---@param file string
---@param buf  number
---@param opt  { ft: string?, source_dirs: string[]?, shebangs: table<string, string>? }
---@return string
M.get = function(file, buf, opt)
    file = file or vim.fn.expand("%")
    buf  = buf or 0
    opt  = opt or {}

    local ft          = opt.ft or vim.bo[buf].filetype
    local source_dirs = opt.source_dirs or {}
    local shebangs    = opt.shebangs or {}

    -- If within source directory, not intended for execution
    local path = vim.fn.fnamemodify(file, ":~:h")
    for _, dir in ipairs(source_dirs) do
        if path:find(dir .. "/", 1, true) == 1 then
            return "#!/bin/false"
        end
    end

    return shebangs[ft]
end

return M
