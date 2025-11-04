call plug#begin('~/.vim/plugged')
"on     load plugin when exec func
"for    load plugin when filetype is 'type'
"do     after install/update plugin, exec a script or func
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on':  'NERDTreeToggle' }
"Plug 'nvim-tree/nvim-tree.lua'               " for nvim
"Plug 'nvim-tree/nvim-web-devicons'           " icon support
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' "os need install ripgrep
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'luochen1990/rainbow'
Plug 'prasada7/toggleterm.vim'
Plug 'bling/vim-bufferline'
"Plug 'akinsho/bufferline.nvim', { 'dependencies' = 'nvim-tree/nvim-web-devicons' } " for nvim
Plug 'altercation/vim-colors-solarized'
" Plug 'folke/tokyonight.nvim'
" Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
call plug#end()


"plug conf start

"nerdtree
let NERDTreeShowHidden=1
if has('nvim')
    " if nvim-tree(nvim)
    nnoremap <C-n> :NvimTreeToggle<CR>
else
    " if nerdtree(vim)
    nnoremap <C-n> :NERDTreeToggle<CR>
endif

" fzf.vim
nnoremap <C-p> :Files<CR>        " search file
nnoremap <C-f> :Rg<CR>           " search content
nnoremap <C-b> :Buffers<CR>      " switch buffer

" coc.nvim
let g:coc_global_extensions = [ 'coc-highlight', 'coc-sh', 'coc-vimlsp', 'coc-go', 'coc-pyright', 'coc-phpls', 'coc-json' ]
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
inoremap <silent><expr> <c-space> coc#refresh()

"toggleterm
"ctrl+t toggle terminal
nmap <silent> <C-t> <Plug>ToggletermToggle
tmap <silent> <C-t> <C-\><C-n><Plug>ToggletermToggle

"airline
let g:airline_theme='dark'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = '▶'
let g:airline_left_alt_sep = '❯'
let g:airline_right_sep = '◀'
let g:airline_right_alt_sep = '❮'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = '/'
let g:airline_symbols.branch = '↰↱'

"off tabline because conflict with bufferline
let g:airline#extensions#tabline#enabled = 0

"bufferline
"stop echo buffer info in term
let g:bufferline_echo = 0
"enable bufferline number
let g:bufferline_numbers = 1
"hidden unsaved buffer tag [+]
let g:bufferline_show_split_names = 0
nnoremap <leader>1 :b 1<CR>
nnoremap <leader>2 :b 2<CR>
nnoremap <leader>3 :b 3<CR>
nnoremap <leader>4 :b 4<CR>
nnoremap <leader>5 :b 5<CR>
nnoremap <leader>6 :b 6<CR>
nnoremap <leader>7 :b 7<CR>
nnoremap <leader>8 :b 8<CR>
nnoremap <leader>9 :b 9<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprev<CR>
" close current buffer
nnoremap <leader>bd :bdelete<CR>

"rainbow conf
let g:rainbow_active = 1

"theme
if filereadable(expand("~/.vim/plugged/vim-colors-solarized/colors/solarized.vim"))
    let g:solarized_termcolors=256
    colorscheme solarized
else
    colorscheme desert
endif

"plug conf end

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1
set fileencoding=utf-8

"disable compatible vi
set nocompatible
set history=50
set ruler
"disable .swap file
set noswapfile

" === UI ===
" enable syntax highlight
syntax on
set background=dark

set number
set relativenumber
augroup NumToggle
    autocmd!
    "use absolute line number in edit mode
    "use relative line number in view mode
    autocmd FileType * setlocal number relativenumber
    autocmd InsertEnter * setlocal norelativenumber
    autocmd InsertLeave * setlocal relativenumber
    " except special buffer: term fzf .etc
    autocmd FileType fzf,git,help,qf,startify,terminal setlocal nonumber norelativenumber
augroup END
"highline current line
set cursorline
"display bracket matching
set showmatch
" highlight search result
set hlsearch
"enable real-time search
set incsearch
"ignorecase when search
set ignorecase
"ignorecase when search, except when the first letter is capitalized
set smartcase
" clear highlight result
nnoremap <silent> <C-l> :nohlsearch<CR><C-l>

" === indent ===
"number of spaces that a tab
set tabstop=4
"backspace length in edit mode
set softtabstop=4
"length between levels, keep same with softtabstop
set shiftwidth=4
"use space instead of tab
set expandtab
set autoindent
set backspace=indent,eol,start
set nofoldenable

" === Mouse and Clipboard ===
set mouse=a
if has('clipboard')
    set clipboard=unnamedplus
endif
set selection=exclusive
set selectmode=mouse,key

filetype plugin indent on
au BufRead,BufNewFile *.txt setlocal ft=txt
" real color
if has('termguicolors')
    set termguicolors
endif

"keep format when paste
set pastetoggle=<F9>

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
