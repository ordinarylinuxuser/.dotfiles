# Installation of Arch Linux Hyperland

## Prerequisites

1. You have the [Base Installation](01_ARCH_INSTALL_BASE.md) done.
2. We will be using yay (aur helper) for ease of use. you can just use pacman command directly or if its aur package then use any aur helper.

## Installation Steps

- Install hyprland [[check this](https://wiki.hyprland.org/Getting-Started/Installation/)]

    ```sh
    yay -S hyprland-git
    ```

- Install Universal Wanyland session manager

    ```sh
    yay -S uwsm libnewt

    #add below to shell config file

    if uwsm check may-start && uwsm select; then
        exec uwsm start default
    fi

    #add below if you want to bypass selection menu
    if uwsm check may-start; then
        exec uwsm start hyprland.desktop
    fi

    ```

- Setup the Config file

    ```sh
    nvim ~/.config/hypr/hyprland.conf
    ```

  - remove `autogenerate=1`
  - Modlist
      `SHIFT CAPS CTRL/CONTROL ALT MOD2 MOD3 SUPER/WIN/LOGO/MOD4 MOD5`
  - keywords

    ```text
    three_param_keyword = A, B, C # OK
    three_param_keyword = A, C    # NOT OK
    three_param_keyword = A, , C  # OK
    three_param_keyword = A, B,   # O
    ```

  - You can execute a shell script on, startup of the compositor, every time the config is reloaded, shutdown of the compositor

    - `exec-once = command` will execute only on launch (support rules)
    - `execr-once = command` will execute only on launch
    - `exec = command` will execute on each reload (support rules)
    - `execr = command` will execute on each reload
    - `exec-shutdown` = command will execute only on shutdown
  
  - Source keyword for sourcing other config files

    ```text
    source = ~/.config/hypr/myColors.conf
    ```
  
  - Setup the environment variables

    ```text
    env = XCURSOR_SIZE,24 # dont add quotes
    envd = XCURSOR_SIZE,24 # export to the d-bus (systemd only) 
    env = QT_QPA_PLATFORM,wayland

    uwsm users should avoid placing environment variables in the hyprland.conf file. Instead, use ~/.config/uwsm/env for theming, xcursor, nvidia and toolkit variables, and ~/.config/uwsm/env-hyprland for HYPR* and AQ_* variables. The format is export KEY=VAL.

    Hyprland Environment Variables 
      HYPRLAND_TRACE=1 - Enables more verbose logging.
      HYPRLAND_NO_RT=1 - Disables realtime priority setting by Hyprland.
      HYPRLAND_NO_SD_NOTIFY=1 - If systemd, disables the sd_notify calls.
      HYPRLAND_NO_SD_VARS=1 - Disables management of variables in systemd and dbus activation environments.
      HYPRLAND_CONFIG - Specifies where you want your Hyprland configuration.
    
    Aquamarine Environment Variables 
      AQ_TRACE=1 - Enables more verbose logging.
      AQ_DRM_DEVICES= - Set an explicit list of DRM devices (GPUs) to use. It’s a colon-separated list of paths, with the first being the primary. E.g. /dev/dri/card1:/dev/dri/card0
      AQ_MGPU_NO_EXPLICIT=1 - Disables explicit syncing on mgpu buffers
      AQ_NO_MODIFIERS=1 - Disables modifiers for DRM buffers
    
    Toolkit Backend Variables 
      env = GDK_BACKEND,wayland,x11,* - GTK: Use wayland if available. If not: try x11, then any other GDK backend.
      env = QT_QPA_PLATFORM,wayland;xcb - Qt: Use wayland if available, fall back to x11 if not.
      env = SDL_VIDEODRIVER,wayland - Run SDL2 applications on Wayland. Remove or set to x11 if games that provide older versions of SDL cause compatibility issues
      env = CLUTTER_BACKEND,wayland - Clutter package already has wayland enabled, this variable will force Clutter applications to try and use the Wayland backend
    
    XDG Specifications 
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
    ```
  
  - Setup Monitors

    ```text
    monitor = HDMI-A-1,1920x1080@60,0x0,1 #name,resolution,position,scale
    monitor = DP-1,2560x1440@60,1920x0,2

    # list all monitors
    hyprctl monitors all

    There are a few special values for the resolutions:

    preferred - use the display’s preferred size and refresh rate.
    highres - use the highest supported resolution.
    highrr - use the highest supported refresh rate.
    maxwidth - use the widest supported resolution.
    Position also has a few special values:

    auto - let Hyprland decide on a position. By default, it places each new monitor to the right of existing ones, using the monitor’s top left corner as the root point.
    auto-right/left/up/down - place the monitor to the right/left, above or below other monitors, also based on each monitor’s top left corner as the root.
    auto-center-right/left/up/down - place the monitor to the right/left, above or below other monitors, but calculate placement from each monitor’s center rather than its top left corner.

    #disable monitor
    monitor = name, disable
    ```

  - Window Rules

    ```text
    windowrule = float, class:kitty, title:kitty

    hyprctl dispatch tagwindow +code        # add tag to current window
    hyprctl dispatch tagwindow -- -code     # remove tag from current window (use `--` to protect the leading `-`)
    hyprctl dispatch tagwindow code         # toggle the tag of current window

    # or you can tag windows matched with a window regex
    hyprctl dispatch tagwindow +music deadbeef
    hyprctl dispatch tagwindow +media title:Celluloid

    windowrule = tag +term, class:footclient    # add dynamic tag `term*` to window footclient
    windowrule = tag term, class:footclient     # toggle dynamic tag `term*` for window footclient
    windowrule = tag +code, tag:cpp               # add dynamic tag `code*` to window with tag `cpp`

    windowrule = opacity 0.8, tag:code            # set opacity for window with tag `code` or `code*`
    windowrule = opacity 0.7, tag:cpp             # window with tag `cpp` will match both `code` and `cpp`, the last one will override prior match
    windowrule = opacity 0.6, tag:term*           # set opacity for window with tag `term*` only, `term` will not be matched

    windowrule = tag -code, tag:term              # remove dynamic tag `code*` for window with tag `term` or `term*`

    # example of window rules
    windowrule = move 100 100, class:kitty # moves kitty to 100 100
    windowrule = animation popin, class:kitty # sets the animation style for kitty
    windowrule = noblur, class:firefox # disables blur for firefox
    windowrule = move cursor -50% -50%, class:kitty # moves kitty to the center of the cursor
    windowrule = bordercolor rgb(FF0000) rgb(880808), fullscreen:1 # set bordercolor to red if window is fullscreen
    windowrule = bordercolor rgb(00FF00), fullscreenstate:* 1 # set bordercolor to green if window's client fullscreen state is 1(maximize) (internal state can be anything)
    windowrule = bordercolor rgb(FFFF00), title:.*Hyprland.* # set bordercolor to yellow when title contains Hyprland
    windowrule = opacity 1.0 override 0.5 override 0.8 override, class:kitty # set opacity to 1.0 active, 0.5 inactive and 0.8 fullscreen for kitty
    windowrule = rounding 10, class:kitty # set rounding to 10 for kitty
    windowrule = stayfocused,  class:(pinentry-)(.*) # fix pinentry losing focus
    ```

- Install alacritty , Dolphin & Wofi

    ```sh
    yay -S alacritty dolphin wofi
    ```

- Install Qt Wayland Support

    ```sh
    yay -S qt5-wayland qt6-wayland 
    ```
