# Tips and Tricks for Modding on Linux

- Install the protontricks, wine and winetricks

    ```sh
    sudo pacman -S protontricks-git wine winetricks
    ```

- Most of the time you will need to get the AppId in for the steam game.

    ```sh
    # Get the AppId of the game
    protontricks --list
    ```

- You will probably need to install some dependencies for the game to run properly. You can use protontricks to install them. You can find the dependencies in the winetricks list. [Winetricks List](https://github.com/Winetricks/winetricks/blob/master/files/verbs/all.txt)

    ```sh
    # Install the dependencies for the game
    protontricks <AppId> <dependency>
    ```

- I had a lot of issues because i was settings up the dotnet path in the bashrc file manually. Install dotnet using the os's provided package manager and let system handle the path for you.

    ```sh
    # Install dotnet
    sudo pacman -S dotnet-sdk dotnet-runtime
    ```

- If you want to run the modmanager BG3 Mod Manager or Fluffy Mod manager install relevent .NET runtime using protontricks and then use protontricks-lauch to run the mod manager for that game.

    ```sh
    
    protontricks-lauch --no-bwrap --appid <AppId> <path_to_mod_manager>
    ```

- If you load a dll for reshade etc. you will to add WINEDLLOVERRIDES to the steam launch options for the game. You can do this by right clicking on the game in steam, going to properties and adding the following to the launch options.

    ```sh
    WINEDLLOVERRIDES="dxgi=n,b" %command%

    # multiple overrides can be added like this
    WINEDLLOVERRIDES="dxgi,d3d11=n,b" %command%
    ```

- If you want to enable the HDR mode for the game, you can do that by adding the following to the launch options. Usually i use the [progton-ge-custom](https://github.com/GloriousEggroll/proton-ge-custom) version of proton for this. Some games may not support HDR, so check the game's compatibility first. also make sure you have the HDR enabled in monitor settings.

    ```sh
    PROTON_ENABLE_WAYLAND=1 PROTON_ENABLE_HDR=1 %command%
    ```
