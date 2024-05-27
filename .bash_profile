#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export MANGOHUD=0
export QT_QPA_PLATFORMTHEME=qt6ct
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DOTNET_ROOT=$HOME/.dotnet
export DOTNET_INSTALL_DIR=$HOME/.dotnet
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$DOTNET_ROOT:$DOTNET_ROOT/tools:$PATH
source /usr/share/nvm/init-nvm.sh

