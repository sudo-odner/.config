-- lua/plugins/bufdelete.lua: Better buffer deletion
return {
    "famiu/bufdelete.nvim",
    keys = {
        {
            "<leader>bd",
            function()
                require("bufdelete").bufdelete(0, false)
            end,
            desc = "Delete Buffer",
        },
    },
}
