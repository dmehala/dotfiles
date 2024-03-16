local is_loaded, mason = pcall(require, "mason")
if not is_loaded then
  print "Failed to load mason"
  return
end

mason.setup()

-- Configure mason-lspconfig
local lsp_is_loaded, mason_lspconfig = pcall(require, "mason-lspconfig")
if not lsp_is_loaded then
  print "Failed to load mason-lspconfig"
  return
end

mason_lspconfig.setup {
  ensure_installed = { "lua_ls" }
}
