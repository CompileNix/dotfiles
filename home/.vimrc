set nocompatible

" required by vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let vundle manage vundle DISABLED: should be handled as submodule by
" homeshick
" Bundle 'gmarik/vundle'

Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-easytags'
Bundle 'airblade/vim-gitgutter'
Bundle 'ntpeters/vim-better-whitespace'
Bundle 'tpope/vim-surround'
Bundle 'tomtom/tcomment_vim'
Bundle 'editorconfig/editorconfig-vim'

" language plugins
Bundle 'tikhomirov/vim-glsl'
Bundle 'c9s/perlomni.vim'

Bundle 'altercation/vim-colors-solarized'

set t_Co=256
colorscheme mustang
"set background=dark
let mapleader = "\<SPACE>"

syntax on
filetype plugin indent on

" search
set ignorecase
set smartcase
set incsearch
set hlsearch
set showmatch
set wildmenu
set wildmode=list:longest,full

set mouse=a

" appand here
map <F4> a vim: sw=4 et
map <F6> :NERDTreeToggle<CR>
" reformat file
map <F7> mzgg=G`z
" disable search result highlight
map <F8> :noh<CR>
set pastetoggle=<F10>
map <F12> :set invnumber<CR>:GitGutterSignsToggle<CR>

inoremap <S-TAB> <C-D>

map <C-C> "+y
map <C-V> "+p
imap <C-V> <F10><C-r>+<F10>

map <C-Space> <C-x><C-o>
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone

" change enter key to insert completion:
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" escape to exit completion
"inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
" up/down arrow to select
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
" scroll with page up/down
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

let NERDTreeShowHidden=1

map <leader>rc :w<CR>:source $MYVIMRC<CR>:noh<CR>
nnoremap <Leader>w :w<CR>
map <leader>s :w<CR>
noremap <C-T> :tabedit<CR>
noremap <C-Q> :tabclose<CR>

"Faster shortcut for commenting. Requires T-Comment plugin
map <leader>c <c-_><c-_>

" C-p
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(exe|so|dll)$',
            \ }
" example link to exclude
"  \ 'link': 'some_bad_symbolic_links',

" ----- xolox/vim-easytags settings -----
" Where to look for tags files
set tags=./tags;,~/.vimtags
" Sensible defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
" set to 2 to generate local tag files, not just use them
let g:easytags_dynamic_files = 1
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1

" ----- majutsushi/tagbar settings -----
" Open/close tagbar with \b
nmap <silent> <leader>r :TagbarToggle<CR>
" Uncomment to open tagbar automatically whenever possible
"autocmd BufEnter * nested :call tagbar#autoopen(0)

" ----- airblade/vim-gitgutter settings -----
" Required after having changed the colorscheme
hi clear SignColumn
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

set number
set tabstop=4
set showcmd
set nowrap
set modeline
set modelines=5
noh

" airline all the time
set laststatus=2
set noshowmode

autocmd vimenter * if !argc() | NERDTree | endif

if filereadable(glob("~/.vimrc_include"))
    source ~/.vimrc_include
endif

" vim: sw=4 et
