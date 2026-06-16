{ config, pkgs, inputs, ... }:

let
  dots = "/home/razen/projects/dotfiles";
  link = p: config.lib.file.mkOutOfStoreSymlink "${dots}/${p}";
  localPkgs = import ../pkgs { inherit pkgs; };
  bambuPkgs = import inputs.nixpkgs-bambu {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
  llamaPkgs = import inputs.nixpkgs-llamacpp {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  imports = [ inputs.dms.homeModules.dank-material-shell ];

  home.username = "razen";
  home.homeDirectory = "/home/razen";
  home.stateVersion = "25.05";

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.sessionVariables.EDITOR = "nvim";

  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
  };

  programs.git.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  systemd.user.services =
    let
      graphical = desc: exec: {
        Unit = {
          Description = desc;
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = exec;
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    in
    {
      hyprwhspr = graphical "hyprwhspr speech-to-text daemon" "${localPkgs.hyprwhspr}/bin/hyprwhspr";
      wl-clip-persist = graphical "Keep clipboard contents after the source window closes" "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular --all-mime-type-regex '(?i)^(?!(?:image|audio|video|font|model)/).+'";
      solaar = graphical "Logitech device manager" "${pkgs.solaar}/bin/solaar --window=hide";
      arrpc = graphical "arRPC Discord rich presence bridge" "${pkgs.arrpc}/bin/arrpc";
    };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      name = "Noto Sans";
      size = 10;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme.name = "Matugen-Mono";
    gtk4.theme = null;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk3.extraCss = ''@import url("matugen.css");'';
    gtk4.extraCss = ''@import url("matugen.css");'';
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
    style.name = "breeze";
    style.package = pkgs.kdePackages.breeze;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    extraConfig.PROJECTS = "$HOME/projects";
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    monospace-font-name = "Monaspace Argon 10";
  };

  xdg.mimeApps =
    let
      defaults = {
        "application/x-extension-htm" = "zen.desktop";
        "application/x-extension-html" = "zen.desktop";
        "application/x-extension-shtml" = "zen.desktop";
        "application/x-extension-xht" = "zen.desktop";
        "application/x-extension-xhtml" = "zen.desktop";
        "application/xhtml+xml" = "zen.desktop";
        "text/html" = "zen.desktop";
        "x-scheme-handler/chrome" = "zen.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "x-scheme-handler/about" = "zen.desktop";
        "x-scheme-handler/unknown" = "zen.desktop";
        "image/bmp" = "qimgv.desktop";
        "image/gif" = "qimgv.desktop";
        "image/jpeg" = "qimgv.desktop";
        "image/png" = "qimgv.desktop";
        "image/webp" = "qimgv.desktop";
        "image/avif" = "qimgv.desktop";
        "image/svg+xml" = "org.gnome.Loupe.desktop";
        "video/mp4" = "vlc.desktop";
        "video/webm" = "vlc.desktop";
        "video/x-matroska" = "vlc.desktop";
        "video/avi" = "vlc.desktop";
        "video/mkv" = "vlc.desktop";
        "application/json" = "nvim.desktop";
        "text/plain" = "nvim.desktop";
        "application/zip" = "org.kde.ark.desktop";
        "application/x-tar" = "org.kde.ark.desktop";
        "application/x-compressed-tar" = "org.kde.ark.desktop";
        "application/x-bzip-compressed-tar" = "org.kde.ark.desktop";
        "application/x-xz-compressed-tar" = "org.kde.ark.desktop";
        "application/gzip" = "org.kde.ark.desktop";
        "application/x-gzip" = "org.kde.ark.desktop";
        "application/x-bzip" = "org.kde.ark.desktop";
        "application/x-7z-compressed" = "org.kde.ark.desktop";
        "application/vnd.rar" = "org.kde.ark.desktop";
        "application/x-rar" = "org.kde.ark.desktop";
        "application/x-archive" = "org.kde.ark.desktop";
        "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";
        "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
        "x-scheme-handler/discord" = "vesktop.desktop";
        "inode/directory" = "org.kde.dolphin.desktop";
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      };
    in
    {
      enable = true;
      associations.added = defaults;
      defaultApplications = defaults;
    };

  xdg.configFile = {
    "nvim".source = link "config/nvim";
    "fish".source = link "config/fish";
    "ghostty".source = link "config/ghostty";
    "tmux".source = link "config/tmux";
    "yazi".source = link "config/yazi";
    "btop".source = link "config/btop";
    "lazydocker".source = link "config/lazydocker";
    "lazygit".source = link "config/lazygit";
    "sesh".source = link "config/sesh";
    "gh".source = link "config/gh";
    "gh-dash".source = link "config/gh-dash";
    "opencode".source = link "config/opencode";
    "starship.toml".source = link "config/starship.toml";
    "matugen".source = link "config/matugen";
    "DankMaterialShell".source = link "config/DankMaterialShell";
    "mango".source = link "config/mango";
    "hypr/hyprland.lua".source = link "config/hypr/hyprland.lua";
    "hypr/xdph.conf".source = link "config/hypr/xdph.conf";
    "hypr/scripts".source = link "config/hypr/scripts";
    "menus/applications.menu".text = ''
      <!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN" "http://www.freedesktop.org/standards/menu-spec/1.0/menu.dtd">
      <Menu>
        <Name>Applications</Name>
        <DefaultAppDirs/>
        <DefaultDirectoryDirs/>
        <Include><All/></Include>
      </Menu>
    '';
  };

  xdg.desktopEntries.nvim = {
    name = "Neovim";
    exec = "ghostty --class=ghostty.nvim -e nvim %F";
    terminal = false;
    mimeType = [ "text/plain" "text/english" "text/x-makefile" "text/x-c++src" "text/x-csrc" "text/x-java" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
  };

  xdg.desktopEntries.claude-code-url-handler = {
    name = "Claude Code URL Handler";
    exec = "claude --handle-uri %u";
    noDisplay = true;
    mimeType = [ "x-scheme-handler/claude-cli" ];
  };

  xdg.desktopEntries."org.telegram.desktop" = {
    name = "Telegram";
    exec = "Telegram -scale 110 -- %U";
    icon = "org.telegram.desktop";
    terminal = false;
    categories = [ "Chat" "Network" "InstantMessaging" ];
    mimeType = [ "x-scheme-handler/tg" "x-scheme-handler/tonsite" ];
    settings.StartupWMClass = "TelegramDesktop";
  };

  xdg.desktopEntries.BambuStudio = {
    name = "BambuStudio";
    exec = "env GDK_BACKEND=x11 WEBKIT_DISABLE_DMABUF_RENDERER=1 WEBKIT_DISABLE_COMPOSITING_MODE=1 __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json MESA_LOADER_DRIVER_OVERRIDE=zink GALLIUM_DRIVER=zink bambu-studio %U";
    icon = "BambuStudio";
    terminal = false;
    categories = [ "Graphics" "3DGraphics" "Engineering" ];
    mimeType = [ "model/stl" "model/3mf" "application/vnd.ms-3mfdocument" "application/prs.wavefront-obj" "application/x-amf" "x-scheme-handler/bambustudio" ];
  };

  xdg.desktopEntries."org.freecad.FreeCAD" = {
    name = "FreeCAD";
    exec = "env QT_QPA_PLATFORM=xcb FreeCAD - --single-instance %F";
    icon = "org.freecad.FreeCAD";
    terminal = false;
    categories = [ "Graphics" "Engineering" ];
    mimeType = [ "application/x-extension-fcstd" ];
  };

  xdg.desktopEntries."com.github.th_ch.youtube_music" = {
    name = "Pear Desktop";
    exec = "pear-desktop --force-device-scale-factor=1.10 %U";
    icon = "pear-desktop";
    terminal = false;
    categories = [ "AudioVideo" ];
  };

  xdg.configFile."vesktop-flags.conf".text = ''
--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,VaapiVideoDecoder,WaylandWindowDecorations,UseOzonePlatform,WebRTCPipeWireCapturer
--ozone-platform=wayland
--enable-gpu-rasterization
--enable-zero-copy
--ignore-gpu-blocklist
--enable-hardware-overlays
--disable-gpu-driver-bug-workarounds
--use-gl=angle
--force-device-scale-factor=1.10
  '';

  home.file = {
    ".gitconfig".source = link "home/files/.gitconfig";
    ".editorconfig".source = link "home/files/.editorconfig";
    ".npmrc".source = link "home/files/.npmrc";
    ".rgignore".source = link "home/files/.rgignore";
    ".gitignore_global".source = link "home/files/.gitignore_global";
    ".dblab.yaml".source = link "home/files/.dblab.yaml";
    ".claude/CLAUDE.md".source = link "home/files/claude/CLAUDE.md";
    ".local/bin/wallpaper-state".source = link "bin/wallpaper-state";
    ".local/bin/tmux-layout-picker".source = link "bin/tmux-layout-picker";
    ".local/bin/theme-terminals".source = link "bin/theme/terminals";
    ".local/bin/theme-gtk".source = link "bin/theme/gtk";
    ".local/bin/theme-hyprland".source = link "bin/theme/hyprland";
    ".local/bin/theme-kde".source = link "bin/theme/kde";
    ".local/bin/theme-zen".source = link "bin/theme/zen";
    ".local/bin/theme-telegram".source = link "bin/theme/telegram";
    ".local/bin/theme-icons".source = link "bin/theme/icons";
    ".local/bin/theme-vesktop".source = link "bin/theme/vesktop";
    ".local/share/kio/servicemenus/admin-folder.desktop".source = link "home/files/kio/admin-folder.desktop";
    ".local/share/tmux-plugins/resurrect".source = "${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect";
    ".local/share/tmux-plugins/continuum".source = "${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum";
  };

  home.packages = with pkgs; [
    # shell & terminal
    ghostty
    tmux
    helix
    yazi
    starship
    fishPlugins.autopair
    zoxide
    sesh
    fzf

    # cli utils
    lsd
    bat
    fd
    ripgrep
    fx
    tealdeer
    gdu
    gnupg
    unzip
    (p7zip.override { enableUnfree = true; })
    imagemagick

    # git & dev workflow
    lazygit
    gh
    gh-dash
    delta
    difftastic
    lazydocker
    dblab

    # languages & build
    gcc
    gnumake
    python3
    uv
    tree-sitter

    # lsps, formatters, debug
    nixd
    lua-language-server
    stylua
    vtsls
    typescript-go
    vscode-langservers-extracted
    biome
    prettierd
    tailwindcss-language-server
    marksman
    yaml-language-server
    fish-lsp
    hyprls
    pyright
    typos-lsp
    tinymist
    bash-language-server
    vscode-js-debug

    # ai
    (llamaPkgs.llama-cpp.override { cudaSupport = true; })
    opencode

    # wayland & desktop utils
    playerctl
    libnotify
    brightnessctl
    pavucontrol
    wl-clip-persist
    wf-recorder
    slurp
    hyprpicker
    matugen
    satty
    localPkgs.hyprwhspr
    xdg-utils

    # system & hardware
    psmisc
    usbutils

    # media & downloads
    yt-dlp
    qbittorrent
    vlc
    qimgv
    loupe

    # kde integration & thumbnails
    kdePackages.ark
    kdePackages.kio-admin
    kdePackages.kservice
    kdePackages.ffmpegthumbs
    kdePackages.kimageformats

    # gui apps
    vesktop
    telegram-desktop
    inputs.zen-browser.packages.x86_64-linux.default
    inputs.helium.packages.x86_64-linux.default
    pear-desktop
    gimp

    # cad & 3d printing
    blender
    freecad
    kicad
    openscad-unstable
    bambuPkgs.bambu-studio

    # theming
    papirus-icon-theme
    gtk4
  ];
}
