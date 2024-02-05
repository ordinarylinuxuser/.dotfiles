# Arch Linux Essential Apps

## Prerequisites

1. You have the [Base Installation](01_ARCH_INSTALL_BASE.md) done.

## Installation Steps

- Install reflector Simple

    ```sh
    yay -S reflector-simple
    ```

- If you need a gui software installer (since software center on gnome will only provide flatpak support) install octopi. (I am not too fond of pamac, if you like that you can install that, your choice)

    ```sh
    yay -S octopi
    ```

- Install brower of your choosing

    ```sh
    sudo pacman -S firefox
    ```

- Install ventoy (if you want to make a usb live disk)

    ```sh
    yay -S ventoy-bin
    ```

- Install Libreoffice from flathub or software center. https://flathub.org/apps/org.libreoffice.LibreOffice

- Grub Customizer.

    ```sh
    #install grub customizer
    sudo pacman -S grub-customizer
    ```

### For Gaming Setup

- Install steam. (You can use flatpak version if you like but i like the native packages.)
  
    ```sh
    # install the steam
    sudo pacman -S steam-native-runtime
    
    # install vulkan tools if you like
    sudo pacman -S vulkan-tools
    
    #install the directx 9 to 12 support
    yay -S dxvk-bin vkd3d

    #install wine for .net apps
    sudo pacman -S wine
    ```

- Install protonup-qt for managing the proton versions
  
  ```sh
  yay -S protonup-qt
  ```
