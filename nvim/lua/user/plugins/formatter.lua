local is_loaded, formatter = pcall(require, "formatter")
if not is_loaded then
  print "Failed to load formatter plugin"
  return
end

local util = require("formatter.util")

-- TBD: write a function that look for the closest .clang-format file
local function get_workspace_style()
  return util.get_current_buffer_file_path()
end

formatter.setup {
  logging = true,
  log_level = vim.log.levels.TRACE,
  filetype = {
    cpp = {
      require("formatter.filetypes.python").black
    },

    python = {
      require("formatter.filetypes.python").black
    },

    -- Formatter for any filetype
    ["*"] = {
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}

-- Add keymap
local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

-- keymap("n", "<leader>f", ":Format<cr>", opts)
-- keymap("n", "<leader>F", ":FormatWrite<cr>", opts)

-- Format after save
-- Do not work
vim.cmd [[
  augroup format_auto
    autocmd!
    autocmd BufWritePost * FormatWrite
  augroup end
]]
