require("keymaps")
vim.cmd([[
	set spell
	set termguicolors
"	set scrolloff=29
	set number
	set relativenumber
	set hidden
	"set background=dark
	colorscheme catppuccin_frappe
	set clipboard=unnamedplus
	set undofile
	set undodir=$HOME/.config/nvim/undo/
	let g:airline#extensions#tabline#enabled = 1
  	let g:airline#extensions#whitespace#enabled = 0
	let g:airline_theme='atomic'
	nnoremap <C-T> 0y$/\V<c-r>"<cr>
	let g:tex_flavor = 'latex'
	]])

--	Plug 'preservim/nerdtree'
--	Plug 'mbbill/undotree'
--	Plug 'neoclide/coc.nvim', {'branch': 'release'}
--	Plug 'nvim-lua/plenary.nvim'
--	Plug 'vim-airline/vim-airline'
--	Plug 'vim-airline/vim-airline-themes'
--	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
--	Plug 'junegunn/fzf.vim'
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
plugins = { 
	'preservim/nerdtree',
	'mbbill/undotree',
	'nvim-lua/plenary.nvim',
	'vim-airline/vim-airline',
	'vim-airline/vim-airline-themes',
	'junegunn/fzf',
	'junegunn/fzf.vim',
	{ 'neoclide/coc.nvim', branch = 'master', build = "cd ~/.local/share/nvim/lazy/coc.nvim/ && npm ci"}

}
require("lazy").setup(plugins, opts)

-- Enable word wrapping and set wrap character
vim.opt.wrap = true
vim.opt.linebreak = true

-- Customize wrap character (e.g., ↪)
vim.opt.showbreak = '↪ '

