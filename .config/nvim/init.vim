call plug#begin('~/.nvim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
 Plug 'iCyMind/NeoSolarized'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
" Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'pangloss/vim-javascript'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'gcmt/taboo.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'terryma/vim-multiple-cursors'
Plug 'editorconfig/editorconfig-vim'
Plug 'wesQ3/vim-windowswap'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'mileszs/ack.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'jparise/vim-graphql'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
" Plug 'maxmellon/vim-jsx-pretty'
" Plug 'chemzqm/vim-jsx-improve'
Plug 'kevinhui/vim-docker-tools'
Plug 'ekalinin/Dockerfile.vim'
" Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'jxnblk/vim-mdx-js'
Plug 'b4b4r07/vim-hcl'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

runtime! ./*.*.vim

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !  exists("s:std_in") | NERDTree | endif
