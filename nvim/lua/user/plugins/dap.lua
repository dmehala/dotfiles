local dap = require("dap")
local dap_view = require("dap-view")
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

local function start_with_configuration()
	-- Wrote before I found `telescope-ui-select` ><.
	local configuration_picker = function(opts, configurations)
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		opts = opts or {}

		pickers
			.new(opts, {
				finder = finders.new_table({
					results = configurations,
					entry_maker = function(entry)
						return {
							value = entry,
							display = entry[1],
							ordinal = entry[1],
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(bufnr, _)
					actions.select_default:replace(function()
						actions.close(bufnr)
						local selection = action_state.get_selected_entry()
						dap.run(selection.value[2], {})
					end)

					return true
				end,
			})
			:find()
	end

	local config_path = ".vscode/launch.json"
	if vim.fn.filereadable(config_path) ~= 1 then
		vim.notify(config_path .. " not found. Can't launch the debugger.", vim.log.levels.ERROR)
		return
	end

	local config_content = table.concat(vim.fn.readfile(config_path), "\n")
	local j = vim.json.decode(json.json_strip_comments(config_content))

	local configurations = {}
	for _, cf in ipairs(j.configurations) do
		table.insert(configurations, { cf.name, cf })
	end

	-- TODO: Handle when launch.json is empty
	configuration_picker(require("telescope.themes").get_dropdown({}), configurations)
end

local function set_keymaps()
	vim.keymap.set("n", "<F5>", dap.continue, {})
	vim.keymap.set("n", "<F10>", dap.step_over, {})
	vim.keymap.set("n", "<F11>", dap.step_into, {})
	vim.keymap.set("n", "<F12>", dap.step_out, {})
	vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, {})
	vim.keymap.set("n", "<Leader>B", dap.set_breakpoint, {})
	vim.keymap.set("n", "<Leader>w", dap_view.add_expr, {})

	-- Telescope
	local telescope_dap = require("telescope").extensions.dap
	vim.keymap.set("n", "fb", telescope_dap.list_breakpoints, {})
	vim.keymap.set("n", "fc", telescope_dap.frames, {})
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

	dap.listeners.before.attach.dapui_config = dap_view.open
	dap.listeners.before.launch.dapui_config = dap_view.open
	dap.listeners.before.event_terminated.dapui_config = function()
		dap_view.close(true)
	end
	dap.listeners.before.event_exited.dapui_config = function()
		dap_view.close(true)
	end

	require("nvim-dap-virtual-text").setup()
end

return {
	setup = setup,
}
