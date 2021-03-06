""" Josh's .vimrc

""" basic settings

" fix ttymouse options in vim for st
if &term =~ '^st\($\|-\)'
    set ttymouse=sgr
endif

set wrap                            " wrap lines
syntax on                           " show syntax
set mouse=a                         " enable mouse support
set wildmenu                        " add command completion with tab
set linebreak                       " don't break in middle of word
set title                           " reflect name of file in window title

" move down visually rather than skipping wrapped lines (may need to modify <UP> <Down> if using omnifunc)
nmap j gj
nmap <Down> gj
imap <Down> <C-o>gj
" same as above but for up
nmap k gk                           
nmap <Up> gk
imap <Up> <C-o>gk

set backspace=indent,eol,start      " allow backspacing over indention, line breaks and insertion start.
set confirm                         " confirm when closing unsaved file
set history=1000                    " increase history limit

""" tab settings

set tabstop=4                       " width of tab
set expandtab                       " tabs == spaces
set shiftwidth=4                    " number of spaces for auto indent
set softtabstop=4                   " backspace after tab removes this many spaces
set shiftround                      " round indent to nearest multiple of shiftwidth
set smarttab                        " insert tabstop number of spaces then pressing tab
set autoindent                      " copy indent from current line
set smartindent                     " smart indent (e.g. indent after '{')

set pastetoggle=<F2> 		        " turn off indent stuff and go into paste mode

""" search settings

set incsearch                       " search as characters entered
set hlsearch                        " highlight matches
set ignorecase                      " ignore the case in search
set smartcase                       " unless upper case is used

" turn off seach highlighting after carriage return
nnoremap <CR> :nohlsearch<CR><CR>

""" ui settings

set number relativenumber           " show line numbers
set ruler                           " show line and column number in bottom right corner
set laststatus=2                    " always show statusbar
"hi StatusLine ctermbg=7 ctermfg=4   " change colour of statusbar so its white on blue

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! GitOrigin()
    return system("git config --get remote.origin.url | awk -F// '{print $NF}' | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  let l:origin = GitOrigin()
  return strlen(l:branchname) > 0?'  ['.l:origin.' : '.l:branchname.'] ':''
endfunction

set statusline=
set statusline+=%#StatusLineNC#
set statusline+=%{StatuslineGit()}
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=\ %y\ 
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]\ 
set statusline+=\ line:\ %l,\ 
set statusline+=col:\ %c\ 
set statusline+=-->\ \(%p%%\)
set statusline+=\ 

""" load plugins

" YouCompleteMe needs g++-8, and vim8.1 and cmake to be installed.
" As well as this, you need to go into ~/.vim/plugged/YouCompleteMe and run 
" CXX="/usr/bin/g++-8" ./install --clang-completer for it to work
" YCM-Generator needs clang installed. 
" Once installed, given a makefile exists, you can run :YcmGenerateConfig to
" generate .ycm_extra_conf.py for project. This is used for autocomplete with ycm.

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" load plugins using vim-plug
call plug#begin('~/.vim/plugged')

Plug 'dense-analysis/ale'           " linter (in cpp files it is overridden by ycm? need to check)
Plug 'preservim/nerdtree'           " Nerdtree file explorer
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'} " generate .ycm_extra_conf.py
"Plug 'ycm-core/YouCompleteMe'       " code completion and more

call plug#end()

""" plugin specific settings

let g:ycm_confirm_extra_conf = 0    " Get rid of annoying .ycm_extra_conf.py message
let g:ycm_autoclose_preview_window_after_completion = 1 " auto close ycm preview

let NERDTreeShowHidden=1
autocmd VimEnter * NERDTree | wincmd p " Start NERDTree and move cursor to previous window
autocmd BufEnter * lcd %:p:h " Set nerdtree to directory of opened file
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif " Exit Vim if NERDTree is the only window left
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif " If another buffer tries to replace NERDTree, put in the other window, and bring back NERDTree
autocmd BufWinEnter * silent NERDTreeMirror " Open the existing NERDTree on each new tab.

