" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

syntax on
set background=dark
colorscheme evening

if has("autocmd")
    " Filetype based indent rules
    filetype plugin on
    au BufRead,BufNewFile *.html set filetype=html
    au BufRead,BufNewFile *.wsgi set filetype=python
    " Jump to last known location in file
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
endif

set number
set numberwidth=4   " for up to 9999 lines
set showmatch		" Show matching brackets.

" Search options
set hlsearch
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
"set incsearch		" Incremental search

" File specific stuff (tabs, indentation)
" Indentation
set autoindent
set smartindent
" Markdown
autocmd FileType mkd setlocal ai comments=n:>
" ReST
autocmd FileType rest setlocal ai comments=n:> tabstop=2 softtabstop=2 shiftwidth=2
" YAML
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
" HTML
autocmd FileType html setlocal tabstop=4 shiftwidth=4 noexpandtab
" defaults (Python)
set tabstop=4
set shiftwidth=4
set expandtab

" Up/down go visually instead of by physical lines (useful for long wraps)
" Interactive ones need to check whether we're in the autocomplete popup (which
" breaks if we remap to gk/gj)
map <up> gk
inoremap <up> <C-R>=pumvisible() ? "\<lt>up>" : "\<lt>C-o>gk"<Enter>
map <down> gj
inoremap <down> <C-R>=pumvisible() ? "\<lt>up>" : "\<lt>C-o>gj"<Enter>

" Writing used commands to .viminfo
set viminfo='10,\"100,:20,%,n~/.viminfo
" Error handling
set noerrorbells
set visualbell

" Modify the backup/swap file behaviour (no annoying sync behaviour in
" DropBox)
set backup " make backup files
set backupdir=~/.vim/backup " location of backup files
set swapfile " make swap files
set directory=~/.vim/tmp " location of swap files

" Remove trailing whitespaces
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
" on saving of python file
autocmd BufWrite *.py :call DeleteTrailingWS()
" on saving of html file
autocmd BufWrite *.html :call DeleteTrailingWS()

" Extra Vim behaviour
set laststatus=2 " always show the status line
set lazyredraw   " do not redraw while running macros
set ruler        " always show current positions along the bottom
set scrolloff=10 " keep 10 lines (top/bottom) for scope
set showcmd      " show the command being typed
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%]--(%l,%v)
"               | | | | |  |     |    |  |       |  |
"               | | | | |  |     |    |  |       |  + current column
"               | | | | |  |     |    |  |       +-- current line
"               | | | | |  |     |    |  +-- current % into file
"               | | | | |  |     |    +-- current syntax in square brackets
"               | | | | |  |     +-- current fileformat
"               | | | | |  +-- number of lines
"               | | | | +-- preview flag in square brackets
"               | | | +-- help flag in square brackets
"               | | +-- readonly flag in square brackets
"               | +-- modified flag in square brackets
"               +-- full path to file in the buffer
