fish_vi_key_bindings
set fish_greeting

alias ls='lsd'
alias l='ls'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias ll='ls -l'
alias llt='ls -lt'

alias dm='cd ~/Documents'
alias dw='cd ~/Downloads'

alias va='source .venv/bin/activate.fish'

set -gx EDITOR vim
set -gx BROWSER brave
set -gx PAGER less

function fish_user_key_bindings
    for mode in insert default visual
        bind -M $mode \cf forward-char
    end
end

# Auto-activate python venvs for projects that have a local .venv/ at the project root.
# - Activates only when you are in the root (./.venv/bin/activate.fish exists).
# - Stays active while you cd within that project.
# - Deactivates once you leave that project tree.
function __auto_venv --on-variable PWD --description "Auto activate .venv when present"
    set -l pwd_slash "$PWD/"

    if set -q __AUTO_VENV_ROOT; and string match -q -- "$__AUTO_VENV_ROOT*" "$pwd_slash"
        return
    end

    if set -q __AUTO_VENV_ROOT; and not string match -q -- "$__AUTO_VENV_ROOT*" "$pwd_slash"
        if set -q VIRTUAL_ENV; and functions -q deactivate
            deactivate
        end
        set -e __AUTO_VENV_ROOT
    end

    set -l venv_activate "$PWD/.venv/bin/activate.fish"
    if test -f "$venv_activate"
        set -l target_venv "$PWD/.venv"
        if not set -q VIRTUAL_ENV; or test "$VIRTUAL_ENV" != "$target_venv"
            source "$venv_activate"
        end
        set -g __AUTO_VENV_ROOT "$PWD/"
    end
end

__auto_venv
