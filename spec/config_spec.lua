#!/usr/bin/env lua
-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only
-- luacheck: globals vim describe it assert

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/spec/config_spec.lua
--
--

local config = require("header-metadata.config")

describe("config.validate", function()
    it("accepts the built-in defaults", function()
        local ok, err = config.validate(config.defaults)
        assert.is_true(ok)
        assert.is_nil(err)
    end)

    it("accepts a fully-specified valid config", function()
        local ok, err = config.validate({
            command_name = "InsertHeader",
            autocmd      = true,
            license      = "SPDX-License-Identifier: GPL-3.0-only",
            shebangs     = { lua = "#!/usr/bin/env lua" },
            source_dirs  = { "~/dev/header-metadata.nvim" },
            path_rules   = { { match = "~/.config", slug = "a/b", gsub = { "^~", "~" } } },
        })
        assert.is_true(ok)
        assert.is_nil(err)
    end)

    local invalid_cases = {
        command_name = 1,
        autocmd      = "yes",
        license      = 42,
        shebangs     = "not-a-table",
        source_dirs  = 1,
        path_rules   = "not-a-table",
    }

    for field, bad_value in pairs(invalid_cases) do
        it("rejects a non-conforming " .. field, function()
            local cfg     = vim.tbl_extend("force", vim.deepcopy(config.defaults), { [field] = bad_value })
            local ok, err = config.validate(cfg)
            assert.is_false(ok)
            assert.is_string(err)
            assert.matches("^header%-metadata%.setup: ", err)
        end)
    end
end)
