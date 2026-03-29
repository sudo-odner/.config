return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        terminal_colors = true,
        overrides = {
          -- Настраиваем внешний вид окон Blink (чтобы были рамки и правильный фон)
          BlinkCmpMenu = { link = "NormalFloat" },
          BlinkCmpMenuBorder = { link = "FloatBorder" },
          BlinkCmpDoc = { link = "NormalFloat" },
          BlinkCmpDocBorder = { link = "FloatBorder" },
          BlinkCmpSignatureHelp = { link = "NormalFloat" },
          BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
          -- Делаем плавающие окна чуть более выразительными
          FloatBorder = { fg = "#ebdbb2" },
        },
      })
      vim.cmd("colorscheme gruvbox")
    end,
  },
}
