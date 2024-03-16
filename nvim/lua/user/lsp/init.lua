local lspconfig_is_loaded, lspconfig = pcall(require, "lspconfig")
if not lspconfig_is_loaded then
  print "ERROR: Failed to load lspconfig"
  return
end

local mason_is_loaded, mason = pcall(require, "mason")
if not mason_is_loaded then
  print "ERROR: Failed to load mason"
  return
end

-- Configure mason-lspconfig
local masonlsp_is_loaded, mason_lspconfig = pcall(require, "mason-lspconfig")
if not masonlsp_is_loaded then
  print "ERROR: Failed to load mason-lspconfig"
  return
end

-- Inlayhints are argument hints
local inlayhints_is_loaded, lsp_inlayhints = pcall(require, "lsp-inlayhints")
if not inlayhints_is_loaded then
  print "Failed to load lsp-inlayhints"
  return
end

local handler = require("user.lsp.handler")

mason.setup()

mason_lspconfig.setup {
  ensure_installed = { "lua_ls" }
}

lsp_inlayhints.setup {
  only_current_line = true
}

local common_opts = {
  on_attach = handler.on_attach,
  capabilities = handler.capabilities
}

-- Configure lua LSP
local lua_ls_settings = require("user.lsp.settings.lua_ls")
local lua_ls_opts = vim.tbl_deep_extend("force", lua_ls_settings, common_opts)

lspconfig.lua_ls.setup(lua_ls_opts)

-- Configure clangd LSP
local clangd_opts = require("user.lsp.settings.clangd")

lspconfig.clangd.setup {
  cmd = { "clangd", "--header-insertion=never" },
  on_attach = function(client, bufnr)
    handler.on_attach(client, bufnr)
    lsp_inlayhints.on_attach(client, bufnr)
    clangd_opts.set_keymaps(bufnr)
  end,

  capabilities = handler.capabilities
}

-- Configure pylint LSP
lspconfig.pyright.setup(common_opts)

-- Common
handler.setup()
