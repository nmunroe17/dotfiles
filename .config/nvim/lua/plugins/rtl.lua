-- RTL/SystemVerilog development support for LazyVim
-- LSP: svls (primary), verible-verilog-ls (formatting)
-- Treesitter: verilog, systemverilog

return {
  -- Treesitter parsers for SystemVerilog
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        "verilog",
      })
    end,
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- svls: Rust-based SystemVerilog language server (primary)
        svls = {
          cmd = { "svls" },
          filetypes = { "verilog" },
        },
        -- verible: Google's SV toolchain (formatting + lint)
        verible = {
          cmd = { "verible-verilog-ls" },
          filetypes = { "verilog" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("filelist.f", ".svlint.toml", ".git")(fname)
          end,
        },
      },
    },
  },

}
