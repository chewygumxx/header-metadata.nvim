#!/usr/bin/env lua
-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only
-- luacheck: globals vim describe it assert

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/spec/shebang_spec.lua
--
--

local shebang = require("header-metadata.shebang")

describe("shebang.get", function()
    local shebangs = { lua = "#!/usr/bin/env lua" }

    it("returns nil for a filetype with no configured shebang", function()
        local result = shebang.get("/tmp/x.rb", 0, { ft = "ruby", shebangs = shebangs })
        assert.is_nil(result)
    end)

    it("returns the configured shebang for a matching filetype", function()
        local result = shebang.get("/tmp/x.lua", 0, { ft = "lua", shebangs = shebangs })
        assert.equals("#!/usr/bin/env lua", result)
    end)

    it("returns #!/bin/false for a file living exactly at a configured source_dir", function()
        local result = shebang.get("/tmp/header-metadata-spec/exact.lua", 0, {
            ft          = "lua",
            source_dirs = { "/tmp/header-metadata-spec" },
            shebangs    = shebangs,
        })
        assert.equals("#!/bin/false", result)
    end)

    it("returns #!/bin/false for a file in a subdirectory of a configured source_dir", function()
        local result = shebang.get("/tmp/header-metadata-spec/sub/nested.lua", 0, {
            ft          = "lua",
            source_dirs = { "/tmp/header-metadata-spec" },
            shebangs    = shebangs,
        })
        assert.equals("#!/bin/false", result)
    end)

    it("does not match a sibling directory that merely shares a prefix", function()
        local result = shebang.get("/tmp/header-metadata-spec-other/x.lua", 0, {
            ft          = "lua",
            source_dirs = { "/tmp/header-metadata-spec" },
            shebangs    = shebangs,
        })
        assert.equals("#!/usr/bin/env lua", result)
    end)
end)
