# Installation of Arch Linux Base

## Prerequisites

1. Download the latest ISO from the [archlinux.org](https://archlinux.org/download/)

2. Use [Ventoy](https://www.ventoy.net/en/index.html) or [BalenaEthcer](https://etcher.balena.io/) to create a boot-able usb flash drive. (Look through the guide on specific software you are using). I prefer ventoy as it just copy paste your iso & allows multiple boot choice.

3. Boot from the USB. (Each Vendor might have different Keys for this.) (Try F2, F8, F9, F12 or DEL). Or you can just go to BIOS and check it.

4. This is for EFI boot system, not BIOS. (Most new system use EFI anyway, if you want a guide for bios email me i will create a separate guide if requested)

5. This is not for a dual boot approach. (I may have another guide for that please check, if not email me i will create if requested)

## Installation Steps

- Check Internet Connection.
  
  ```sh
  ip link
  ```

- If you are connected via Ethernet it should already show UP status otherwise you can use iwctl utility to connect to wifi. Reference: <https://wiki.archlinux.org/title/Iwd#iwctl>

  ```sh
  iwctl
  device list
  station wlan0 scan # scan for networks
  station wlan0 get-networks 
  station wlan0 connect SSID # connect
  ```

- update the system clock.
  
  ```sh
  timedatectl status
  ```

- Create the partitions. Ideally you want to have /boot /home /root and a swap partitions but you can get away with not having /home partition separately. It's just a preference. We will use [cfdisk](https://man.archlinux.org/man/cfdisk.8.en). It has a nice terminal ui so it makes things easy.

  ```sh
  lsblk # find your disk label it should be sda or sdb in my case it is nvme0n1
  cfdisk /dev/nvme0n1 # Enter the utility modify the disk 
  ```

  - Once entering the utility the create first partition. it should be boot. 500 MB should be more than enough if you don't plan to run multiple kernels, i prefer 1 GB. It's up to you. Make sure it has Type is EFI System
  - Create a swap partition if you want. it's optional. I prefer 10G of swap.
  - Create separate home if you want. here we will be using btrfs file system so it actually not needed.
  - The rest will be a single linux partition. It will look something like below

      | Partition | Size | FileSystem        |
      | --------- | ---- | ----------------- |
      | Boot      | 1G   | EFI System        |
      | SWAP      | 10G  | Linux SWAP        |
      | Root      | Rest | Linux File System |
  - Write the partitions to disk

- We have only created the partitions, we have not formatted or created a file system yet. so let's do that.

  - Format the partitions

    ```sh
    lsblk # check the newly created partitions label
    mkfs.fat -F32 /dev/nvme0n1p1 # format the EFI partition with Fat 32
    mkswap /dev/nvme0n1p2 # set the partition as swap
    swapon /dev/nvme0n1p2 # enable the swap
    mkfs.btrfs /dev/nvme0n1p3 # format the root partition with btrfs
    ```

  - create the btrfs sub volumes

    ```sh
    mount /dev/nvme0n1p3 /mnt # mount the root to /mnt
    btrfs su cr /mnt/@ # root subvol
    btrfs su cr /mnt/@home # home subvol
    btrfs su cr /mnt/@varlog # var log subvol
    btrfs su cr /mnt/@varcache # var cache subvol
    umount /mnt # unmount the partition
    ```

- Now we will prepare for changing root to /mnt (check <https://wiki.archlinux.org/title/Chroot>). Basically we want to have a separate system with its own root. we will use a handy script from arch called [arch-chroot](https://man.archlinux.org/man/arch-chroot.8). but before that we need to prepare for certain thing and mount our partitions to that /mnt path.

  - mount the sub volumes.

    ```sh
    mount -o noatime,compress=zstd,space_cache=v2,subvol=@ /dev/nvme0n1p3 /mnt
    mkdir /mnt/{boot,home,var,opt,tmp} # create the directories
    mkdir /mnt/var/{log,cache} # create the directories
    mount -o noatime,compress=zstd,space_cache=v2,subvol=@home /dev/nvme0n1p3 /mnt/home
    mount -o noatime,compress=zstd,space_cache=v2,subvol=@varlog /dev/nvme0n1p3 /mnt/var/log
    mount -o noatime,compress=zstd,space_cache=v2,subvol=@varcache /dev/nvme0n1p3 /mnt/var/cache
    mount /dev/nvme0n1p1 /mnt/boot # mount the boot
    ```

  - update the mirror list

    ```sh
    reflector --protocol https --country 'Japan' --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
    ```

  - install the essential packages

    ```sh
    pacstrap -K /mnt base linux linux-firmware vi neovim btrfs-progs dosfstools exfatprogs ntfs-3g networkmanager man-db man-pages sof-firmware sof-tools texinfo
    ```

  - generate the fstab. (Linux will use this file to mount your partitions at boot)

    ```sh
    genfstab -U /mnt >>/mnt/etc/fstab # Use -U to use UUID so it's unique
    ```

  - arch-chroot into the new system

    ```sh
    arch-chroot /mnt
    ```

- set time zone

    ```sh
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc
    ```

- set localization

    ```sh
    nvim /etc/locale.gen # uncomment the desired lang
    locale-gen
    echo "LANG=en_US.UTF-8" >>/etc/locale.conf
    ```

- set localhostname

    ```sh
    echo "olu-laptop" >>/etc/hostname
    nvim /etc/hosts
    # #127.0.0.1 localhost
    # #::1  localhost
    # #127.0.1.1 myhostname.localdomain myhostname
    ```

- set root password

    ```sh
    passwd
    ```

- update the pacmanconfig

    ```sh
    nvim /etc/pacman.conf # enable color, paralleldownloads,VerbosePkgList, add ILoveCandy & enable multilib
    ```

- installing essential tools

    ```sh
    pacman -S grub grub-btrfs inotify-tools efibootmgr base-devel linux-headers os-prober reflector git mtools xdg-user-dirs net-tools
    ```

- add btrfs module to mkinitcpio & recreate the image

    ```sh
    nvim /etc/mkinitcpio.conf # MODULES(btrfs)
    mkinitcpio -p linux
    ```

- If you have bluetooth or printer

  ```sh
  pacman -S bluez bluez-utils cups avahi nss-mdns
  nvim /etc/nsswitch.conf #this is for avahi
  #change host line as below
  #hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
  ```

- add a user & add to sudo (wheel) group

  ```sh
   useradd -mG wheel olu
   passwd olu   #set pass for user
   EDITOR=nvim visudo #umcommment %wheel ALL=(ALL) ALL
  ```

- Install the boot-loader grub

  ```sh
  grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchGrub
  #edit the default grub
  nvim /etc/default/grub #enable os-prober #GRUB_DISABLE_OS_PROBER=false (if you have dual boot or OSes)
  grub-mkconfig -o /boot/grub/grub.cfg
  ```

- Enable the services

  ```sh
  systemctl enable NetworkManager
  systemctl enable bluetooth
  systemctl enable cups
  systemctl enable avahi-daemon.service
  ```

- Configure the machine for ssh (make it easy if you are running it into vm)

  ```sh
  pacman -S openssh
  systemctl enable sshd.service
  ```

- exit & restart

  ```sh
  exit
  umount -R /mnt
  shutdown now
  ```

- After reboot login to account

  ```sh
  #if it says change directory faild & can't find home dir & logging in with home ="/" then run following command
  sudo mkhomedir_helper olu (olu is your username)
  # if there are no default xdg directories like Document Downloads etc run following command
  xdg-user-dirs-update 
  nmtui #terminal ui to login to network
  ```

- Install yay for convenience

  ```sh
  cd Documents
  # install yay
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si
  ```

- Install firewall

  ```sh
  sudo pacman -S firewalld
  #enable the firewall
  sudo systemctl enable firewalld.service
  ```

- Install Fonts for different langs

  ```sh
  #install the fonts
  sudo pacman -S adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts ttf-liberation
  ```

- Install pacman-contrib for checkupdates script

  ```sh
  sudo pacman -S pacman-contrib
  ```

- Set RTC Time Clock to local timezone (if you are using dual boot with windows helps to avoid hw clock sync issues)
  
  ```sh
  timedatectl set-local-rtc 1
  ```
