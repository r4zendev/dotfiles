{ config, pkgs, lib, dank-material-shell, ghostty, niri, zen-browser, ... }:

{
  imports = [
    dank-material-shell.homeModules.dank-material-shell
    dank-material-shell.homeModules.niri
    ./shell.nix
    ./git.nix
    ./niri.nix
    ./apps.nix
    ./services.nix
  ];

  home.username = "razen";
  home.homeDirectory = "/home/razen";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  # ── DankMaterialShell ──────────────────────────────────────────────
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    enableDynamicTheming = true;
    enableSystemMonitoring = true;
    enableVPN = true;
    enableAudioWavelength = true;
    enableClipboardPaste = true;

    niri = {
      includes.enable = true;
      includes.override = true;
    };

    settings = {
      terminal = "ghostty";
      fileManager = "dolphin";
    };
  };

  # ── Cursor ─────────────────────────────────────────────────────────
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # ── GTK ────────────────────────────────────────────────────────────
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  # ── Qt ─────────────────────────────────────────────────────────────
  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  # ── XDG ────────────────────────────────────────────────────────────
  xdg.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/chrome" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/bmp" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";
      "image/avif" = "org.gnome.Loupe.desktop";
      "video/mp4" = "vlc.desktop";
      "video/webm" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "inode/directory" = "org.kde.dolphin.desktop";
      "text/plain" = "nvim.desktop";
      "application/zip" = "org.kde.ark.desktop";
      "application/x-tar" = "org.kde.ark.desktop";
      "application/x-compressed-tar" = "org.kde.ark.desktop";
      "application/x-7z-compressed" = "org.kde.ark.desktop";
      "application/vnd.rar" = "org.kde.ark.desktop";
      "x-scheme-handler/discord" = "vesktop.desktop";
    };
  };

  # Env vars managed via stow (stow/common/.config/fish/conf.d/env.fish)
  # Contains API keys that must not go in the nix store

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.config/bin"
    "$HOME/.bun/bin"
    "$HOME/.cache/.bun/bin"
    "$HOME/.local/share/pnpm"
    "$HOME/.global-python/bin"
  ];
}
