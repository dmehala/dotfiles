local common = require("user.lsp.common")

return {
	capabilities = common.capabilities,
	on_attach = function(client, bufnr)
		common.on_attach(client, bufnr)
	end,
	settings = {
		python = {
			analysis = {
				autoImport = false,
			},
		},
	},
}
