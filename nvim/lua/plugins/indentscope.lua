-- lua/plugins/indentscope.lua
return {
    "echasnovski/mini.indentscope",
    opts = {
        symbol = "│",
        draw = {
            delay = 0,
            animation = function(_, _) return 10 end,
        },
    },
}
