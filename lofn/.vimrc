" THIS IS NOW A BACKUP ONLY
set nocompatible
let mapleader=' ' "use space for leader key

" Cursor behaviour
:autocmd InsertEnter,InsertLeave * set cul!
" General visual look of Vim
set number relativenumber
set ruler
set noerrorbells
set visualbell
set laststatus=2
set showmode
set splitbelow splitright
" Text searching options
set incsearch
set ignorecase
set smartcase
set showmatch
" Syntax and formatting
syntax on
set encoding=utf-8
set hidden
" Tabs and indenting
set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set scrolloff=15
" Command line completion options
set showcmd
set wildmenu
" Colors
set background=dark

set nobackup
set nowritebackup
set noundofile
set noswapfile
set termguicolors

" Remappings
" Don't exit visual mode after indenting
vnoremap > >gv
vnoremap < <gv

" basic
nnoremap <C-s> :w<CR>
nnoremap <C-q> :qa<CR>
nnoremap <C-c> :close<CR>
nmap D :bdelete!<CR>
nmap H :bprev<CR>
nmap L :bnext<CR>

" go to beginning and end
inoremap <C-b> <ESC>^i
inoremap <C-e> <End>
nnoremap B ^
onoremap B ^
xnoremap B ^
nnoremap E g_
onoremap E g_
xnoremap E g_

" Delete the character to the right of the cursor
inoremap <C-D> <DEL>

" navigate within insert mode
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

" turn the word under cursor to upper case
inoremap <C-u> <Esc>viwUea
" turn the current word into title case
inoremap <C-t> <Esc>b~lea

" window management
nnoremap \| <C-w>v
nnoremap \ <C-w>s

" clear highlights
nnoremap <Esc> :noh<CR>

" Move selected text up and down
vnoremap J :move '>+1<CR>gv-gv
vnoremap K :move '<-2<CR>gv-gv

" Change text without putting it into a register
nnoremap c "_c
nnoremap C "_C
nnoremap cc "_cc
xnoremap c "_c

" Don't copy the replaced text after pasting in visual mode
" https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
xnoremap p p:let @+=@0<CR>:let @"=@0<CR>

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons'
Plug 'ojroques/vim-oscyank', {'branch': 'main'}
Plug 'liuchengxu/vim-which-key'

call plug#end()

" catppuccin for lightline
let g:lightline = {'colorscheme': 'catppuccin_mocha'}

" nerd tree
nnoremap <leader>e :NERDTreeToggle<CR>

" yaml setup
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" coc stuff
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-yaml', 'coc-prettier', 'coc-pyright']
autocmd FileType json syntax match Comment +\/\/.\+$+
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument
vmap <leader>lf  <Plug>(coc-format-selected)
nmap <leader>lf  <Plug>(coc-format-selected)

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>lr <Plug>(coc-rename)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>ld  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>le  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>lc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>lo  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>ls  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Vim-Commentary
filetype plugin indent on

" oscyank
nmap <Leader>y <Plug>OSCYankOperator
nmap <Leader>Y <leader>c_
vmap <Leader>y <Plug>OSCYankVisual

" which-key-vim
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

colorscheme catppuccin_mocha
