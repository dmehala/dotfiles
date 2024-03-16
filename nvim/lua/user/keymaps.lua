local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- alias
local keymap = vim.api.nvim_set_keymap

-- keymapping
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   n = normal mode
--   i = insert mode
--   v = visual mode
--   x = visual block mode
--   t = term mode
--   c = command mode

-- Better window navigation
local tmux_map = { h = "L", j = "D", k = "U", l = "R" }

local function tmux_move(direction)
  -- tmux select pane
  local tmux_direction = tmux_map[direction]
  vim.cmd([[silent exec "!tmux selectp -]] .. tmux_direction .. [["]])
end

function move_window(direction)
  -- Try to move to vim split
  local win_num_before = vim.fn.winnr()
  vim.cmd([[execute "wincmd ]] .. direction .. [["]])
  if vim.fn.winnr() == win_num_before then
    -- If the command did nothing, that means the current split
    -- is at the edge and we need to select the tmux pane
    tmux_move(direction)
  end
end

keymap("n", "<C-h>", "<cmd>lua move_window('h')<cr>", opts)
keymap("n", "<C-j>", "<cmd>lua move_window('j')<cr>", opts)
keymap("n", "<C-k>", "<cmd>lua move_window('k')<cr>", opts)
keymap("n", "<C-l>", "<cmd>lua move_window('l')<cr>", opts)

-- Fallback
-- keymap("n", "<C-h>", "<C-w>h", opts)
-- keymap("n", "<C-j>", "<C-w>j", opts)
-- keymap("n", "<C-k>", "<C-w>k", opts)
-- keymap("n", "<C-l>", "<C-w>l", opts)

-- not working? :'(
keymap("n", "<leader>e", ":Neotree toggle<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>w", ":Bdelete<CR>", opts)

-- Remove highlighting after search
keymap("n", "<esc>", ":noh<CR><esc>", opts)

-- Visual mode
-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==gi", opts)
keymap("v", "<A-k>", ":m .-2<CR>==gi", opts)
keymap("v", "p", '"_dP', opts)

-- Visual indent stay in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Plugins
keymap("n", "ff", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "fg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<a-o>", ":ClangdSwitchSourceHeader<cr>", opts)
