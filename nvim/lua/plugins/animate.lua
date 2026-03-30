return {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = function()
        local animate = require("mini.animate")
        return {
            -- Плавный скролл (самое заметное)
            scroll = {
                enable = true,
                timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
            },
            -- Плавное движение курсора
            cursor = {
                enable = true,
                timing = animate.gen_timing.linear({ duration = 80, unit = "total" }),
            },
        }
    end,
}
