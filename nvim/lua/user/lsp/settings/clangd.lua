local function clangd_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<a-o>", ":ClangdSwitchSourceHeader<cr>", opts)
end

local expose = {}
expose.set_keymaps = clangd_keymaps

return expose

