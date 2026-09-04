#!/usr/bin/env lua
-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only
-- luacheck: globals vim describe it assert

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/spec/modeline_spec.lua
--
--

local modeline = require("header-metadata.modeline")

describe("modeline.base", function()
    it("renders et/sw/ft/commentstring when explicitly provided", function()
        local out = modeline.base({ et = true, sw = 4, ft = "lua", commentstring = "-- %s" })
        assert.equals("-- vim:set expandtab shiftwidth=4 filetype=lua:", out)
    end)

    it("omits expandtab when et is false", function()
        local out = modeline.base({ et = false, sw = 4, ft = "lua", commentstring = "%s" })
        assert.equals("vim:set shiftwidth=4 filetype=lua:", out)
    end)

    it("omits shiftwidth when sw is false", function()
        local out = modeline.base({ et = true, sw = false, ft = "lua", commentstring = "%s" })
        assert.equals("vim:set expandtab filetype=lua:", out)
    end)

    it("omits filetype when ft is an empty string", function()
        local out = modeline.base({ et = true, sw = 4, ft = "", commentstring = "%s" })
        assert.equals("vim:set expandtab shiftwidth=4:", out)
    end)

    it("appends extra :set options via append", function()
        local out = modeline.base(
            { et = true, sw = 4, ft = "lua", append = " foldmethod=marker", commentstring = "%s" }
        )
        assert.equals("vim:set expandtab shiftwidth=4 filetype=lua foldmethod=marker:", out)
    end)

    it("defaults commentstring to %s when unset and the buffer has none", function()
        local buf                 = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].commentstring = ""
        local out                 = modeline.base({ buf = buf, et = true, sw = 4, ft = "lua" })
        assert.equals("vim:set expandtab shiftwidth=4 filetype=lua:", out)
    end)

    it("falls back to buffer-local et/sw/ft when not given explicitly", function()
        local buf              = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].expandtab  = true
        vim.bo[buf].shiftwidth = 2
        vim.bo[buf].filetype   = "lua"
        local out              = modeline.base({ buf = buf, commentstring = "%s" })
        assert.equals("vim:set expandtab shiftwidth=2 filetype=lua:", out)
    end)
end)
