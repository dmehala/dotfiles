require 'nvim-treesitter.install'.compilers = { "clang" }

local is_loaded, treesitter = pcall(require, "nvim-treesitter.configs")
if not is_loaded then
  print "Failed to load nvim-treesitter"
  return
end

treesitter.setup {
  ensure_installed = { "lua", "cpp" },
  auto_install = false,
  highlight = {
    enable = true
  },
  rainbow = {
    enable = true,
    query = 'rainbow-parens',
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true
  }
}

-- local rainbow_delimiters = require 'rainbow-delimiters'
-- require('rainbow-delimiters.setup').setup {
--   strategy = {
--         [''] = rainbow_delimiters.strategy['global'],
--         vim = rainbow_delimiters.strategy['local'],
--     },
--     query = {
--         [''] = 'rainbow-delimiters',
--         lua = 'rainbow-blocks',
--     },
--     highlight = {
--         'RainbowDelimiterRed',
--         'RainbowDelimiterYellow',
--         'RainbowDelimiterBlue',
--         'RainbowDelimiterOrange',
--         'RainbowDelimiterGreen',
--         'RainbowDelimiterViolet',
--         'RainbowDelimiterCyan',
--     },
-- }
