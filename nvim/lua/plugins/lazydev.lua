-- lua/plugins/lazydev.lua For delete undefind global vim
return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        pts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
