# Installation of Arch Linux KDE

## Video Tutorial

[![ARCH POST INSTALL](https://img.youtube.com/vi/YxQuUV_Ishc/0.jpg)](https://www.youtube.com/watch?v=YxQuUV_Ishc)

## Prerequisites

1. You have the [Base Installation](01_ARCH_INSTALL_BASE.md) done. check video here.
   [![ARCH BASE INSTALL](https://img.youtube.com/vi/LtHysGTXt_w/0.jpg)](https://www.youtube.com/watch?v=LtHysGTXt_w)
2. We will be using yay (aur helper) for ease of use. you can just use pacman command directly or if its aur package then use any aur helper.

## Installation Steps

- Install the minimal kde desktop

    ```sh
    yay -S plasma-desktop kde-system kde-utilities konsole kscreen
    # use qt6-multimedia-ffmpeg,phono-qt6-mpv if asked
 
    ```

- Install the sddm display manager

    ```sh
    yay -S sddm sddm-kcm
    sudo systemctl enable sddm.service
    ```

- Install essential softwares

   ```sh
    yay -S octopi
    # just use octopi to look into plasma and kde groups and install the stuff you need
    ```

- Reboot your system

    ```sh
    reboot
    ```
