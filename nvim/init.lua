-- set XDG_CONFIG_HOME
require "user.options"
require "user.keymaps"
require "user.colorscheme"
require "user.plugins"
require "user.plugins.neo-tree"
require "user.plugins.gitsigns"
require "user.plugins.cmp"
require "user.plugins.buffer"
require "user.plugins.toggleterm"
require "user.plugins.treesitter"
require "user.plugins.lualine"
require "user.plugins.comment"
require "user.plugins.alpha"
require "user.plugins.wilder"
-- require "user.plugins.formatter"
-- require "user.plugins.mini-bracketed"
require "user.lsp"

-- conform
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "black" },
    -- Use a sub-list to run only the first available formatter
    -- javascript = { { "prettierd", "prettier" } },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true
  },
})

-- workaround for leader delay
vim.cmd "set notimeout notimeout"
