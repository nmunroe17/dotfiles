-- Claude Code integration for Neovim
-- Provides WebSocket connection to Claude Code CLI

return {
  "coder/claudecode.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("claudecode").setup({
      -- Auto-start the WebSocket server when Neovim opens
      auto_start = true,
      -- Port range for WebSocket server
      port_range = { min = 10000, max = 65535 },
      -- Log level for debugging
      log_level = "info",
      -- Terminal settings for Claude Code pane
      terminal = {
        split_side = "right",
        split_width_percentage = 0.4,
        provider = "native",
      },
      -- Diff settings
      diff_opts = {
        auto_close_on_accept = true,
        show_diff_stats = true,
      },
    })

    -- Keymaps for Claude Code
    local wk = require("which-key")
    wk.add({
      { "<leader>c", group = "Claude Code" },
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude", mode = { "n", "v" } },
      { "<leader>co", "<cmd>ClaudeCodeOpen<cr>", desc = "Open Claude Code" },
      { "<leader>ca", "<cmd>ClaudeCodeAdd<cr>", desc = "Add file to context", mode = { "n", "v" } },
    })
  end,
}
