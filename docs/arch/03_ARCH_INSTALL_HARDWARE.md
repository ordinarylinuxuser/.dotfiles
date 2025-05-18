# Installation of Hardware Drivers for Arch Linux Gnome

## Prerequisites

1. You have the [Base Installation](01_ARCH_INSTALL_BASE.md) done.

## Installation Steps

- check the graphics cards & install

    ```sh
    lspci -k | grep -A 2 -E "(VGA|3D)"
    ```

  - For intel

    ```sh
    sudo pacman -S mesa xf86-video-intel vulkan-intel sof-firmware sof-tools #xf86-video-intel for the DDX 2d acceleration in xorg (for the sound sof-firmware (took way too long to figure it out since my laptop didn't detect it))
    sudo pacman -S intel-media-driver libva-utils #for VA- API
    ```

  - For amd

    ```sh
    sudo pacman -S mesa xf86-video-amdgpu vulkan-radeon opencl-amd
    ```

  - For vulkan support

    ```sh
    sudo pacman -S vulkan-icd-loader vulkan-tools vulkan-mesa-layers #vulkan support
    ```

  - For nvidia

    ```sh
    #install nvidia package (For the Maxwell (NV110/GM XXX ) series and newer)
    sudo pacman -S nvidia nvidia-utils #nvidia-lts for lts kernal // For kepler series nvidia-470xx-dkms // For fermi nvidia-390xx-dkms
    sudo nvim /etc/mkinitcpio.conf #remove the kms hook & rebuild the initcpio & reboot (after the nvidia is detected re add it)
    ```

- Audio driver install

    ```sh
    sudo pacman -S pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber
    
    #enable the sound
    systemctl enable --user pipewire
    systemctl enable --user pipewire-pulse
    systemctl enable --user wireplumber
    ```

- Install printer driver (purely optional you may not even need if it works automatically)

    ```sh
    yay -S epson-inkjet-printer-escpr
    ```
