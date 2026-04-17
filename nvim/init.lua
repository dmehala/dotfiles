-- General
require("user.keymaps")
require("user.options")

-- Enables project-local configuration
vim.o.exrc = true

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
	-- UI
	{
		"sainnhe/sonokai",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			-- load the colorscheme here
			vim.g.sonokai_style = "atlantis"
			-- vim.g.sonokai_style = "andromeda"
			vim.cmd.colorscheme("sonokai")
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			-- load the colorscheme here
			-- vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		-- dependencies = { { "echasnovski/mini.icons", opts = {} } },
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
		config = function()
			local oil_opts = require("user.plugins.oil")
			require("oil").setup(oil_opts)
		end,
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			require("outline").setup({
				outline_window = {
					position = "left",
					auto_close = true,
					width = 20,
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local lualine_opts = require("user.plugins.lualine")
			require("lualine").setup(lualine_opts)
		end,
	},
	{
		"akinsho/bufferline.nvim",
		--version = "*",
		branch = "main",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local bufferline_opts = require("user.plugins.bufferline")
			require("bufferline").setup(bufferline_opts)
		end,
	},
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			local gitsigns_opts = require("user.plugins.gitsigns")
			require("gitsigns").setup(gitsigns_opts)
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		config = function()
			local cfg = require("user.plugins.ufo")
			require("ufo").setup(cfg)
		end,
	},
	-- Lang/LSP
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		config = function()
			local treesitter_opts = require("user.plugins.treesitter")
			require("nvim-treesitter.install").prefer_git = false
			require("nvim-treesitter").setup(treesitter_opts)
		end,
		init = function()
			local ensureInstalled = {
				"lua",
				"cpp",
				"zig",
			}
			local alreadyInstalled = require("nvim-treesitter.config").get_installed()
			local parsersToInstall = vim.iter(ensureInstalled)
				:filter(function(parser)
					return not vim.tbl_contains(alreadyInstalled, parser)
				end)
				:totable()
			require("nvim-treesitter").install(parsersToInstall)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					-- Enable treesitter highlighting and disable regex syntax
					pcall(vim.treesitter.start)
					-- Enable treesitter-based indentation
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
	{
		"bezhermoso/tree-sitter-ghostty",
		build = "make nvim_install",
		ft = "ghostty",
	},
	{
		"williamboman/mason.nvim",
		version = "^1.0.0",
		dependencies = {
			{ "williamboman/mason-lspconfig.nvim", version = "^1.0.0" },
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp",
		},
		config = function()
			require("user.lsp")
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = {
			keymap = {
				preset = "none",
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-space>"] = { "show", "fallback" },
				["<C-d>"] = { "show_documentation", "hide_signature", "fallback" },
				["<CR>"] = { "accept", "fallback" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = { documentation = { auto_show = false } },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			local conform_opts = require("user.plugins.conform")
			require("conform").setup(conform_opts)
		end,
	},
	-- Movements
	{
		"echasnovski/mini.surround",
		version = "*",
		config = function()
			local opts = require("user.plugins.mini-surround")
			require("mini.surround").setup(opts)
		end,
	},
	-- Others
	{
		"famiu/bufdelete.nvim",
		event = "VeryLazy",
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "nvim-mini/mini.icons" },
		opts = {},
	},
	-- DAP
	{
		"mfussenegger/nvim-dap",
		tag = "0.9.0",
		dependencies = {
			"igorlfs/nvim-dap-view",
			"theHamsta/nvim-dap-virtual-text",
			"leoluz/nvim-dap-go",
			"julianolf/nvim-dap-lldb",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("user.plugins.dap").setup()
		end,
	},
}

require("lazy").setup(plugins)
