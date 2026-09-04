-- vim:set expandtab shiftwidth=4 filetype=lua:
-- SPDX-License-Identifier: GPL-3.0-only

--
--
-- ~chewygumxx/header-metadata.nvim.git
-- ::: :/header-metadata.nvim-scm-1.rockspec
--
--

rockspec_format = "3.0"
package         = "header-metadata.nvim"
version         = "scm-1"

source = {
    url = "git+https://github.com/chewygumxx/header-metadata.nvim.git",
}

description = {
    summary  = "Templated header/banner insertion for new buffers.",
    detailed = [[
        A Neovim plugin that prepends new buffers with a templated header:
        a vim modeline line, an optional license line, and a git slug/path
        block, plus shebang resolution for shell/interpreter filetypes.
    ]],
    homepage = "https://github.com/chewygumxx/header-metadata.nvim",
    license  = "GPL-3.0-only",
}

dependencies = {
    "lua >= 5.1",
}

test_dependencies = {
    "nlua",
}

build = {
    type = "builtin",
}
