# Dot files manged by GNU stow

- Setup the dotfiles directory

    ```sh
    # setup your .dotfiles directory under the home directory
    mkdir ~/.dotfiles
    ```

- Use git to clone the repo under .dotfiles

    ```sh
    cd ~/.dotfiles
    git clone https://github.com/ordinarylinuxuser/.dotfiles .git .
    ```

- Install GNU stow on arch

    ```sh
    sudo pacman -S stow
    ```

- initiate the stow (make sure you backup your files and there is no existing config files there.)

    ```sh
    stow .
    ```
