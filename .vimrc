syntax on
set number
set hlsearch
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab 

set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
