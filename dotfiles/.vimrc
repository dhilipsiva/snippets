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
set hlsearch        "Highlight the search term


let g:Powerline_symbols='unicode'           "vim-powerline
let g:netrw_sort_sequence='\.py$,\.conf$'   "Sort sequence


filetype off 
autocmd BufWritePost *.py call Flake8() "apply flake8 as files are saved
autocmd BufWritePre *.py normal m`:%s/\s\+$//e`` "trim line endings
syntax on


if has("gui_running")
    colorscheme koehler         "favorite theme
    set guifont=Monaco:h12.50   "favorite font
    set guioptions-=m           "remove menu bar
    set guioptions-=T           "remove toolbar
    set guioptions-=r           "remove right-hand scroll bar
endif


"I hate 'Modifiable is off' warnings. I dont properly understand how am I ending up with that error. This is a quick trick to restore writable state.
func! DSModifiableOff()
    set modifiable
    set noreadonly
    set number
endfu
:com! DSModOff call DSModifiableOff()

"Vundle Configuration
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'davidhalter/jedi-vim'

filetype plugin indent on
