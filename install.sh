#!/bin/bash

echo "Copying tmux config..."
ln -sfr tmux.conf ~/.tmux.conf

if [[ ! -f ~/.tmux/plugins/tpm ]]; then
    echo "Installing tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 1>/dev/null
fi

echo "Copying alacritty config..."
mkdir -p ~/.config/alacritty/
ln -sfr alacritty.yml ~/.config/alacritty/alacritty.yml

echo "Copying vim config..."
ln -sfr vimrc ~/.vimrc
ln -sfr ideavimrc ~/.ideavimrc

if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    echo "Installing vimplug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 1>/dev/null
fi

echo "Copying fish config..."
mkdir -p ~/.config/fish/functions/

ln -sfr fish/config.fish ~/.config/fish/config.fish
ln -sfr fish/functions/fish_mode_prompt.fish ~/.config/fish/functions/fish_mode_prompt.fish
ln -sfr fish/functions/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish

echo "Script finished"
