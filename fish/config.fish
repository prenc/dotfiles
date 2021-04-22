fish_vi_key_bindings

alias g='git'
alias gs='git status'
alias gd='git diff'

alias v='vim'

alias ls='lsd'
alias l='ls'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

set -x EDITOR vim
set -x PAGER less
set -x TERM xterm-256color

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end
