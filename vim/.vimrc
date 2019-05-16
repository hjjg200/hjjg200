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
hi cursorline term=NONE cterm=NONE ctermbg=236
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

" Copy and paste
vmap <C-C> $regy
nmap <C-C> $regy
vmap <C-X> $regd
nmap <C-X> $regd
vmap <C-V> $regP
nmap <C-V> $regP
imap <C-V> <C-O>$regP

" Select all
nnoremap <C-A> ggVG
inoremap <C-A> <ESC>ggVG
vnoremap <C-A> ggVG

" shift+arrow selection if shift+arrow is detected by the terminal
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>
