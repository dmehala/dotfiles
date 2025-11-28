local dap = require("dap")
-- local dap_view = require("dap-view")
local json = require("plenary.json")

local function set_adapters()
	require("dap-go").setup()

	dap.adapters.lldb = {
		type = "executable",
		command = "codelldb",
	}
end

local function set_configurations()
	dap.configurations.lldb = {
		type = "lldb",
		name = "Attach Debugger",
		request = "attach",
		pid = "${command:pickProcess}",
	}
end

local function set_keymaps()
	vim.keymap.set("n", "<F5>", dap.continue, {})
	vim.keymap.set("n", "<F10>", dap.step_over, {})
	vim.keymap.set("n", "<F11>", dap.step_into, {})
	vim.keymap.set("n", "<F12>", dap.step_out, {})
	vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, {})
	vim.keymap.set("n", "<Leader>B", dap.set_breakpoint, {})
	-- vim.keymap.set("n", "<Leader>dw", dap_view.add_expr, {})

	-- Telescope
	-- local telescope_dap = require("telescope").extensions.dap
	-- vim.keymap.set("n", "fb", telescope_dap.list_breakpoints, {})
	-- vim.keymap.set("n", "fc", telescope_dap.frames, {})
end

local function setup()
	local vscode = require("dap.ext.vscode")
	local json = require("plenary.json")
	vscode.json_decode = function(str)
		return vim.json.decode(json.json_strip_comments(str))
	end

	set_adapters()
	set_configurations()
	set_keymaps()

	-- dap.listeners.before.attach.dapui_config = dap_view.open
	-- dap.listeners.before.launch.dapui_config = dap_view.open
	-- dap.listeners.before.event_terminated.dapui_config = function()
	-- 	dap_view.close(true)
	-- end
	-- dap.listeners.before.event_exited.dapui_config = function()
	-- 	dap_view.close(true)
	-- end

	require("nvim-dap-virtual-text").setup()
end

return {
	setup = setup,
}
