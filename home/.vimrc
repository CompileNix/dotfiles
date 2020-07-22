" Get the defaults that most users want.
if filereadable(glob("$VIMRUNTIME/defaults.vim"))
    source $VIMRUNTIME/defaults.vim
endif

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

set t_Co=256
set relativenumber
set invnumber
set tw=792034
set cc=80
set nobackup
set noswapfile
set noundofile
set background=dark
set clipboard=unnamedplus
set expandtab
set tabstop=4
set shiftwidth=4
set mouse=a
set ignorecase
set smartcase
set incsearch
set hlsearch
set showmatch
set wildmenu
set wildmode=full
set showcmd
set modeline

colorscheme mustang
noh
syntax on
filetype on

" Copy
map <C-C> "+y
" Paste
map <C-V> "+p

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

function Save()
  w
endfunction
command -bar -nargs=0 Save call Save()

function SaveForce()
  w!
endfunction
command -bar -nargs=0 SaveForce call SaveForce()

function Exit()
  q
endfunction
command -bar -nargs=0 Exit call Exit()

function ExitForce()
  q!
endfunction
command -bar -nargs=0 ExitForce call ExitForce()

function SaveAsRoot()
  w !sudo tee > /dev/null %
endfunction
command -bar -nargs=0 SaveAsRoot call SaveAsRoot()

set pastetoggle=<F11>
map <F12> :noh<CR>
map <F8> :!$SHELL<CR>

if filereadable(glob("~/.vimrc_include"))
    source ~/.vimrc_include
endif
