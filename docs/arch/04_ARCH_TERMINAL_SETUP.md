# Installation of Terminal Setup for ArchLinux

## Prerequisites

1. You have the [Base Installation](01_ARCH_INSTALL_BASE.md) done.

## Installation Steps

- Install Alacritty

     ```sh
     sudo pacman -S alacritty
     ```

- Install zsh & zsh-completion

     ```sh
     sudo pacman -S zsh zsh-completions ttf-hack-nerd ttf-jetbrains-mono-nerd bat fd eza tree
     ```

- Install oh-my-zsh

     ```sh
     sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

     #syntax highlighting
     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

     #auto suggestion
     git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
     ```

- Install fzf

     ```sh
     git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
     ~/.fzf/install
     ```

- Install zoxide

     ```sh
     yay -S zoxide
     ```

- Install tmux and tmux session manager

     ```sh
     yay -S tmux sesh-bin
     ```

- Use the .dotfiles and GNU Stow to set up the dotfiles.
