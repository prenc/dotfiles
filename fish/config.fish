fish_vi_key_bindings
set fish_greeting

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

set -gx EDITOR vim
set -gx BROWSER firefox
set -gx PAGER less
set -gx TERM xterm-256color

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

