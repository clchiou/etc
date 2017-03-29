""" Begin configure Vundle

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'

Plugin 'rust-lang/rust.vim'

Plugin 'scrooloose/nerdtree'

Plugin 'vim-python/python-syntax'

call vundle#end()
filetype plugin indent on

""" End configure Vundle


" Configure mouse
set mouse=a
set ttymouse=xterm2

" Set correct background (most of time)
set background=dark

" Use 'syntax enable' because 'syntax on' overrules my settings
syntax enable

" Informative display settings
set ruler
set showcmd
set hlsearch
set wildmenu

" More intuitive way to open a new window (to me)
set splitright

" More intuitive way to move around (to me)
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk

" Useful search command
" See http://vim.wikia.com/wiki/Find_in_files_within_Vim
map <F4> :lgetexpr system('ag --vimgrep "\b' . expand("<cword>") . '\b"') <Bar> lwindow <CR>
command! -nargs=1 AG lgetexpr system('ag --vimgrep <q-args>') | lwindow
command! -nargs=1 GG lgetexpr system('git grep --line-number <q-args>') | lwindow

" Shortcuts for tab maneuver
map  <C-h> :tabprev<CR>
imap <C-h> <ESC>:tabprev<CR>
map  <C-l> :tabnext<CR>
imap <C-l> <ESC>:tabnext<CR>

" Set tab style that fits my eye
highlight TabLineSel term=bold,underline cterm=bold,underline ctermfg=7 ctermbg=0
highlight TabLine term=bold cterm=bold
highlight clear TabLineFill

" Override default filetype association
autocmd BufNewFile,BufRead *.rs set filetype=rust
autocmd BufNewFile,BufRead *.tex set filetype=tex
autocmd BufNewFile,BufRead *.md set filetype=markdown

" Highlight trailing whitespace and lines longer columns.
highlight LongLine cterm=bold,underline
highlight WhitespaceEOL ctermbg=DarkYellow guibg=DarkYellow

" Highlight lines longer than 79 columns.
autocmd BufWinEnter,WinEnter * let w:m0=matchadd('LongLine', '\%>79v.\+', -1)

" Highlight trailing spaces.
" This little dance suppresses whitespace that has just been typed.
autocmd BufWinEnter,WinEnter * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
autocmd InsertEnter * call matchdelete(w:m1)
autocmd InsertEnter * let w:m2=matchadd('WhitespaceEOL', '\s\+\%#\@<!$', -1)
autocmd InsertLeave * call matchdelete(w:m2)
autocmd InsertLeave * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)

" Wrap lone lines in diff mode
function SetPrettyLineWrap()
  if &diff
    set wrap
    windo set formatoptions=l
    windo set linebreak
    set display=lastline
  endif
endfunction

" Wrap line wrap for .txt files
au FilterWritePre *.txt call SetPrettyLineWrap()

" Set indent using 2-space
function IndentUse2Space()
  set expandtab
  set tabstop=8
  set softtabstop=2
  set shiftwidth=2
endfunction

" Set indent using 4-space
function IndentUse4Space()
  set expandtab
  set tabstop=8
  set softtabstop=4
  set shiftwidth=4
endfunction

" Set indent using tab
function IndentUseTab()
  set noexpandtab
  set tabstop=8
  set softtabstop=0
  set shiftwidth=8
endfunction

" By default we use 2-space to indent YAML files
autocmd BufNewFile,BufRead *.yaml,*.yml call IndentUse2Space()

" By default we use 4-space to indent Python codes
autocmd BufNewFile,BufRead *.py call IndentUse4Space()

" Python syntax highlight option
let python_highlight_all = 1
let python_highlight_builtin_funcs = 0
let python_highlight_class_vars = 0
let python_highlight_operators = 0
hi def link pythonBoolean Statement
hi def link pythonNone Statement

" YouCompleteMe
" Key mappings (use C-o/C-i to jump backward/forward in histroy)
nnoremap <C-y>d :YcmCompleter GoTo<CR>
nnoremap <C-y>r :YcmCompleter GoToReferences<CR>
" Set menu color
highlight Pmenu ctermfg=15 ctermbg=0
" Close preview window ASAP
let g:ycm_autoclose_preview_window_after_completion = 1
