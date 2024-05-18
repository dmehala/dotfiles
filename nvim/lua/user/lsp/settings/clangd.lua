local common = require("user.lsp.common")

local function clangd_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<a-o>", ":ClangdSwitchSourceHeader<cr>", opts)
end

local setup = {
	cmd = { "clangd", "--header-insertion=never" },
	capabilities = common.capabilities,
	on_attach = function(client, bufnr)
		common.on_attach(client, bufnr)
		clangd_keymaps(bufnr)
	end,
	inlayHints = {
		includeInlayEnumMemberValueHints = true,
		includeInlayFunctionLikeReturnTypeHints = true,
		includeInlayFunctionParameterTypeHints = true,
		includeInlayParameterNameHints = "all",
		includeInlayParameterNameHintsWhenArgumentMatchesName = true,
		includeInlayPropertyDeclarationTypeHints = true,
		includeInlayVariableTypeHints = true,
	},
}

return setup
