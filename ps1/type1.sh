#/bin/bash

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

# If root or not
if [[ $EUID == 0 ]]; then
    # root
    CL_USER=$CL_FG_CYAN$CL_BG_RED
    CHAR_USER='#'
else
    # Color array
    CL_USER_BG_COLORS=(2 3 4 7)
    CL_USER_FG_COLORS=(0 1 5 7 0 1 4 5 0 1 3 7 0 1 4 5)
    CL_USER_KEY=$((EUID % 16))
    CL_USER_BG=$((CL_USER_BG_COLORS[CL_USER_KEY / 4] + CL_BG_OFFSET))
    CL_USER_FG=$((CL_USER_FG_COLORS[CL_USER_KEY % 4]))
    # FG color
    if [[ $CL_USER_FG -eq 0 ]]; then
        CL_USER_FG=30
    else
        CL_USER_FG=$((CL_USER_FG + CL_FG_OFFSET))
    fi

    CL_USER="\[\033[$CL_USER_BG;${CL_USER_FG}m\]"
    CHAR_USER='$'
fi



prompt_command () {
    # Get variables
    local FORMATTED_DATE=`date +'%H:%M%z'`

    PS1="$CL_FG_BLACK"
    PS1=$PS1"$CL_BG_CYAN ${FORMATTED_DATE} "
    # Git
    if [ -d .git ] || git rev-parse --git-dir &> /dev/null; then
        local GIT_BRANCH=`git rev-parse --abbrev-ref HEAD` &&
        local UNSTAGED_GIT=`git diff --cached --name-only | wc -l` &&
        {
            [[ $UNSTAGED_GIT > 0 ]] &&
            CL_BG_GIT_BRANCH=$CL_BG_RED$CL_FG_WHITE
        } || {
            CL_BG_GIT_BRANCH=$CL_BG_GREEN
        } &&
        PS1=$PS1"$CL_BG_GIT_BRANCH ($GIT_BRANCH) $CL_FG_BLACK"
    fi
    PS1=$PS1"$CL_BG_MAGENTA $PWD "
    PS1=$PS1"$CL_RESET\n \$"
    
}

export PROMPT_COMMAND=prompt_command
