vim.cmd([[
	set spell
"	set scrolloff=29
	set number
	set relativenumber
	set hidden
	colorscheme gruvbox
	set clipboard=unnamedplus
	set undofile
	set undodir=/home/devanandpa/.config/nvim/undo/
	silent! so run.vim
	]])
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
keymap("n", "q", ":qa!<CR>", opts)
keymap("n", "w", ":w<CR>", opts)
keymap("n", "<Down>", "<Down>zz",opts)
keymap("n", "<Up>", "<Up>zz",opts)
keymap("n", "j", "jzz",opts)
keymap("n", "G", "Gzz",opts)
--keymap("i","<C-e>","<C-o>:r !emoji.sh -p<CR>",opts)
