#!/bin/bash

# uncomment the fonts you want
declare -a fonts=(
    # Agave
    # AnonymousPro
    # Arimo
    # AurulentSansMono
    # BigBlueTerminal
    # BitstreamVeraSansMono
    # CascaidaCode
    # CodeNewRoman
    # Cousine
    # DaddyTimeMono
    # DejaVuSansMono
    # DroidSansMono
    # FantasqueSansMono
    # FiraCode
    # FiraMono
    # Go-Mono
    # Gohu
    Hack  # around 17 MB
    # Hasklig
    # HeavyData
    # Hermit
    # iA-Writer
    # IBMPlexMono
    # Inconsolate
    # InconsolataGo
    # InconsolataLGC
    # Iosevka
    # JetBrainsMono
    # Lekton
    # LiberationMono
    # Lilex
    # Meslo
    # Monofur
    # Mononoki
    # Monoid
    # MPlus
    # NerdFontsSymbolsOnly
    # Noto
    # OpenDyslexic
    # Overpass
    # ProFont
    # ProggyClean
    # RobotoMono
    # ShareTechMono
    # Terminus
    # Tinos
    # Ubuntu
    # UbuntuMono
    # VictorMono
)

# enter the version you want
version='3.4.0'

# local location for one user
fonts_dir="${HOME}/.local/share/fonts"

# global location for system wide font installation
# You NEED to be SUDO to install globally
# fonts_dir="/usr/share/fonts/"


if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi

for font in "${fonts[@]}"; do
    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
    echo "Downloading $download_url"
    wget "$download_url"
    unzip "$zip_file" -d "$fonts_dir"
    rm "$zip_file"
done

find "$fonts_dir" -name '*Windows Compatible*' -delete

fc-cache -fv
