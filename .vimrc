" --- Initialization ---
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" --- Plugins (vim-plug) ---
call plug#begin('~/.vim/plugged')

" FZF core and Vim wrapper
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" --- General Settings ---
syntax enable
filetype plugin indent on
set encoding=UTF-8
set hidden
set scrolloff=16
set autowrite
set autowriteall

" --- Search Settings ---
set hlsearch incsearch
set ignorecase
set smartcase

" --- Appearance ---
set number relativenumber
if $COLORTERM == 'truecolor'
  set termguicolors
endif

" --- Key Mappings ---
let mapleader="\<space>"

" Terminal & Utilities
nnoremap <leader>c :botright term++close<CR>
nnoremap <leader>h :nohlsearch<CR>

" Split Navigation (Direct)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Leader Navigation (Splits & Buffers)
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>s :split<CR>
nnoremap <leader>x :close<CR>
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>d :bdelete<CR>
" (Removed the old <leader>b in favor of the fzf buffer search below)

" --- FZF Key Mappings ---
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>m :Marks<CR>
nnoremap <leader>H :History<CR>

" --- WSL2 / Windows Clipboard Fix ---
if executable('powershell.exe')
    let g:clipboard = {
          \   'name': 'WslClipboard',
          \   'copy': { '+': 'clip.exe', '*': 'clip.exe' },
          \   'paste': {
          \      '+': 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
          \      '*': 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
          \   },
          \   'cache_enabled': 0,
          \ }
endif

set fileformats=unix,dos
