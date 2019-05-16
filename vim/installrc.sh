
curl -s https://raw.githubusercontent.com/hjjg200/hjjg200/master/vim/.vimrc?t=$(date +%s) > ~/.vimrc
vimrc=$(cat ~/.vimrc)

# Substitue Register in .vimrc
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    reg='"p' # p register for linux
else
    reg='"*' # Clipboard
fi
vimrc=$(sed "s/\$reg/$reg/g" <<< "$vimrc")

# If 256 color supported
if [ "$TERM" = 'xterm-256color' ]; then

    if [ ! -d "$HOME/.vim" ]; then
        mkdir ~/.vim
    fi
    if [ ! -d "$HOME/.vim/colors" ]; then
        mkdir ~/.vim/colors
    fi
    curl -s https://raw.githubusercontent.com/hjjg200/gruvbox/master/colors/gruvbox.vim?t=$(date +%s) > ~/.vim/colors/gruvbox.vim

    vimrcHead='
" Set scheme and 256 colors
set t_Co=256
set background=dark
colorscheme gruvbox

'

    vimrc="$vimrcHead$vimrc"
    echo "$vimrc" > ~/.vimrc

fi
