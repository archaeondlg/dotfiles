call plug#begin('~/.vim/plugged')
"on     load plugin when exec func
"for    load plugin when filetype is 'type'
"do     after install/update plugin, exec a script or func
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on':  'NERDTreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'junegunn/fzf'
Plug 'jiangmiao/auto-pairs'
"Plug 'bling/vim-bufferline'
"Plug 'sickill/vim-monokai'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'luochen1990/rainbow'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'prasada7/toggleterm.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vim-syntastic/syntastic', { 'for': 'python' }
Plug 'vim-scripts/winmanager'
call plug#end()

let g:coc_global_extensions = [ 'coc-sh', 'coc-vimlsp', 'coc-python', 'coc-json', 'coc-highlight' ]

let NERDTreeShowHidden=1
"toggle nerdtree
map <F2> :NERDTreeToggle<CR>
"Multi-line comment
nmap // <leader>ci <CR>

"airline conf
let g:airline_theme='dark'
"separator
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '❯'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '❮'
let g:airline_symbols.linenr = '/'
let g:airline_symbols.branch = '↰↱'
"enable buferline
"enbale tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

"rainbow conf
let g:rainbow_active = 1

"syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

"disable compatible vi
set nocompatible
set history=50
set ruler
"disable .swap file
set noswapfile

" enable syntax highlight
syntax enable
set background=dark
" set theme
if filereadable(expand("~/.vim/plugged/vim-colors-solarized/colors/solarized.vim"))
    let g:solarized_termcolors=256
    colorscheme solarized
elseif filereadable(expand("~/.vim/plugged/vim-monokai/colors/monokai.vim"))
    colorscheme monokai
else
    colorscheme desert
endif
" highlight search result
set hlsearch
" filetype check for function and plugin
filetype plugin on
au BufRead,BufNewFile *.txt setlocal ft=txt

set t_Co=256

set number
" relative number
set rnu
augroup NumToggle
    autocmd!
    "use absolute line number in edit mode
    "use relative line number in view mode
    autocmd InsertEnter * :set norelativenumber
    autocmd InsertLeave * :set relativenumber
augroup END

"highline current line
set cursorline
"display bracket matching
set showmatch
set backspace=2
set backspace=indent,eol,start
"enable real-time search
set incsearch
"ignorecase when search
set ignorecase
"ignorecase when search, except when the first letter is capitalized
set smartcase
"number of spaces that a tab
set tabstop=4
"use space instead of tab
set expandtab
"backspace length in edit mode
set softtabstop=4
"length between levels, keep same with softtabstop
set shiftwidth=4

"if no characters, indentation will be deleted.
" autoindent        based on previous line
" cindent           based on C syntax
set autoindent

set foldmethod=indent
set foldlevelstart=99

" enable mouse
set mouse=a
set selection=exclusive
set selectmode=mouse,key
map <Esc-l> :nohl <CR>

"keep format when paste
set pastetoggle=<F9>
"split new window below this one
"set splitbelow
"set term height 10, weight default
"set termwinsize=10x0
"open terminal
map <F1> :bot term ++rows=10 <CR>
"close terminal
tmap <F8> <C-W>:call CloseTerm()<CR>
nmap <F8> <C-W>p<C-W>:call CloseTerm()<CR>
func! CloseTerm()
    call feedkeys('exit'. "\<CR>")
    "call term_sendkeys('', 'exit'. "\<CR>")
endfunc

"run the editting file
map <F5> :call CompileRun()<CR>
func! CompileRun()
    exec "w"
    if &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python %"
    elseif &filetype == 'php'
        exec "!time php -f %"
    elseif &filetype == 'go'
        :!time go run %
    elseif &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!java %<"
    endif
endfunc

autocmd BufNewFile *.sh,*.py,*.cpp,*.[ch],*.java,*.hpp exec ":call AddHeader()"
func AddHeader()
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
        call append(line(".")+1, "")
        call append(line(".")+2, "")
    elseif &filetype == 'python'
        call setline(1, "\#!/usr/bin/env python")
        call append(line("."), "\# -*- coding: UTF8 -*-")
        call append(line(".")+1, "")
        call append(line(".")+2, "")
    elseif &filetype == 'php'
        call setline(1, "\<?php")
        call append(line(".")+1, "")
        call append(line(".")+2, "")
	elseif &filetype == 'cpp'
        call setline(1, "\#include<iostream>")
        call append(line("."), "using namespace std;")
        call append(line(".")+1, "")
    elseif &filetype == 'c'
        call setline(1, "\#include<stdio.h>")
        call append(line("."), "")
	elseif expand("%:e") == 'hpp'
        call setline(1, "/** ")
    endif
endfunc
autocmd BufNewFile * normal G
