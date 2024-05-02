homedir=os.getenv('HOME')
local PluginToggle = "<C-p>"
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
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
keymap("n", "<S-Right>", ":bnext<CR>",opts)
keymap("n", "<S-Left>", ":bprevious<CR>",opts)
keymap("n", "w<Left>", "<C-w><Left>",opts)
keymap("n", "w<Right>", "<C-w><Right>",opts)
keymap("n", "w<Up>", "<C-w><Up>",opts)
keymap("n", "w<Down>", "<C-w><Down>",opts)
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
	elseif filetype == "markdown"
	then
		vim.cmd([[
		write
		silent! !pandoc -i % -o %.pdf
		]])
	end
end

vim.api.nvim_set_keymap('n','<C-s>', ':lua RunFileType()<CR>',opts)

