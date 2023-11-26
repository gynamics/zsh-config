# z-shell configuration file
# forked from kali linux

# options
setopt autocd              # automatically change directory
setopt automenu            # automatically use menu completion
setopt completeinword      # complete in word when expanding
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

# Keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# Completion features
autoload -Uz compinit
compinit -d ${HOME}/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

# History configurations
HISTFILE=${HOME}/.cache/zsh_history
HISTSIZE=1000
SAVEHIST=5000
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_save_no_dups      # do not save duplicated command
#setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_reduce_blanks     # strip commands in history
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history_time  # append command to history file immediately after execution
setopt extended_history
#setopt share_history          # share command history data
# history search
autoload -Uz history-beginning-search-menu
zle -N history-beginning-search-menu
bindkey '!\t' history-beginning-search-menu

# multiline edit with edit-command-line
autoload -Uz edit-command-line
zle -N edit-command-line
# if EDITOR is not set, default vi
zstyle :zle:edit-command-line editor $EDITOR
bindkey '^X^E' edit-command-line
# btw, press ESC RET can wrap newline without evaluation

# archlinux-style prompt
PROMPT="%B%F{white}(%B%F{blue}%~ %B%F{cyan}%#%b%f%k "
# note that the ip addresses are static here, normally they don't change.
# if you want they be dynamic, add a zsh precmd hook for update.
_RPROMPT_COMPONENTS=(
  "%B%(?.%F{blue}⦮.%F{red}%?)"
  "%B%F{white}%n%B%F{blue}@%B%F{yellow}$(ip route|grep -m1 default|
    sed -r 's/.*src ([0-9\.]+) .*/\1/')"
  "%B%F{white}<- %B%F{cyan}$(who -m|cut -d'(' -f2|cut -d ')' -f1)"
  "%B%F{blue}<%B%F{white})"
)
RPROMPT=${_RPROMPT_COMPONENTS[@]}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto' 
    alias pacman='pacman --color=auto'

    export LESS='-R' # enable ANSI escape sequences for less
    export LESS_TERMCAP_mb=$'\e[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\e[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\e[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\e[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
    # enable ANSI escape sequences for groff to produce colorful output
    export GROFF_NO_SGR=0
    export GROFF_SGR=1

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# command aliases
alias ...="../.."
alias ....="../../.."
alias .....="../../../.."
alias d="dirs -v"
alias l="ls -Fh"
alias ll="ls -lFh"
alias la="ls -AFh"
alias lr="ls -tRFh"
alias lla="ls -lAFh"
alias lsp="ps -ef"
# alias fd="find . -type d -name"
alias ff="find . -type f -name"
alias sg="grep -R -nH -C 5 --exclude-dir={.git,.svn,CVS}"
alias cls="clear"
# for kitty if you use it
if [[ $KITTY_WINDOW_ID ]]; then
    alias kt='kitty +kitten'
    alias icat='kitty +kitten icat'
    alias kid='kitty +kitten diff'
    alias klip='kitty +kitten clipboard'
    alias nyaaa='kitty +kitten broadcast'
    alias ssh='kitty +kitten ssh'
fi
