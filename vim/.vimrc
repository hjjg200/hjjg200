
""" Swap files
let swapd = $HOME . '/.vim/swap'
let mkdir = system('mkdir -p ' . expand(swapd))
let &directory=swapd . '//'

""" Colors
let is256 = system('tput -T$TERM colors || echo 8') > 8

if is256
    " Set scheme and 256 colors
    set t_Co=256
    set background=dark
    let g:gruvbox_contrast_dark = 'hard'
    colorscheme gruvbox
else
    set t_Co=8
endif

syntax enable " syntax highlighting

""" macOS and Windows clipboard
set clipboard=unnamed

""" Whitespaces
set tabstop=4     " tab size
set softtabstop=4 " space size
set shiftwidth=4  " indent width
set expandtab     " spaces for indent

""" Misc
set showcmd " shows the latest command at bottom right

""" Line highlight
" No highlight for cursorline
" Highlight the number of the current line
set cursorline " highlight current line
if is256
    " Line number color
    hi LineNr       term=NONE cterm=NONE ctermfg=DarkGray
    " Highlighted line number
    hi cursorLineNr term=NONE cterm=NONE ctermfg=White ctermbg=166
    " Slightly highlight current line
    hi cursorline   term=NONE cterm=NONE ctermbg=236
else
    hi LineNr       term=NONE cterm=NONE ctermfg=Black ctermbg=Blue
    hi cursorLineNr term=NONE cterm=NONE ctermfg=White ctermbg=Yellow
    hi cursorline   term=NONE cterm=NONE
endif

""" Column highlight
if exists('+colorcolumn')
    set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

""" Misc highlight
set showmatch " hightlight matching [{(
set incsearch " search as you type
set hlsearch  " highlight matches

""" Show tab and trailing spaces
set list
" Show tab as >--- and trailing spaces as ~
set listchars=tab:>-,trail:~
" Set the color of listchars
if is256
    hi SpecialKey term=NONE cterm=NONE ctermfg=DarkGray
else
    hi SpecialKey term=NONE cterm=NONE ctermfg=Blue
endif

""" Status line functions
function! Wrap()
    return &wrap ? 'wrap' : 'NOWRAP'
endfunction

function! Whitespace()
    return &expandtab ? 'Spaces' : 'Tab'
endfunction

""" Status line color
" hi! overrides
hi! link StatusLine PmenuSel

""" Status line arrangement
set laststatus=2
set statusline=
set statusline+=\ \ %f
set statusline+=%m\ 
set statusline+=%#Normal#
set statusline+=\ %{Wrap()},
set statusline+=\ %{Whitespace()},
set statusline+=\ %y
set statusline+=%=
set statusline+=%#LineNr#
set statusline+=\ %p%%\ of\ %L
set statusline+=\ lines
set statusline+=\ 

""" Toggle line number
set number!

""" No word wrapping
set nowrap! " toggle wrapping

""" Key mappings
" Toggle line number
vnoremap <C-B>b :set number!<CR>
nnoremap <C-B>b :set number!<CR>
inoremap <C-B>b <C-O>:set number!<CR>
" Toggle wrapping
vnoremap <C-B>z :set nowrap!<CR>
nnoremap <C-B>z :set nowrap!<CR>
inoremap <C-B>z <C-O>:set nowrap!<CR>
" Window resizing
vnoremap <C-K> :res +1<CR>
nnoremap <C-K> :res +1<CR>
inoremap <C-K> <C-O>:res +1<CR>
vnoremap <C-L> :res -1<CR>
nnoremap <C-L> :res -1<CR>
inoremap <C-L> <C-O>:res -1<CR>
    " Maximize
noremap <C-K>k <C-W>_

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
