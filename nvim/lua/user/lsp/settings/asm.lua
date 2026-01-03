local common
return {
	capabilities = common.capabilities,
	on_attach = common.on_attach,
	filetypes = { "asm", "s", "S" },
}
