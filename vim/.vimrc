
""" Swap files
" Automatically create swap directory and set it as swap location
" It's to prevent committing *.swap
let swapd = $HOME . '/.vim/swap'
let mkdir = system('mkdir -p ' . expand(swapd))
let &directory=swapd . '//'

""" Colors
let term = system('tput -T$TERM colors || echo 8')
if term >= 256
    " Set scheme and 256 colors
    set t_Co=256
    set background=dark
    let g:gruvbox_contrast_dark = 'hard'
    colorscheme gruvbox
else
    let &t_Co = term
endif

""" Enable syntax
syntax enable

""" macOS and Windows copy to native clipboard
set clipboard=unnamed

""" Complete (insert mode completion)
" <C-P> to open menu
set completeopt=menu,menuone,preview,noselect
" open menu on keys
for char in ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    execute "inoremap <expr> ".char." pumvisible() ? \"".char."\" : \"".char."\<C-P>\""
endfor
"" Do not display completion messages
" :help shortmess
" flag c
set shortmess+=c

""" Wildmenu (vim command completion)
set wildmode=list,longest
set wildmenu

""" Whitespaces
set tabstop=4     " tab size
set softtabstop=4 " space size
set shiftwidth=4  " indent width
set expandtab     " spaces for indent

""" Misc
set showcmd " shows the latest command at bottom right

""" Highlights
" Highlight current line
set cursorline
if term >= 256
    hi! LineNr       cterm=NONE ctermfg=239
    hi! CursorLineNr cterm=bold ctermfg=231 ctermbg=57
    hi! Cursorline   cterm=NONE ctermbg=236
    " Links
    hi! link ColorColumn Cursorline
else
    hi! LineNr       cterm=NONE ctermfg=White ctermbg=NONE
    hi! CursorLineNr cterm=inverse ctermfg=Blue ctermbg=NONE
    hi! Cursorline   NONE
    hi! ColorColumn  ctermbg=White
    hi! ErrorMsg     cterm=reverse ctermfg=Red ctermbg=NONE
    hi! Visual       cterm=inverse ctermfg=Magenta ctermbg=NONE
    hi! Search       cterm=inverse ctermfg=Yellow ctermbg=NONE
    hi! Pmenu        ctermbg=White ctermfg=Black
    hi! PmenuSel     cterm=inverse ctermfg=Cyan ctermbg=NONE
    hi! PmenuSbar    ctermbg=White
    hi! PmenuThumb   ctermbg=Gray
    " Syntax
    hi! Comment      ctermfg=Gray
    hi! Type         ctermfg=Blue
    hi! Constant     ctermfg=Yellow
    hi! PreProc      ctermfg=Red
    hi! Statement    ctermfg=Blue
    hi! Special      ctermfg=Red
    hi! Identifier   ctermfg=Magenta
    " Links
    hi! link StatusLineNC LineNr
endif
"" Common highlight overrides
hi! link MatchParen PmenuSel

""" 80 column highlight
if exists('+colorcolumn')
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('ColorColumn', '\%>80v.\+', -1)
endif

""" Misc highlight
set showmatch " hightlight matching paren
set incsearch " search as you type
set hlsearch  " highlight matches

""" Show tab and trailing spaces
set list
" Show tab as >>>> and trailing spaces as ~
set listchars=tab:>>,trail:~
" Set the color of listchars
if term >= 256
    hi SpecialKey cterm=NONE ctermfg=DarkGray
else
    hi SpecialKey cterm=inverse ctermbg=NONE ctermfg=White
endif

""" Status line settings
"" Status line functions
function! Wrap()
    return &wrap ? 'wrap' : 'NOWRAP'
endfunction
function! Whitespace()
    return &expandtab ? 'Spaces' : 'Tab'
endfunction

"" Status line color
hi! link StatusLine PmenuSel

"" Status line arrangement
set laststatus=2
set statusline=
set statusline+=\ \ %f
set statusline+=%m\ 
set statusline+=%#Directory#
set statusline+=\ %{Wrap()},
set statusline+=\ %{Whitespace()},
set statusline+=\ %y
set statusline+=%=
set statusline+=%#Comment#
set statusline+=\ %p%%\ of\ %L
set statusline+=\ lines
set statusline+=\ 

""" Scroll off
set scrolloff=7

""" No auto indent
set noautoindent

""" Toggle line number
set number!
vnoremap <C-B>b :set number!<CR>
nnoremap <C-B>b :set number!<CR>
inoremap <C-B>b <C-O>:set number!<CR>

""" Toggle wrapping
set nowrap!
vnoremap <C-B>z :set nowrap!<CR>
nnoremap <C-B>z :set nowrap!<CR>
inoremap <C-B>z <C-O>:set nowrap!<CR>

""" Window resizing
"vnoremap <C-K> :res +1<CR>
"nnoremap <C-K> :res +1<CR>
"inoremap <C-K> <C-O>:res +1<CR>
"vnoremap <C-L> :res -1<CR>
"nnoremap <C-L> :res -1<CR>
"inoremap <C-L> <C-O>:res -1<CR>
"" Maximize
"noremap <C-K>k <C-W>_

""" Scroll left right
vnoremap <C-K> zh
nnoremap <C-K> zh
inoremap <C-K> <C-O>zh
vnoremap <C-K>k zH
nnoremap <C-K>k zH
inoremap <C-K>k <C-O>zH
vnoremap <C-L> zl
nnoremap <C-L> zl
inoremap <C-L> <C-O>zl
vnoremap <C-L>l zL
nnoremap <C-L>l zL
inoremap <C-L>l <C-O>zL

""" Searching
" Silently search selected word when pressing period in
" normal mode
" <C-r><C-w> is substituted with the current word
" \<foo\> is block search
" N is to return to the current word
"noremap <silent> . /\<<C-r><C-w>\><CR>N
" * does search of the current word
noremap <silent> . *Ne

" Set very magic for every search in normal and visual mode
nnoremap / /\v
vnoremap / /\v
