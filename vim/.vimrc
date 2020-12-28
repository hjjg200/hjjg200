
""" Swap files
" Automatically create swap directory and set it as swap location
" It's to prevent committing *.swap
let swapd = $HOME . '/.vim/swap'
let mkdir = system('mkdir -p ' . expand(swapd))
let &directory=swapd . '//'

""" I'm no vi anymore
set nocompatible
set backspace=2

""" Recursive path search
set path+=**

""" Syntax
syntax enable

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

""" macOS and Windows copy to native clipboard
set clipboard=unnamed

""" Complete (insert mode completion)
" <C-P> to open menu
set completeopt=menu,menuone,preview,noselect,noinsert
" Compatibility settings
inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
" Up down arrows in insert mode
inoremap <expr> <C-J> pumvisible() ? "\<C-N>" : "\<C-O>j"
inoremap <expr> <C-K> pumvisible() ? "\<C-P>" : "\<C-O>k"
" open menu on keys
for char in ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    execute "inoremap <expr> ".char." pumvisible() ? \"\<C-E>".char."\<C-P>\" : \"".char."\<C-P>\""
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
    hi! LineNr       cterm=NONE ctermfg=DarkGray ctermbg=NONE
    hi! CursorLineNr cterm=inverse ctermfg=Blue ctermbg=NONE
    hi! Cursorline   NONE
    hi! ColorColumn  ctermbg=DarkGray
    hi! ErrorMsg     cterm=reverse ctermfg=Red ctermbg=NONE
    hi! Visual       cterm=inverse ctermfg=Magenta ctermbg=NONE
    hi! Search       cterm=inverse ctermfg=Yellow ctermbg=NONE
    hi! Pmenu        ctermbg=DarkGray ctermfg=White
    hi! PmenuSel     cterm=inverse ctermfg=Cyan ctermbg=NONE
    hi! PmenuSbar    ctermbg=DarkGray
    hi! PmenuThumb   ctermbg=Gray
    hi! DiffAdd      cterm=inverse,bold ctermfg=Green ctermbg=NONE
    hi! DiffDelete   cterm=inverse,bold ctermfg=Red ctermbg=NONE
    hi! DiffChange   ctermfg=Gray ctermbg=DarkGray
    hi! DiffText     cterm=inverse,bold ctermfg=Yellow ctermbg=NONE
    hi! TabLineSel   cterm=bold ctermfg=White ctermbg=NONE
    hi! TabLineFill  cterm=NONE ctermbg=DarkGray
    hi! TabLine      cterm=NONE ctermbg=DarkGray ctermfg=LightGray
    " Syntax
    hi! Comment      cterm=NONE ctermfg=Gray
    hi! Type         cterm=NONE ctermfg=Blue
    hi! Constant     cterm=NONE ctermfg=Yellow
    hi! Number       cterm=NONE ctermfg=Green
    hi! link Float Number
    hi! link Character Number
    hi! Boolean      cterm=NONE ctermfg=Yellow
    hi! PreProc      cterm=NONE ctermfg=Red
    hi! Statement    cterm=NONE ctermfg=Blue
    hi! Label        cterm=NONE ctermfg=Cyan
    hi! Special      cterm=NONE ctermfg=Red
    hi! Identifier   cterm=NONE ctermfg=Magenta
    hi! Ignore       cterm=NONE ctermfg=DarkGray
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
set listchars=tab:>-,trail:~
" Set the color of listchars
if term >= 256
    hi SpecialKey cterm=NONE ctermfg=DarkGray
else
    hi SpecialKey ctermfg=Cyan
endif

""" Status line settings
"" Status line functions
function! Wrap()
    return &wrap ? 'wrap' : 'NOWRAP'
endfunction
function! Whitespace()
    return &expandtab ? &softtabstop . ' Spaces' : &tabstop . ' Tab'
endfunction

"" Status line color
hi! link StatusLine PmenuSel

"" Status line arrangement
set laststatus=2
set statusline=
set statusline+=\ \ %{expand('%:~:.')}
set statusline+=%m\ 
set statusline+=%#Directory#
set statusline+=\ %{Wrap()},
set statusline+=\ %{Whitespace()},
set statusline+=\ %y
set statusline+=%=
set statusline+=%#Comment#
set statusline+=\ %p%%\ of\ %L
set statusline+=L
set statusline+=\ 

""" Scroll off
set scrolloff=999

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

""" Scroll left, right
function CursorDir()
    let half = winwidth(0) / 2 - 5
    let col = col('.')
    return (col > half) - (col < half)
endfunction

vnoremap <expr> h CursorDir() == 1 ? "zhh" : "h"
nnoremap <expr> h CursorDir() == 1 ? "zhh" : "h"
imap <expr> <C-H> CursorDir() == 1 ? "\<C-O>zh\<C-O>h" : "\<C-O>h"
vnoremap <expr> l CursorDir() == -1 ? "l" : "zll"
nnoremap <expr> l CursorDir() == -1 ? "l" : "zll"
imap <expr> <C-L> CursorDir() == -1 ? "\<C-O>l" : "\<C-O>zl\<C-O>l"

""" Netrw
let g:netrw_banner = 0
let g:netrw_browse_split = 3
let g:netrw_altv = 1
let g:netrw_hide = 0
let g:netrw_liststyle = 3
let g:netrw_list_hide = netrw_gitignore#Hide()

""" Tab
nnoremap <Tab>h gT
nnoremap <Tab><Left> gT
nnoremap <Tab>l gt
nnoremap <Tab><Right> gt

hi TabLineSelNr ctermfg=Magenta ctermbg=NONE
hi TabLineNr ctermfg=Magenta ctermbg=DarkGray
set showtabline=2
set tabline=%!TabLine()

function TabLine()
    let s = ''
    let t = tabpagenr()
    let n = 1
    while n <= tabpagenr('$')

        let sel = n == t
        let bufs = tabpagebuflist(n)
        let winnr = tabpagewinnr(n)
        let buf = bufs[winnr - 1]
        let info = getbufinfo(buf)

        let tc = sel ? "%#TabLineSel#" : "%#TabLine#"
        let s .= tc
        let s .= " "

        let s .= sel ? "%#TabLineSelNr#" : "%#TabLineNr#"
        let s .= info[0].changed ? "+" : n
        let s .= " "
        let s .= tc
        let file = bufname(buf)
        let buftype = getbufvar(buf, 'buftype')
        if file == "NetrwTreeListing"
            let file = "Tree"
        elseif buftype == 'nofile'
            if file =~ '\/.'
                let file = substitute(file, '.*\/\ze.', '', '')
            endif
        else
            let file = fnamemodify(file, ':p:t')
        endif
        if file == ''
            let file = '[No Name]'
        endif
        let s .= file

        let s .= " "

        let n = n + 1
    endwhile
    let s .= "%#TabLineFill#"
    return s
endfunction

""" Searching
" Silently search selected word when pressing period in
" normal mode
" * does search of the current word
noremap <silent> . *Ne

" Set very magic for every search in normal and visual mode
" And starting search automatically clears search
nnoremap / :noh<cr>/\v
vnoremap / :noh<cr>/\v

""" Per-extension settings
" 2 Spaces
for ext in ["yaml", "json", "html", "javascript"]
    execute "autocmd FileType ".ext." setlocal shiftwidth=2 softtabstop=2"
endfor
" Tab
for ext in ["make"]
    execute "autocmd FileType ".ext." setlocal noexpandtab"
endfor

" Python syntax
hi! link pythonSpecial Label
autocmd Syntax python syn keyword pythonSpecial self
autocmd Syntax python syn keyword pythonSpecial cls
