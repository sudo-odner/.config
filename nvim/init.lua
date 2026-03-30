-- Basic
if vim.loader then
    vim.loader.enable()
end
require("core.options")
require("core.keymaps")
require("core.lazy")
