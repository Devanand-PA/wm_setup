vim.cmd([[
	set spell
"	set scrolloff=29
	set number
	set relativenumber
	set hidden
	"set background=dark
	colorscheme PaperColor
	set clipboard=unnamedplus
	set undofile
	set undodir=$HOME/.config/nvim/undo/
	call plug#begin()
	Plug 'preservim/nerdtree'
	Plug 'mbbill/undotree'
	Plug 'wfxr/minimap.vim'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'nvim-lua/plenary.nvim'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	call plug#end()
	let g:airline#extensions#tabline#enabled = 1
  	let g:airline#extensions#whitespace#enabled = 0
	let g:airline_theme='dark'
	let g:minimap_width = 10
	let g:minimap_auto_start = 0
	let g:minimap_auto_start_win_enter = 1
	nnoremap <C-T> 0y$/\V<c-r>"<cr>
	]])
homedir=os.getenv('HOME')
local PluginToggle = "<C-p>"
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local buffermap = "<C-b>"
keymap("n", "qr", "q", opts)
keymap("n", "q", "", opts)
keymap("n", "qa", ":qa!<CR>", opts)
keymap("n", "qq", ":bd<CR>", opts)
keymap("n", "wa", ":w<CR>", opts)
keymap("n", "wq", ":wq<CR>", opts)
keymap("n", "<Down>", "gjzz",opts)
keymap("n", "<Up>", "gkzz",opts)
keymap("n", "j", "jzz",opts)
keymap("n", "G", "Gzz",opts)
keymap("n", buffermap .. "n", ":bnext<CR>",opts)
keymap("n", "b<Right>", ":bnext<CR>",opts)
keymap("n", "b<Left>", ":bprevious<CR>",opts)
keymap("n", buffermap .. "p", ":bprevious<CR>",opts)
keymap("n", buffermap .. "l", ":buffers<CR>",opts)
keymap("n", "bl", ":buffers<CR>",opts)
keymap('n', PluginToggle .. 'u', ":UndotreeToggle<CR>",opts)
keymap("n", PluginToggle .. 'f',":NERDTreeToggle<CR>",opts)
keymap("n", PluginToggle .. 'm',":MinimapToggle<CR>",opts)
keymap("n", "ff", ":call fzf#run({'sink':'e','source': 'find'})<CR>",opts)

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
-- Enable word wrapping and set wrap character
vim.opt.wrap = true
vim.opt.linebreak = true

-- Customize wrap character (e.g., ↪)
vim.opt.showbreak = '↪ '

vim.api.nvim_set_keymap('n','<C-s>', ':lua RunFileType()<CR>',opts)

