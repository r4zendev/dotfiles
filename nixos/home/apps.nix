{ config, pkgs, lib, zen-browser, ... }:

{
  home.packages = with pkgs; [
    # Browsers
    zen-browser.packages.x86_64-linux.default
    firefox
    chromium

    # Communication
    telegram-desktop
    vesktop
    discord
    slack

    # Productivity
    libreoffice
    obsidian
    _1password-gui
    meld
    dialect
    freerdp

    # Media
    vlc
    obs-studio
    gimp
    handbrake
    loupe
    imv
    losslesscut-bin
    youtube-tui

    # File management
    dolphin
    ark
    kdeconnect
    sshfs

    # Torrents
    qbittorrent

    # 3D / CAD / Electronics
    blender
    freecad
    openscad
    kicad
    bambu-studio
    orca-slicer

    # Embedded development
    pkgsCross.arm-embedded.buildPackages.gcc
    picocom

    # System
    mission-center
    pavucontrol
    overskride
    polychromatic
    solaar
    nm-connection-editor
    bluetui
    impala
    evtest
    ydotool
    glances
    unrar

    # USB boot tools
    ventoy-full

    # Crypto
    trezor-suite

    # AI / LLM
    ollama

    # GPU debugging
    renderdoc

    # Android
    android-tools
    imagemagick

    # Music production (TidalCycles)
    supercollider
    ghc
    haskellPackages.tidal

    # OCaml
    opam

    # Web dev
    dart-sass
  ];
}
