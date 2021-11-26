fish_vi_key_bindings

alias v='vim'

alias gs='git status'

alias ls='lsd'
alias l='ls'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias llt='ll -t'

alias dm='cd ~/Documents'
alias dw='cd ~/Downloads'

set -x EDITOR vim
set -x BROWSER firefox
set -x PAGER less
set -x TERM xterm-256color

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end
