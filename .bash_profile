#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export MANGOHUD=1
export QT_QPA_PLATFORMTHEME=qt6ct
#export GTK_IM_MODULE=fcitx
#export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DOTNET_ROOT=$HOME/.dotnet
export DOTNET_INSTALL_DIR=$HOME/.dotnet
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
export QT_DEVICE_PIXEL_RATIO=2
export QT_AUTO_SCREEN_SCALE_FACTOR=true

export RESOLVE_SCRIPT_API="/opt/resolve/Developer/Scripting"
export RESOLVE_SCRIPT_LIB="/opt/resolve/libs/Fusion/fusionscript.so"
export PYTHONPATH="$PYTHONPATH:$RESOLVE_SCRIPT_API/Modules/"

export PATH=$DOTNET_ROOT:$DOTNET_ROOT/tools:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH
#source $HOME/.nvm/init-nvm.sh # for fedora
source /usr/share/nvm/init-nvm.sh # for arch
