{ config, pkgs, lib, ghostty, ... }:

{
  # ── Fish ───────────────────────────────────────────────────────────
  # Config content managed via stow (stow/common/.config/fish/)
  # Home-manager only installs fish + plugins that need nix paths
  programs.fish.enable = true;
  # Plugins managed via Fisher (installed by post-install.sh)
  # Stow manages all fish config files in conf.d/, functions/, completions/

  # ── Starship ───────────────────────────────────────────────────────
  # Config via stow (stow/common/.config/starship.toml)
  programs.starship.enable = true;
  programs.starship.enableFishIntegration = false;

  # ── Tmux ───────────────────────────────────────────────────────────
  # Config via stow (stow/common/.config/tmux/)
  programs.tmux.enable = true;

  # ── Neovim ─────────────────────────────────────────────────────────
  # Config via stow (stow/common/.config/nvim/)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  # ── Zoxide ─────────────────────────────────────────────────────────
  programs.zoxide = {
    enable = true;
    enableFishIntegration = false;
  };

  # ── FZF ────────────────────────────────────────────────────────────
  programs.fzf = {
    enable = true;
    enableFishIntegration = false;
  };

  programs.bat.enable = true;
  programs.btop.enable = true;

  # ── Yazi ───────────────────────────────────────────────────────────
  # Config via stow (stow/common/.config/yazi/)
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  # ── Direnv ─────────────────────────────────────────────────────────
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ── CLI packages ───────────────────────────────────────────────────
  home.packages = [
    ghostty.packages.x86_64-linux.default
  ] ++ (with pkgs; [
    # Shell tools
    lsd
    fd
    ripgrep
    jq
    fx
    figlet
    cowsay
    gum
    pv
    tree
    duf
    gdu
    fastfetch
    mise
    stow
    yt-dlp
    ffmpeg
    plocate
    clipse
    pywal16

    # HTTP clients
    curlie
    xh

    # Database
    dblab

    # Session management
    sesh

    # Dev runtimes / package managers
    bun
    pnpm
    nodejs
    uv
    python3

    # Docker
    docker-compose
    lazydocker

    # Build tools
    cmake
    ninja
    gcc
    gnumake

    # Backup terminal
    alacritty
  ]);
}
