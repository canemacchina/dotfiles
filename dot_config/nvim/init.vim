"Auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
	Plug 'navarasu/onedark.nvim'
	Plug 'junegunn/vim-plug'
	Plug 'alker0/chezmoi.vim'
call plug#end()

colorscheme onedark

set number "add line numbers

set nowrap "do not wrap lines

set cursorline "highlight current line

set clipboard=unnamedplus "using system clipboard

set tabstop=4 "tab size
set shiftwidth=4
set softtabstop=4

set ttyfast " Speed up scrolling in Vim

"STATUS LINE ------------------------------------------------------------ {{{

"Clear status line when vimrc is reloaded.
set statusline=

"Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

"Use a divider to separate the left side from the right side.
set statusline+=%=

"Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

"Show the status on the second to last line.
set laststatus=2

"}}}


