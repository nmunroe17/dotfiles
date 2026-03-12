-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Restore default 's' (substitute) and move flash.nvim to 'gs'
vim.keymap.del({ "n", "x" }, "s")
vim.keymap.set({ "n", "x", "o" }, "gs", function()
  require("flash").jump()
end, { desc = "Flash" })
