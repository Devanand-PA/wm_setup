vim.cmd([[
	set spell
"	set scrolloff=29
	set number
	set relativenumber
	set hidden
	colorscheme nord
	set clipboard=unnamedplus
	set undofile
	set undodir=$HOME/.config/nvim/undo/
	]])
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "q", ":qa!<CR>", opts)
keymap("n", "w", ":w<CR>", opts)
keymap("n", "<Down>", "<Down>zz",opts)
keymap("n", "<Up>", "<Up>zz",opts)
keymap("n", "j", "jzz",opts)
keymap("n", "G", "Gzz",opts)
function RunFileType()
	local filetype = vim.bo.filetype
	if filetype == "lua"
	then
		print("lua")
	elseif filetype == "python"
	then
		vim.cmd([[
		write
		silent! !st -e python3 % 
		]])
	elseif filetype == "tex"
	then
		vim.cmd([[
		write
		silent! !pdflatex % 
		silent! !biber % 
		silent! !pdflatex %
		]])
	end
end

vim.api.nvim_set_keymap('n','<C-s>', ':lua RunFileType()<CR>',opts)
