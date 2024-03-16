local theme = "sonokai"

local is_loaded, _ = pcall(vim.cmd, "colorscheme " .. theme)
if not is_loaded then
  vim.notify("colorscheme " .. theme .. "not found. Fallback to the default colorscheme")
  vim.cmd "colorscheme default"
end
