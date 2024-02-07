# Installation of Arch Linux Hyperland

## Prerequisites

1. You have the [Base Installation](01_ARCH_INSTALL_BASE.md) done.
2. We will be using yay (aur helper) for ease of use. you can just use pacman command directly or if its aur package then use any aur helper.

## Installation Steps

- Install hyprland [[check this](https://wiki.hyprland.org/Getting-Started/Installation/)]

    ```sh
    yay -S hyprland-git
    ```

- Install the SDDM display manager [[check this](https://wiki.hyprland.org/Getting-Started/Master-Tutorial/#launching-hyprland)]

    ```sh
    yay -S sddm-git
    ```

- Enable sddm
  
    ```sh
    sudo systemctl enable sddm
    ```

- Install alacritty , Dolphin & Wofi

    ```sh
    yay -S alacritty dolphin wofi
    ```

- Install Qt Wayland Support

    ```sh
    yay -S qt5-wayland qt6-wayland 
    ```

- Install Sddm themes

    ```sh
    yay -S archlinux-themes-sddm.git
    ```

- Set the current theme

    ```sh
    sudo nvim /etc/sddm.conf
    # add following lines
    # [Theme]
    # Current=archlinux-simplyblack
    ```
