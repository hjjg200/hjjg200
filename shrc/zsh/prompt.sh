#!/bin/zsh

git_branch() {

    br=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [ -z $br ]; then
        return 0
    fi

    uc=$(git diff HEAD --name-only | wc -l)
    up=$(git diff @{u}..HEAD --name-only | wc -l)

    m=
    if [ $((uc + up)) -gt 0 ]; then
        m="[+]"
    fi

    echo "$br$m"

}

hrmin() {
    date +'%H:%M'
}

rpcmd() {

    # Vars
    o=

    # Git
    o=$o'%F{cyan}'$(git_branch)'%f'

    echo $o

}

pcmd() {

    # Return code
    lr=$?

    # Vars
    chr=→
    o=

    # Dir
    o=$o'%F{blue}%2d%f '

    # Return status
    if [ $lr -eq 0 ]; then
        cl='%F{green}'
    else
        cl='%F{red}'
    fi
    o=$o$cl$chr%f

    echo $o

}

# Set prompt substitution
setopt prompt_subst

# Prompt
RPROMPT='%B$(rpcmd)%b'
prompt='%B$(pcmd) %b'

# Bold command input
zle_highlight=(default:bold)
