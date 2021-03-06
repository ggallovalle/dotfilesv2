#!/usr/bin/env bash
# fail in case any of the commands fails
set -e
dotfiles=${DOTFILES:-$HOME/.dotfiles}
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
data=${XDG_DATA_HOME:-$HOME/.local/share}

error(){ echo -e "$RED--------------- $* ---------------$NC";  }
positive(){ echo -e "$GREEN--------------- $* ----------------$NC";  }
info(){ echo -e "$YELLOW--------------- $* ----------------$NC";  }

dotbot() {
    "$data/dotbot/bin/dotbot" -d "$dotfiles" --plugin-dir \
        "$dotfiles/.dotbot/plugins" -c "$dotfiles/config.yml" "$@"
}
installer(){
    local cmd="$1" package="$2"
    if ! command -v "$cmd" &> /dev/null; then
        info installing "$package"
        yay -Si "$package"
        yay -S "$package"
    else
        positive "$package" already installed
    fi
}
clonner() {
    if [[ ! -d "$3" ]]; then
        info cloning "$1"
        git clone "${@:2}"
    else
        positive "$1" already cloned
    fi
}

# first clone and setup dotbot
clonner dotbot https://github.com/anishathalye/dotbot "$data/dotbot" --recurse-submodules --jobs 8
info add dotbot to ~/.local/bin
clonner dotbot-plugin https://github.com/ggallovalle/dotbot-plugins "$data/dotbot-plugins"
info add dotbot-plugins to ~/.local/bin
# add dotbot shim to PATH
if [[ ! -d "$HOME/.local/bin" ]]; then
    mkdir "$HOME/.local/bin"
fi
cp ./dotbot "$HOME/.local/bin/dotbot"
info Linking dotfiles
dotbot --only link
# bash -c "${BASEDIR}/dotbot --only link"

clonner zinit https://github.com/zdharma/zinit.git "$data/zinit/bin"

installer emacs emacs
clonner "emacs doom" https://github.com/hlissner/doom-emacs "$HOME/.emacs.d" --depth 1
if [[ ! -x $HOME/.emacs.d/bin/doom ]]; then
    "$HOME/.emacs.d/bin/doom" install --no-config
    info emacs doom doctor
    "$HOME/.emacs.d/bin/doom" doctor
fi

clonner "asdf" https://github.com/asdf-vm/asdf.git "$data/asdf"
if [[ ! -d "$data/asdf" ]]; then
    cd "$data/asdf"
    git checkout "$(git describe --abbrev=0 --tags)"
    cd -
    "$data/asdf/bin/asdf" plugin-add nodejs https://github.com/ggallovalle/asdf-nodejs
    info setting up gpg keys for nodejs
    bash -c "$data/asdf/plugins/nodejs/bin/import-release-team-keyring"
    bash -c "${BASEDIR}/dotbot --only asdf"
fi

if [[ $SHELL = "/bin/bash" ]]; then
    info change default shell from bash to zsh
    chsh -s "$(which zsh)"
fi

if [[ ! -d "$data/fonts" ]]; then
    info downloading fonts
    cd "$data/fonts"
    curl -O https://srv-store6.gofile.io/download/wzom5C/fonts.zip
    unzip fonts.zip
    rm fonts.zip
    cd -
fi

installer tmux tmux
clonner "tmux plugin manager" https://github.com/tmux-plugins/tpm "$data/tmux/tpm"
if [[ -d "$data/tmux" ]]; then
    info install tmux plugins
    bash -c "$data/tmux/tpm/bindings/install_plugins"
fi

installer cowsay cowsay
cowsay -p OK
