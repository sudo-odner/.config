-- lua/plugins/treesitter.lua For install and configuration nvim-treesitter
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({
            ensure_installed = {
                "vim",
                "bash",
                "lua",
                "go",
                "python",
                "typescript",
                "tsx",
                "html",
                "json",
                "yaml",
                "regex",
                "markdown",
                "markdown_inline"
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = false },
            auto_install = true,
        })
    end,
}
