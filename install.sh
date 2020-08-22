#!/bin/bash

mkdir ~/.config

# Tmux stuff
ln -sf tmux.conf ~/.tmux.conf

if [[ ! -f ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Alacritty stuff
mkdir -p ~/.config/alacritty/
ln -sf alacritty.yml ~/.config/alacritty/alacritty.yml

# Vim stuff
ln -sf vimrc ~/.vimrc

if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Fish stuff

mkdir -p ~/.config/fish/functions/

ln -sf fish/config.fish ~/.config/fish/config.fish
ln -sf fish/functions/fish_mode_prompt.fish ~/.config/fish/functions/fish_mode_prompt.fish
ln -sf fish/functions/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish

echo "Dotfiles installed!"
