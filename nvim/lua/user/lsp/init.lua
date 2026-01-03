local lspconfig_is_loaded, lspconfig = pcall(require, "lspconfig")
if not lspconfig_is_loaded then
	print("ERROR: Failed to load lspconfig")
	return
end

local mason_is_loaded, mason = pcall(require, "mason")
if not mason_is_loaded then
	print("ERROR: Failed to load mason")
	return
end

local masonlsp_is_loaded, mason_lspconfig = pcall(require, "mason-lspconfig")
if not masonlsp_is_loaded then
	print("ERROR: Failed to load mason-lspconfig")
	return
end

mason.setup()

mason_lspconfig.setup({
	ensure_installed = { "lua_ls" },
})

local function setup_lsp()
	-- Diagnostic
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- disable virtual text
		virtual_text = false,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})

	vim.lsp.inlay_hint.enable(true)
end

setup_lsp()

local common = require("user.lsp.common")

local default_opts = {
	capabilities = common.capabilities,
	on_attach = common.on_attach,
}

-- Setup per language
-- NOTE: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local languages = {
	clangd = require("user.lsp.settings.clangd"),
	lua_ls = require("user.lsp.settings.lua_ls"),
	pyright = require("user.lsp.settings.pyright"),
	zls = require("user.lsp.settings.zls"),
	gopls = require("user.lsp.settings.gopls"),
	asm_lsp = default_opts,
}

for lang, opts in pairs(languages) do
	lspconfig[lang].setup(opts)
end
