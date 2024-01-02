#!/bin/bash

echo "Setting tmux config..."
ln -sfr tmux.conf ~/.tmux.conf

if [[ ! -f ~/.tmux/plugins/tpm ]]; then
    echo "Installing tpm..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 1>/dev/null
fi

echo "Setting alacritty config..."
mkdir -p ~/.config/alacritty/
ln -sfr alacritty.toml ~/.config/alacritty/alacritty.toml

echo "Setting vim config..."
ln -sfr vimrc ~/.vimrc
ln -sfr ideavimrc ~/.ideavimrc

if [[ ! -f ~/.vim/autoload/plug.vim ]]; then
    echo "Installing vimplug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 1>/dev/null
fi

echo "Setting fish config..."
mkdir -p ~/.config/fish/functions/

ln -sfr fish/config.fish ~/.config/fish/config.fish
ln -sfr fish/functions/fish_mode_prompt.fish ~/.config/fish/functions/fish_mode_prompt.fish
ln -sfr fish/functions/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish

echo "Setting i3 config..."
mkdir -p ~/.config/i3/
ln -sfr i3config ~/.config/i3/config

echo "Script finished"
