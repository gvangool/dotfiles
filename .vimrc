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
    " Jump to last known location in file
    au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
endif

set number
set showmatch		" Show matching brackets.

" Search options
set hlsearch
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
"set incsearch		" Incremental search

set smartindent

" File specific stuff (tabs, indentation)

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

