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
set wildignore=*.swp,*.bak,*.pyc,*.class

execute pathogen#infect()
call pathogen#helptags()


let g:Powerline_symbols='unicode'           "vim-powerline
let g:netrw_sort_sequence='\.py$,\.conf$'   "Sort sequence
let NERDTreeIgnore = ['\.pyc$']             "NERDTree ignore filetypes
let g:gitgutter_enabled = 0                 "Disable GitGutter by default

au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab


filetype off
autocmd BufWritePost *.py call Flake8() "apply flake8 as files are saved
autocmd BufWritePre * :%s/\s\+$//e "Trim the line endings
syntax on



"I hate 'Modifiable is off' warnings. I dont properly understand how am I ending up with that error. This is a quick trick to restore writable state.
func! DSModifiableOff()
    set modifiable
    set noreadonly
    set number
endfu
:com! DSModOff call DSModifiableOff()

"function to auto indent (:A) entire file
func! AutoIndentFile()
    gg=G
endfu
:com! A call AutoIndentFile()

filetype plugin indent on


"post Pathogen functions
colorscheme asu1dark
if has("gui_running")
    set guifont=Monaco:h12.50   "favorite font
    set guioptions-=m           "remove menu bar
    set guioptions-=T           "remove toolbar
    set guioptions-=r           "remove right-hand scroll bar
    set fu                      "Goto full screen on mac
endif

"Disable CoffeeSpaceError
hi link coffeeSpaceError NONE
let g:syntastic_mode_map={ 'mode': 'active', 'passive_filetypes': ['html'] }
