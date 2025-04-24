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

export PATH=$DOTNET_ROOT:$DOTNET_ROOT/tools:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH
source $HOME/.nvm/init-nvm.sh # for fedora
#source /usr/share/nvm/init-nvm.sh # for arch
