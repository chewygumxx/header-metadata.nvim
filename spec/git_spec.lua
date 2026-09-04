#!/usr/bin/env lua
-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only
-- luacheck: globals vim describe it assert before_each after_each

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/spec/git_spec.lua
--
--

--
-- These shell out to a real, throwaway git repo per test rather than
-- mocking vim.system: git.lua has no injection point for a fake git
-- binary, and the behavior under test (regex matching against real
-- `git remote`/`git rev-parse` output) is exactly what a mock would paper
-- over.
--

local git = require("header-metadata.git")

describe("git", function()
    local tmp

    before_each(function()
        tmp = vim.fn.tempname()
        vim.fn.mkdir(tmp, "p")
        vim.system({ "git", "-C", tmp, "init", "-q" }):wait()
    end)

    after_each(function()
        vim.fn.delete(tmp, "rf")
    end)

    describe("path", function()
        it("returns a repo-relative path prefixed with ':' for a file inside a repo", function()
            -- git -C requires the directory to exist, even though git.path
            -- itself doesn't care whether the file does.
            vim.fn.mkdir(tmp .. "/sub", "p")
            local result = git.path(tmp .. "/sub/file.lua")
            assert.equals(":/sub/file.lua", result)
        end)

        it("falls back to a tilde-collapsed absolute path outside any repo", function()
            local file   = tmp .. "-not-a-repo/file.lua"
            local result = git.path(file)
            assert.equals(vim.fn.fnamemodify(file, ":~"), result)
        end)
    end)

    describe("slug", function()
        it("extracts owner/repo from a matching origin url", function()
            vim.system({
                "git",
                "-C",
                tmp,
                "remote",
                "add",
                "origin",
                "https://github.com/chewygumxx/header-metadata.nvim.git",
            }):wait()
            local result = git.slug(tmp .. "/file.lua")
            assert.equals("chewygumxx/header-metadata.nvim", result)
        end)

        it("returns nil when the origin url has no owner/repo segment", function()
            vim.system({ "git", "-C", tmp, "remote", "add", "origin", "https://example.com/" }):wait()
            local result = git.slug(tmp .. "/file.lua")
            assert.is_nil(result)
        end)

        it("returns nil when there is no origin remote at all", function()
            local result = git.slug(tmp .. "/file.lua")
            assert.is_nil(result)
        end)
    end)
end)
