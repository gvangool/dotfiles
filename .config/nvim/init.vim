execute pathogen#infect()

" Colors {{{
" Set colorscheme
set background=dark
if &term =~ ".*256.*"
    set t_Co=256
endif
let g:solarized_termtrans = 1
colorscheme solarized

syntax on
" }}} 

" UI options {{{
set number
set numberwidth=4   " for up to 9999 lines
set showmatch		" Show matching brackets.
set laststatus=2 " always show the status line
set wildmenu     " display autocomplete options
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

" disable mouse support
set mouse=
" }}}

" Search options {{{
set hlsearch
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set noincsearch     " Disable incremental search
" }}}

" Folding {{{
set foldenable
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " fold based on indent level
" }}}

" Refresh the filetype plugin to find everything
filetype off
filetype on
" Filetype based indent rules
filetype indent on

" Indentation
set autoindent
set cindent
"set smartindent

" Autocmd Python {{{
augroup au_python
    autocmd!
    " Python
    autocmd BufRead,BufNewFile *.wsgi setlocal filetype=python
    " on saving of python file
    autocmd BufWrite *.py :call DeleteTrailingWS()
    " ReST
    autocmd BufRead,BufNewFile *.rest setlocal filetype=rst
    autocmd FileType rst setlocal ai
    autocmd FileType rst setlocal comments=n:>
    autocmd FileType rst setlocal tabstop=2
    autocmd FileType rst setlocal softtabstop=2
    autocmd FileType rst setlocal shiftwidth=2
    autocmd FileType rst setlocal textwidth=78 includeexpr=v:fname.'.rst'
    autocmd FileType rst setlocal includeexpr=v:fname.'.rst'
    autocmd FileType rst :call DeleteTrailingWS()
    autocmd BufWrite *.rst :call DeleteTrailingWS()
augroup END
" }}}

" Autocmd data-types (yaml, json, xml) {{{
augroup au_datatype
    autocmd!
    " YAML
    autocmd FileType yaml setlocal tabstop=2
    autocmd FileType yaml setlocal shiftwidth=2
    autocmd FileType yaml setlocal softtabstop=2
    " JSON
    autocmd FileType json setlocal autoindent
    autocmd FileType json setlocal formatoptions=tcq2l
    autocmd FileType json setlocal textwidth=78
    autocmd FileType json setlocal shiftwidth=2
    autocmd FileType json setlocal softtabstop=2
    autocmd FileType json setlocal tabstop=8
    autocmd FileType json setlocal expandtab
    autocmd FileType json setlocal foldmethod=syntax
    " XML
    autocmd FileType xml setlocal formatprg=xmllint\ --format\ --encode\ UTF-8\ -
augroup END
" }}}

" Autocmd web {{{
augroup config_autocmd
    autocmd!
    autocmd BufRead,BufNewFile *.html setlocal filetype=html
    " HTML
    autocmd FileType html setlocal tabstop=4 shiftwidth=4 noexpandtab
    autocmd BufWrite *.html :call DeleteTrailingWS()
    " CSS
    autocmd BufWrite *.css :call DeleteTrailingWS()
    " Javascript
    autocmd FileType javascript setlocal includeexpr=v:fname.'.js'
    autocmd BufWrite *.js :call DeleteTrailingWS()
    " Coffee script
    autocmd FileType coffee setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufWrite *.coffee :call DeleteTrailingWS()
    " PHP
    autocmd BufWrite *.php :call DeleteTrailingWS()
augroup END
" }}}

