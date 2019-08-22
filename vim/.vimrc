
let termColors = system('tput -T$TERM colors || echo 8')

if termColors > 8
    " Set scheme and 256 colors
    set t_Co=256
    set background=dark
    colorscheme gruvbox
else
    set t_Co=8
endif

syntax enable " syntax highlighting

set tabstop=4 " tab size
set softtabstop=4 " space size
set shiftwidth=4 " indent width
set expandtab " spaces for indent

set showcmd " shows the latest command at bottom right

" No highlight for cursorline
" Highlight the number of the current line
set cursorline " highlight current line
if termColors > 8
    hi LineNr term=NONE cterm=NONE ctermfg=DarkGray
    hi cursorLineNr term=NONE cterm=NONE ctermfg=White ctermbg=166
    hi cursorline term=NONE cterm=NONE ctermbg=236
else
    hi LineNr term=NONE cterm=NONE ctermfg=Black ctermbg=Blue
    hi cursorLineNr term=NONE cterm=NONE ctermfg=White ctermbg=Yellow
    hi cursorline term=NONE cterm=NONE
endif
set showmatch " hightlight matching [{(

set incsearch " search as you type
set hlsearch  " highlight matches

set list
" Show tab as >--- and trailing spaces as ~
set listchars=tab:>-,trail:~
    " Set the color of listchars
if termColors > 8
    hi SpecialKey term=NONE cterm=NONE ctermfg=DarkGray
else
    hi SpecialKey term=NONE cterm=NONE ctermfg=Blue
endif

" Toggle number
set number!

" Enable line wrapping
set wrap " nowrap is no wrapping

" Key mappings
    " Toggle line number
vnoremap <C-B>b :set number!<CR>
nnoremap <C-B>b :set number!<CR>
inoremap <C-B>b <C-O>:set number!<CR>
    " Syntax shorthand
vnoremap <C-B>n :set syntax=
nnoremap <C-B>n :set syntax=
inoremap <C-B>n <C-O>:set syntax=
    " Tab size shortand
vnoremap <C-B>m :set softtabstop=
nnoremap <C-B>m :set softtabstop=
inoremap <C-B>m <C-O>:set softtabstop=
    " Resizing
noremap <C-K> :res +1<CR>
noremap <C-L> :res -1<CR>
    " Silently search selected word when pressing period in
    " normal mode
    " <C-r><C-w> is substituted with the current word
    " \<foo\> is block search
    " N is to return to the current word
"noremap <silent> . /\<<C-r><C-w>\><CR>N
    " * does search of the current word
noremap <silent> . *N

" Set very magic for every search in normal and visual mode
nnoremap / /\v
vnoremap / /\v

" Select all
nnoremap <C-A> ggVG
inoremap <C-A> <ESC>ggVG
vnoremap <C-A> ggVG
