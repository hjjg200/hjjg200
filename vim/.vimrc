syntax enable " syntax highlighting

set tabstop=4 " tab size
set softtabstop=4 " space size
set expandtab " spaces for indent

set showcmd " shows the latest command at bottom right

set cursorline " highlight current line
set showmatch " hightlight matching [{(

set incsearch " search as you type
set hlsearch  " highlight matches

set list
set listchars=tab:>- " Show tab chars as >---
set listchars=trail:~ " Show trailing spaces as ~

" Toggle line numbers with Ctrl-B
set number!
noremap <C-B> :set number!<CR>

" CTRL-K and CTRL-L for resizing
noremap <C-K> :res +1<CR>
noremap <C-L> :res -1<CR>
