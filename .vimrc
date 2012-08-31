" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

call pathogen#runtime_append_all_bundles()
" Refresh the filetype plugin to  find everything
filetype off
" Filetype based indent rules
filetype plugin indent on

syntax on

set background=dark
if &term =~ ".*256.*"
    set t_Co=256
endif
colorscheme fnaqevan  " mustang solarized

if has("autocmd")
    " extra filetypes
    au BufRead,BufNewFile *.html set filetype=html
    au BufRead,BufNewFile *.wsgi set filetype=python
    au BufRead,BufNewFile *.md set filetype=mkd
    au BufRead,BufNewFile *.mkd set filetype=mkd
    au BufRead,BufNewFile .tmux.conf set filetype=tmux
    " extra syntax rules
    au BufRead,BufNewFile /etc/apache2/* set syntax=apache
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
autocmd FileType mkd setlocal ai comments=n:> textwidth=78
" ReST
autocmd FileType rst setlocal ai comments=n:> tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType rst setlocal textwidth=78 includeexpr=v:fname.'.rst'
autocmd FileType rst :call DeleteTrailingWS()
autocmd BufWrite *.rst :call DeleteTrailingWS()
" YAML
autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
" HTML
autocmd FileType html setlocal tabstop=4 shiftwidth=4 noexpandtab
" GIT config
autocmd FileType gitconfig setlocal tabstop=4 shiftwidth=4 noexpandtab
autocmd FileType gitconfig :call DeleteTrailingWS()
autocmd BufWrite .gitconfig :call DeleteTrailingWS()
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

" Writing commands and marks to .viminfo
set viminfo='10,f1,<500,:20,%,n~/.viminfo
"           |   |  |    |   | |
"           |   |  |    |   | +-- viminfo location
"           |   |  |    |   +-- the buffer list
"           |   |  |    +-- number of lines to save from the command line
"           |   |  |         history
"           |   |  +-- Maximum number of lines saved for each register, large
"           |   |      number will slow down vim start
"           |   +-- save global marks
"           +-- number of marks to save
set history=1000 " keep a lot of history!
" Error handling
set noerrorbells
set visualbell

" Modify the backup/swap file behaviour (no annoying sync behaviour in
" DropBox)
set nobackup " don't make backup files
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
" on saving of html/css/js file
autocmd BufWrite *.html :call DeleteTrailingWS()
autocmd BufWrite *.css :call DeleteTrailingWS()
autocmd BufWrite *.js :call DeleteTrailingWS()
" in normal mode, set nohlsearch to remove previous search
nnoremap  :noh<return>

" Django config
" add a space after/before an opening/closing Django template tag
func! CleanDjangoTags()
    exe "normal mz"
    %s/{\([{%#]\)\(\|  \+\)\([a-z0-9"']\)/{\1 \3/gei
    %s/\([a-z0-9"']\)\(\|  \+\)\([}%#]\)}/\1 \3}/gei
    exe "normal `z"
endfunc
" extra rules for Django templates
if filereadable("manage.py") || filereadable("../manage.py")
    autocmd FileType html setlocal syntax=htmldjango expandtab
    autocmd BufWrite *.html :call CleanDjangoTags()
    autocmd BufRead,BufNewFile *.txt setlocal syntax=htmldjango
    autocmd BufWrite *.txt :call CleanDjangoTags()
    autocmd BufWrite *.txt :call DeleteTrailingWS()
endif

func! FullDjangoClean()
    call CleanDjangoTags()
    call DeleteTrailingWS()
    %s/\t/    /gei
endfunc

" Set modeline on all files, except those in tmp and Downloads
set modeline
autocmd BufRead,FileReadPost */tmp/* setlocal nomodeline
autocmd BufRead,FileReadPost */Downloads/* setlocal nomodeline

" Remap Q to gq -> format line (default: split line on char 80)
noremap Q gq
" Formatting
if filereadable("/usr/bin/xml_pp")
    " XML pretty printing
    autocmd FileType xml setlocal formatprg=xml_pp
endif

" Macro's
let @h = "yypVr"
""""""""""""""""""""""""""""
" ReST Underline shortcuts "
""""""""""""""""""""""""""""
" Ctrl-u 1: Parts with #'s
noremap  <C-u>1 yyPVr#yyjp
inoremap <C-u>1 <esc>yyPVr#yyjpA
" Ctrl-u 2: Chapters with *'s
noremap  <C-u>2 yyPVr*yyjp
inoremap <C-u>2 <esc>yyPVr*yyjpA
" Ctrl-u 3: Section Level 1 with ='s
noremap  <C-u>3 yypVr=
inoremap <C-u>3 <esc>yypVr=A
" Ctrl-u 4: Section Level 2 with -'s
noremap  <C-u>4 yypVr-
inoremap <C-u>4 <esc>yypVr-A
" Ctrl-u 5: Section Level 3 with ~'s
noremap  <C-u>5 yypVr~
inoremap <C-u>5 <esc>yypVr~A
" Ctrl-u 6: Section Level 4 with ^'s
noremap  <C-u>6 yypVr^
inoremap <C-u>6 <esc>yypVr^A
" Ctrl-u 7: Paragraph with "'s
noremap  <C-u>7 yypVr"
inoremap <C-u>7 <esc>yypVr"A

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d syntax=%s :",
        \ &tabstop, &shiftwidth, &textwidth, &syntax)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction

" Extra Vim behaviour
set spell spelllang=en_us spellfile=~/.vim/spellfile.add
set nospell
set laststatus=2 " always show the status line
set lazyredraw   " do not redraw while running macros
set ruler        " always show current positions along the bottom
set scrolloff=10 " keep 10 lines (top/bottom) for scope
set showcmd      " show the command being typed
set statusline=%F%m%r%h%w[%LL][%{&ff}]%y[%p%%]--(%l,%v)
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
