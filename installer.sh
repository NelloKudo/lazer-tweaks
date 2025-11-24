#!/usr/bin/env bash

# Setup XDG vars.
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export BINDIR="${BINDIR:-$HOME/.local/bin}"

# Mirrors
OSULINK="https://github.com/ppy/osu/releases/latest/download/osu.AppImage"
TACHYONLINK="https://github.com/ppy/osu/releases/download/2025.1121.0-tachyon/osu.AppImage"
ICONLINK="https://raw.githubusercontent.com/ppy/osu/26da75ecfbb6a928b057c1286d04b54179a11dc7/assets/lazer.png"

print()
{
    echo -e "\033[1;32mScript:\033[0m $*"
}

errorExit()
{
    echo -e "\033[1;31mError:\033[0m $*" >&2
    exit 1
}

pathSetup()
{
    pathcheck=$(echo "$PATH" | grep -q "$BINDIR" && echo "y")

    # If $BINDIR is not in PATH:
    if [ "$pathcheck" != "y" ]; then

        if grep -q "bash" "$SHELL"; then
            touch -a "$HOME/.bashrc"
            echo "export PATH=$BINDIR:$PATH" >>"$HOME/.bashrc"
        fi

        if grep -q "zsh" "$SHELL"; then
            touch -a "$HOME/.zshrc"
            echo "export PATH=$BINDIR:$PATH" >>"$HOME/.zshrc"
        fi

        if grep -q "fish" "$SHELL"; then
            mkdir -p "$HOME/.config/fish" && touch -a "$HOME/.config/fish/config.fish"
            fish -c fish_add_path "$BINDIR/"
        fi
    fi
}

initialSetup()
{
    # AppImages need FUSE: check beforehand it's installation
    if ! command -v fusermount &> /dev/null; then
        errorExit "FUSE is needed for osu!'s AppImage to work, please install it with your package manager."
    fi

    # Avoid failing if CURL is not working/not installed
    if ! command -v curl &> /dev/null; then
        errorExit "curl is needed to download the game, please install it with your package manager."
    fi

    print "Preparing lazer-tweaks installer.."

    # Create configuration directory
    mkdir -p "$XDG_DATA_HOME/lazertweaks"
    mkdir -p "$BINDIR"
    cp ./config.cfg "$XDG_DATA_HOME/lazertweaks"
    cp ./lazertweaks "$BINDIR"

    print "Downloading osu! icon.."
    curl -Lo "$XDG_DATA_HOME/lazertweaks/osu.png" "$ICONLINK"
}

downloadOsu()
{
    # Install tachyon release with --tachyon
    local GAMELINK
    if [ "$1" = "--tachyon" ]; then
        GAMELINK="$TACHYONLINK"
    else
        GAMELINK="$OSULINK"
    fi

    print "Downloading osu!lazer.."
    curl -Lo "$XDG_DATA_HOME/lazertweaks/osu.AppImage" "$GAMELINK"
    chmod +x "$XDG_DATA_HOME/lazertweaks/osu.AppImage"
}

createDesktopEntry()
{
    # Install desktop file based on the given vars.
    print "Installing .desktop file.."

    mkdir -p "$XDG_DATA_HOME/applications"
    echo "[Desktop Entry]
Name=osu!lazer (lt)
Comment=osu!'s next-generation, open-source client!
Type=Application
Exec=$BINDIR/lazertweaks %U
Icon=$XDG_DATA_HOME/lazertweaks/osu.png
Terminal=false
Categories=Game;" | tee "$XDG_DATA_HOME/applications/lazertweaks.desktop" >/dev/null
    chmod +x "$XDG_DATA_HOME/applications/lazertweaks.desktop"
}

initialSetup
downloadOsu
createDesktopEntry

print "Installer has finished, run osu! using lazertweaks or from the application menu."
print "WARNING: You might need to relaunch your terminal for lazertweaks to work."