" Autocmd misc {{{
augroup au_cmd
    autocmd!
    " Extra syntax rules
    autocmd BufRead,BufNewFile .tmux.conf setlocal filetype=tmux
    autocmd BufRead,BufNewFile /etc/apache2/* setlocal syntax=apache
    " Jump to last known location in file
    autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
    " Markdown
    autocmd BufRead,BufNewFile *.md setlocal filetype=mkd
    autocmd BufRead,BufNewFile *.mkd setlocal filetype=mkd
    autocmd FileType mkd setlocal ai comments=n:> textwidth=78
    " GIT config
    autocmd FileType gitconfig setlocal tabstop=4 shiftwidth=4 noexpandtab
    autocmd FileType gitconfig :call DeleteTrailingWS()
    autocmd BufWrite .gitconfig :call DeleteTrailingWS()
augroup END
" }}}

" defaults (Python)
set tabstop=4
set shiftwidth=4
set expandtab

" Writing commands and marks to .viminfo
set viminfo='10,f1,<500,:20,%,n~/.config/nvim/viminfo
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

" Backups {{{
" Modify the backup/swap file behaviour (no annoying sync behaviour in
" DropBox)
set backup
set writebackup
set backupdir=~/.tmp/backup " location of backup files
set swapfile " make swap files
set directory=~/.tmp/swap " location of swap files
" }}}

" Functions {{{
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
    let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d syntax=%s :",
                \ &tabstop, &shiftwidth, &textwidth, &syntax)
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
endfunction

" Remove trailing whitespaces
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc
" }}}

" Django {{{
" add a space after/before an opening/closing Django template tag
func! CleanDjangoTags()
    exe "normal mz"
    %s/{\([{%#]\)\(\|  \+\)\([a-z0-9"']\)/{\1 \3/gei
    %s/\([a-z0-9"']\)\(\|  \+\)\([}%#]\)}/\1 \3}/gei
    exe "normal `z"
endfunc

func! FullDjangoClean()
    call CleanDjangoTags()
    call DeleteTrailingWS()
    retab! " expands tab if that is selected
endfunc

let b:surround_{char2nr("v")} = "{{ \r }}"
let b:surround_{char2nr("{")} = "{{ \r }}"
let b:surround_{char2nr("%")} = "{% \r %}"
let b:surround_{char2nr("#")} = "{# \r #}"
let b:surround_{char2nr("b")} = "{% block \1block name: \1 %}\r{% endblock \1\1 %}"
let b:surround_{char2nr("i")} = "{% if \1condition: \1 %}\r{% endif %}"
let b:surround_{char2nr("w")} = "{% with \1with: \1 %}\r{% endwith %}"
let b:surround_{char2nr("f")} = "{% for \1for loop: \1 %}\r{% endfor %}"
let b:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"

" extra rules for Django templates
if filereadable("manage.py") || filereadable("../manage.py")
    autocmd FileType html setlocal syntax=htmldjango expandtab
    autocmd BufWrite *.html :call CleanDjangoTags()
    autocmd BufRead,BufNewFile *.txt setlocal syntax=htmldjango
    autocmd BufWrite *.txt :call CleanDjangoTags()
    autocmd BufWrite *.txt :call DeleteTrailingWS()
endif
" }}}

" Go configuration
let g:go_disable_autoinstall = 1

" Modeline {{{
" Set modeline on all files, except those in tmp and Downloads
setlocal modeline modelines=1
autocmd BufRead,FileReadPost */tmp/* setlocal nomodeline modelines=0
autocmd BufRead,FileReadPost */Downloads/* setlocal nomodeline modelines=0
" }}}

" Mapping {{{
let mapleader=","       " leader is comma

" in normal mode, set nohlsearch to remove disable highlighting
nnoremap <c-N> :nohlsearch<CR>
nnoremap <leader><space> :nohlsearch<CR>
" space open/closes folds
nnoremap <space> za

" Up/down go visually instead of by physical lines (useful for long wraps)
" Interactive ones need to check whether we're in the autocomplete popup (which
" breaks if we remap to gk/gj)
map <up> gk
inoremap <up> <C-R>=pumvisible() ? "\<lt>up>" : "\<lt>C-o>gk"<Enter>
map <down> gj
inoremap <down> <C-R>=pumvisible() ? "\<lt>up>" : "\<lt>C-o>gj"<Enter>

" Remap Q to gq -> format line (default: split line on char 80)
noremap Q gq

" Macro's 
let @h = "yypVr"
" RST Underline shortcuts {{{
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
" }}}
" }}}

" Spelling {{{
set spell spelllang=en spellfile=~/.vim/spellfile.add " configure with English,
set nospell                                           " but disable it
" }}}

" vim: set foldmethod=marker foldlevel=0 :
