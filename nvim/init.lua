-- General
require("user.keymaps")
require("user.options")

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
			vim.cmd([[colorscheme sonokai]])
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local markview_opts = require("user.plugins.markview")
			require("markview").setup(markview_opts)
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
					width = 10,
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
		"lewis6991/gitsigns.nvim",
		lazy = true,
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
			require("ufo").setup({
				provider_selector = function(bufnr, filetype, buftype)
					return { "lsp", "indent" }
				end,
			})
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	-- Lang/LSP
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			local treesitter_opts = require("user.plugins.treesitter")
			require("nvim-treesitter.install").prefer_git = false
			require("nvim-treesitter.configs").setup(treesitter_opts)
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("user.lsp")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
		config = function()
			local cmp_opts = require("user.plugins.cmp")
			require("cmp").setup(cmp_opts)
		end,
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
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
}

-- TODO:

-- Maybe:
-- use "L3MON4D3/LuaSnip"
-- use { "nathom/tmux.nvim" }
-- use "sindrets/diffview.nvim"

require("lazy").setup(plugins)
