set tabstop=4       "1 tab equals 4 columns
set shiftwidth=4    "ditto
set expandtab       "expand tabs to spaces
set paste           "use ctrl-p or cmd-p to paste
set number          "line numbers
set ignorecase      "ignore case while searching
set smartcase       "if camel-cased, dont ignore case
set incsearch       "instant search
set nocompatible    "non compatibe
set laststatus=2    "vim-powerline cfg
set t_Co=256        "vim-powerline

let g:Powerline_symbols='unicode'           "vim-powerline
let g:netrw_sort_sequence='\.py$,\.conf$'   "Sort sequence

filetype off 
filetype plugin indent on
autocmd BufWritePost *.py call Flake8() "apply flake8 as files are saved
syntax on

if has("gui_running")
    colorscheme koehler         "favorite theme
    set guifont=Monaco:h12.50   "favorite font
    set guioptions-=m           "remove menu bar
    set guioptions-=T           "remove toolbar
    set guioptions-=r           "remove right-hand scroll bar
endif
