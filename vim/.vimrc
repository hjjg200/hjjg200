syntax enable " syntax highlighting

set tabstop=4 " tab size
set softtabstop=4 " space size
set shiftwidth=4 " indent width
set expandtab " spaces for indent

set showcmd " shows the latest command at bottom right

" No highlight for cursorline
" Highlight the number of the current line
set cursorline " highlight current line
hi LineNr term=NONE cterm=NONE ctermfg=DarkGray
hi cursorLineNr term=NONE cterm=NONE ctermfg=White ctermbg=166
hi cursorline term=NONE cterm=NONE ctermbg=237
set showmatch " hightlight matching [{(

set incsearch " search as you type
set hlsearch  " highlight matches

set list
" Show tab as >--- and trailing spaces as ~
set listchars=tab:>-,trail:~
    " Set the color of listchars
hi SpecialKey term=NONE cterm=NONE ctermfg=DarkGray

" Toggle number
set number!

" Enable line wrapping
set wrap " nowrap is no wrapping

" Key mappings
    " Toggle line number
noremap <C-B>b :set number!<CR>
    " Syntax shorthand
noremap <C-B>n :set syntax=
    " Tab size shortand
noremap <C-B>m :set softtabstop=
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
