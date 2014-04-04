runtime bundle/pathogen/autoload/pathogen.vim

set paste           "use ctrl-p or cmd-p to paste
set number          "line numbers
set ignorecase      "ignore case while searching
set smartcase       "if camel-cased, dont ignore case
set incsearch       "instant search
set nocompatible    "non compatibe
set hlsearch        "Highlight the search termset wildignore=*.swp,*.bak,*.pyc,*.claset

execute pathogen#infect()
call pathogen#helptags()

let NERDTreeIgnore = ['\.pyc$']             "NERDTree ignore filetypes
let g:gitgutter_enabled = 0                 "Disable GitGutter by default
let g:email = "dhilipsiva@gmail.com"
let g:username = "dhilipsiva"

set tabstop=4
set shiftwidth=4
au BufNewFile,BufReadPost *.coffee,*.rb setl tabstop=2 shiftwidth=2

set expandtab

filetype on
autocmd BufWritePost *.py call Flake8() "apply flake8 as files are saved
autocmd BufWritePre * :%s/\s\+$//e "Trim the line endings
syntax on

"I hate 'Modifiable is off' warnings. I dont properly understand how am I ending up with that error. This is a quick trick to restore writable state.
func! ModifiableOff()
    set modifiable
    set noreadonly
    set number
endfu
:com! ModOff call ModifiableOff()

filetype plugin indent on

"post Pathogen functions
colorscheme ansi_blows
if has("gui_running")
    set guifont=Monaco:h14      "favorite font
    set guioptions-=m           "remove menu bar
    set guioptions-=T           "remove toolbar
    set guioptions-=r           "remove right-hand scroll bar
    set fu                      "Goto full screen on mac
endif

"Disable CoffeeSpaceError
hi link coffeeSpaceError NONE
let g:syntastic_mode_map={ 'mode': 'active', 'passive_filetypes': ['html'] }
let g:templates_no_autocmd = 1
let python_highlight_all = 1
cabbr <expr> %% expand('%:p:h')
