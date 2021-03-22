" vim: sw=4 et

" Get the defaults that most users want.
if filereadable(glob("$VIMRUNTIME/defaults.vim"))
    source $VIMRUNTIME/defaults.vim
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " Set 'textwidth' for all text files
  autocmd FileType text setlocal textwidth=72
augroup END

set t_Co=256
set invnumber
set textwidth=792034
set cc=72 " columns to highlight
set formatoptions=cq
set noswapfile " whether to use a swapfile for a buffer
set nobackup
set noundofile
set clipboard=unnamedplus
set mouse=a
set showmatch
set wildmenu
set wildmode=full
set showcmd
set modeline
set autoindent " take indent for new line from previous line
set copyindent " make 'autoindent' use existing indent structure
set preserveindent " preserve the indent structure when reindenting
set shiftwidth=4 " number of spaces to use for (auto)indent step
set background=dark " 'dark' or 'light', used for highlight colors
set expandtab " use spaces when <Tab> is inserted
set tabstop=4 " number of spaces that <Tab> in file uses
set laststatus=0 " tells when last window has status lines
set norelativenumber " show relative line number in front of each line
set number " print the line number in front of each line
set numberwidth=3 " number of columns used for the line number
set splitbelow " new window from split is below the current one
set splitright " new window is put right of the current one
set exrc " read .vimrc and .exrc in the current directory
set hlsearch " highlight matches with last search pattern
set ignorecase " ignore case in search patterns
set incsearch " highlight match while typing search pattern
set smartcase " no ignore case when pattern has uppercase
set nowrapscan " searches wrap around the end of the file
set smartindent
noh

colorscheme mustang
syntax on
filetype on

function StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal `z
  endif
endfunction
command -bar -nargs=0 StripTrailingWhitespace call StripTrailingWhitespace()
command -bar -nargs=0 TrimTrailingWhitespace call StripTrailingWhitespace()

function FixIndentation()
  if !&binary && &filetype != 'diff'
    normal gg=G<C-o><C-o>ii
  endif
endfunction
command -bar -nargs=0 FixIndentation call FixIndentation()

function SaveAsRoot()
  w !sudo tee > /dev/null %
endfunction
command -bar -nargs=0 SaveAsRoot call SaveAsRoot()

set pastetoggle=<F11>

if filereadable(glob("~/.vimrc_include"))
  source ~/.vimrc_include
endif

if has('persistent_undo')
  set undofile	" keep an undo file (undo changes after closing)
endif
