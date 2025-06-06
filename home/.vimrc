"vim: sw=4 et filetype=vim

" Get the defaults that most users want.
if filereadable(glob("$VIMRUNTIME/defaults.vim"))
  source $VIMRUNTIME/defaults.vim
endif

set t_Co=256
set invnumber
set cc=80 " columns to highlight
"set textwidth=999999
set formatoptions=tcq
set noswapfile " whether to use a swap file for a buffer
set nobackup
set noundofile
set clipboard=unnamedplus
set mouse=a
set showmatch
set wildmenu
set wildmode=longest:list,full
set showcmd
set modeline
set autoindent " take indent for new line from previous line
set copyindent " make 'autoindent' use existing indent structure
set preserveindent " preserve the indent structure when re indenting
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
set nowrap " text wrapping
set smartindent
set noequalalways
set encoding=UTF-8
noh

syntax on
filetype on
filetype indent on
filetype plugin indent on

" Reset spellcheck highlighting
hi clear SpellBad
" Set spellcheck highlight mode to "underline" and font color "red"
hi SpellBad cterm=underline ctermfg=red

" Highlight extra white space
" https://vim.fandom.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=lightred guibg=lightred
" Show trailing white space and spaces before a tab:
match ExtraWhitespace /\s\+$\| \+\ze\t/

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

if has('persistent_undo')
    set undofile " keep an undo file (undo changes after closing)
endif

if filereadable(glob("$VIMRUNTIME/colors/vim.lua"))
    source $VIMRUNTIME/colors/vim.lua
endif

if filereadable(glob("~/.vimrc_include"))
    source ~/.vimrc_include
endif

