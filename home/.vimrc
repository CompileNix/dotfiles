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
Bundle 'airblade/vim-gitgutter'
Bundle 'ntpeters/vim-better-whitespace'
Bundle 'editorconfig/editorconfig-vim'

" language plugins

" themes
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

set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone
function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

"inoremap <Tab> <c-r>=Smart_TabComplete()<CR>

if has("unix")
   "inoremap <C-@> <c-r>=Smart_TabComplete()<CR>
elseif has("win32")
  inoremap <C-Space> <c-r>=Smart_TabComplete()<CR>
endif

set synmaxcol=300
syntax sync minlines=1000

" change enter key to insert completion:
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" escape to exit completion
"inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
" up/down arrow to select
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"

let NERDTreeShowHidden=1

map <leader>rc :w<CR>:source $MYVIMRC<CR>:noh<CR>
nnoremap <Leader>w :w<CR>
map <leader>s :w<CR>
noremap <C-T> :tabedit<CR>
noremap <C-Q> :tabclose<CR>

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
