
curl -s https://raw.githubusercontent.com/hjjg200/hjjg200/master/vim/.vimrc > ~/.vimrc
vimrc=$(cat ~/.vimrc)

if [ "$TERM" = 'xterm-256color' ]; then

    if [ ! -d "$HOME/.vim" ]; then
        mkdir ~/.vim
    fi
    if [ ! -d "$HOME/.vim/colors" ]; then
        mkdir ~/.vim/colors
    fi
    curl -s https://raw.githubusercontent.com/hjjg200/gruvbox/master/colors/gruvbox.vim > ~/.vim/colors/gruvbox.vim

    vimrcHead='
" Set scheme and 256 colors
set t_Co=256
set background=dark
colorscheme gruvbox

'

    vimrc="$vimrcHead$vimrc"
    echo "$vimrc" > ~/.vimrc

fi