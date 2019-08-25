#/bin/bash

# Font
if [[ "$OSTYPE" == darwin* ]]; then
    CHAR_USER="→"
elif [[ "$OSTYPE" == linux-gnu ]]; then
    if [[ "$XDG_CURRENT_DESKTOP" != "" ]]; then
        CHAR_USER="→"
    else
        CHAR_USER="=>"
    fi
fi

# Colors
CL_NUM=`tput -T$TERM colors`
CL_RESET='\[\033[0m\]'
CL_FG_BLACK='\[\033[30m\]'
if which tput &> /dev/null && [[ $CL_NUM -gt 8 ]]; then
    # More than 8 colors
    # The colors here are lighter versions
    CL_FG_RED='\[\033[91m\]'
    CL_FG_GREEN='\[\033[92m\]'
    CL_FG_YELLOW='\[\033[93m\]'
    CL_FG_BLUE='\[\033[34m\]' # Dark blue
    CL_FG_MAGENTA='\[\033[95m\]'
    CL_FG_CYAN='\[\033[96m\]'
    CL_FG_WHITE='\[\033[97m\]'

    # BG
    CL_BG_RED='\[\033[101m\]'
    CL_BG_GREEN='\[\033[102m\]'
    CL_BG_YELLOW='\[\033[103m\]'
    CL_BG_BLUE='\[\033[104m\]'
    CL_BG_MAGENTA='\[\033[105m\]'
    CL_BG_CYAN='\[\033[106m\]'
    CL_BG_WHITE='\[\033[107m\]'

    CL_FG_OFFSET=90
    CL_BG_OFFSET=100
else
    # No colors or 8 colors
    CL_FG_RED='\[\033[31m\]'
    CL_FG_GREEN='\[\033[32m\]'
    CL_FG_YELLOW='\[\033[33m\]'
    CL_FG_BLUE='\[\033[34m\]'
    CL_FG_MAGENTA='\[\033[35m\]'
    CL_FG_CYAN='\[\033[36m\]'
    CL_FG_WHITE='\[\033[37m\]'

    # BG
    CL_BG_RED='\[\033[41m\]'
    CL_BG_GREEN='\[\033[42m\]'
    CL_BG_YELLOW='\[\033[43m\]'
    CL_BG_BLUE='\[\033[44m\]'
    CL_BG_MAGENTA='\[\033[45m\]'
    CL_BG_CYAN='\[\033[46m\]'
    CL_BG_WHITE='\[\033[47m\]'

    CL_FG_OFFSET=30
    CL_BG_OFFSET=40
fi

# User colors
declare -a CL_USER_ARRAY
CL_USER_ARRAY[0]=$CL_BG_RED$CL_FG_CYAN
CL_USER_ARRAY[1]=$CL_BG_BLUE$CL_FG_BLACK
CL_USER_ARRAY[2]=$CL_BG_GREEN$CL_FG_RED
CL_USER_ARRAY[3]=$CL_BG_WHITE$CL_FG_BLUE
CL_USER_ARRAY[4]=$CL_BG_BLUE$CL_FG_MAGENTA
CL_USER_ARRAY[5]=$CL_BG_WHITE$CL_FG_BLACK
CL_USER_ARRAY[6]=$CL_BG_WHITE$CL_FG_RED
CL_USER_ARRAY[7]=$CL_BG_YELLOW$CL_FG_BLUE
CL_USER_ARRAY[8]=$CL_BG_GREEN$CL_FG_WHITE
CL_USER_ARRAY[9]=$CL_BG_YELLOW$CL_FG_BLACK
CL_USER_ARRAY[10]=$CL_BG_BLUE$CL_FG_WHITE
CL_USER_ARRAY[11]=$CL_BG_GREEN$CL_FG_MAGENTA
CL_USER_ARRAY[12]=$CL_BG_GREEN$CL_FG_BLACK

if [[ $EUID -eq 0 ]]; then
    CL_USER=${CL_USER_ARRAY[0]}
else
    CL_USER=${CL_USER_ARRAY[$((EUID % 12 + 1))]}
fi

prompt_command () {
    RETURN_CODE=$?

    # Get variables
    local FORMATTED_DATE=`date +'%H:%M%z'`
    DATE_MINUTES=$((`date +%s` / 60))

    PS1=
    GIT_BRANCH=
    if [ -d .git ] || git rev-parse --git-dir &> /dev/null; then
        GIT_BRANCH=`git rev-parse --abbrev-ref HEAD`
        GIT_UNCOMMITTED=`git diff HEAD --name-only | wc -l`
        if [[ $GIT_UNCOMMITTED -gt 0 ]]; then
            GIT_STATUS=uncommitted
        else
            # @{u} indicates the upstream branch
            GIT_UNPUSHED=`git diff @{u}..HEAD --name-only | wc -l`
            if [[ $GIT_UNPUSHED -gt 0 ]]; then
                GIT_STATUS=unpushed
            else
                GIT_STATUS=
            fi
        fi
    fi
    if [[ "$LAST_DATE_MINUTES" -ne "$DATE_MINUTES" ]]; then
        PS1="$CL_FG_BLACK"
        PS1=$PS1"$CL_USER \u@\H $CL_FG_BLACK"
        PS1=$PS1"$CL_BG_CYAN ${FORMATTED_DATE} "
        PS1=$PS1"$CL_RESET\n"
    fi

    PS1=$PS1"\$([ \j -gt 0 ] && echo \"(\j) \")"

    # Git
    if [[ $GIT_BRANCH != "" ]]; then
        # Per status
        {
            [[ $GIT_STATUS == "uncommitted" ]] &&
            CL_BG_GIT_BRANCH=$CL_FG_RED
        } || {
            [[ $GIT_STATUS == "unpushed" ]] &&
            CL_BG_GIT_BRANCH=$CL_FG_YELLOW
        } || {
            CL_BG_GIT_BRANCH=$CL_FG_GREEN
        } && {
            PS1=$PS1"$CL_BG_GIT_BRANCH($GIT_BRANCH) "
        }
    fi
    PS1=$PS1"$CL_FG_YELLOW\W "
    [[ $RETURN_CODE -ne 0 ]] && PS1=$PS1$CL_FG_RED ||
        PS1=$PS1$CL_FG_GREEN
    PS1=$PS1"$CHAR_USER $CL_RESET"

    LAST_DATE_MINUTES=$DATE_MINUTES
    LAST_GIT_STATUS=$GIT_STATUS
}

export PROMPT_COMMAND=prompt_command
