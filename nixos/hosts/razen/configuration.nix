{ config, pkgs, lib, ... }:

{
  # ── Nix settings ───────────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    substituters = [
      "https://cache.nixos.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nixpkgs.config.allowUnfree = true;

  # ── CachyOS Kernel ─────────────────────────────────────────────────
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # ── Boot ───────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;

  boot.kernelParams = [
    "quiet"
    "splash"
    "nowatchdog"
  ];

  boot.plymouth.enable = true;

  boot.kernel.sysctl = {
    # CachyOS-equivalent sysctl tuning
    "vm.swappiness" = 100;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_bytes" = 268435456;
    "vm.dirty_background_bytes" = 67108864;
    "vm.dirty_writeback_centisecs" = 1500;
    "vm.page-cluster" = 0;
    "vm.max_map_count" = 1048576;

    "fs.inotify.max_user_instances" = 1024;
    "fs.inotify.max_user_watches" = 524288;
    "fs.file-max" = 2097152;
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_regular" = 1;
    "fs.protected_fifos" = 1;

    "kernel.nmi_watchdog" = 0;
    "kernel.printk" = "3 3 3 3";
    "kernel.kptr_restrict" = 2;
    "kernel.pid_max" = 4194304;
    "kernel.unprivileged_userns_clone" = 1;
    "kernel.split_lock_mitigate" = 0;
    "kernel.sysrq" = 16;

    "net.core.netdev_max_backlog" = 4096;
    "net.core.rmem_max" = 4194304;
    "net.core.wmem_max" = 4194304;
    "net.ipv4.tcp_keepalive_time" = 120;
  };

  boot.kernelModules = [ "i2c-dev" ];

  # ── Hostname / Locale ──────────────────────────────────────────────
  networking.hostName = "razen";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  console.keyMap = "us";

  # ── Networking ─────────────────────────────────────────────────────
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];
  networking.wireless.iwd.enable = true;
  networking.firewall.enable = true;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # ── NVIDIA ─────────────────────────────────────────────────────────
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      vaapiVdpau
    ];
  };

  # ── Niri (Wayland compositor) ──────────────────────────────────────
  programs.niri.enable = true;

  # ── DankMaterialShell ──────────────────────────────────────────────
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
  };

  programs.dank-material-shell.greeter = {
    enable = true;
    compositor.name = "niri";
    configHome = "/home/razen";
    logs.save = true;
  };

  # ── XDG portal ─────────────────────────────────────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # ── Audio (PipeWire) ───────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # ── Bluetooth ──────────────────────────────────────────────────────
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # ── Printing ───────────────────────────────────────────────────────
  services.printing = {
    enable = true;
    browsing = true;
    drivers = with pkgs; [ brlaser ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # ── Keyboard remapping (keyd) ──────────────────────────────────────
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          compose = "leftmeta";
        };
        "control+shift" = {
          s = "A-S-n";
        };
        "alt+shift" = {
          "[" = "C-S-tab";
          "]" = "C-tab";
        };
        "altgr+shift" = {
          "[" = "C-S-tab";
          "]" = "C-tab";
        };
      };
    };
  };

  # ── Input remapper ─────────────────────────────────────────────────
  services.input-remapper.enable = true;

  # ── Docker ─────────────────────────────────────────────────────────
  virtualisation.docker.enable = true;

  # ── Mullvad VPN ────────────────────────────────────────────────────
  services.mullvad-vpn.enable = true;

  # ── OpenSSH ────────────────────────────────────────────────────────
  services.openssh.enable = true;

  # ── Power management ───────────────────────────────────────────────
  # Match CachyOS: amd-pstate-epp with performance governor
  powerManagement.cpuFreqGovernor = "performance";
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # ── fstrim (SSD) ───────────────────────────────────────────────────
  services.fstrim.enable = true;

  # ── Ananicy (process scheduler) ────────────────────────────────────
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # ── Razer peripherals ──────────────────────────────────────────────
  hardware.openrazer = {
    enable = true;
    users = [ "razen" ];
  };

  # ── Solaar (Logitech) ─────────────────────────────────────────────
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # ── Polkit ─────────────────────────────────────────────────────────
  security.polkit.enable = true;

  # ── GNOME Keyring ──────────────────────────────────────────────────
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # ── Audio realtime limits ──────────────────────────────────────────
  security.pam.loginLimits = [
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
  ];

  # ── D-Bus ──────────────────────────────────────────────────────────
  services.dbus.enable = true;

  # ── Snapper (btrfs snapshots) ──────────────────────────────────────
  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    configs.root = {
      SUBVOLUME = "/";
      ALLOW_USERS = [ "razen" ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 5;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_WEEKLY = 0;
      TIMELINE_LIMIT_MONTHLY = 0;
      TIMELINE_LIMIT_YEARLY = 0;
    };
  };

  # ── Locate (plocate) ───────────────────────────────────────────────
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    interval = "daily";
    localuser = null;
  };

  # ── Trezor (hardware wallet) ───────────────────────────────────────
  services.trezord.enable = true;

  # ── udev rules ─────────────────────────────────────────────────────
  services.udev.extraRules = ''
    # Intel AX210 WiFi — disable autosuspend
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0032", ATTR{power/autosuspend}="-1", ATTR{power/control}="on"
    # Realtek USB device — disable autosuspend
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="0852", ATTR{power/autosuspend}="-1", ATTR{power/control}="on"
    # Solaar hidraw access
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="ae1c", MODE="0660", GROUP="input"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="ae11", MODE="0660", GROUP="input"
    # uinput access for input group
    KERNEL=="uinput", GROUP="input", MODE="0660"
    # QMK keyboard
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="beeb", ATTRS{idProduct}=="0001", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  # ── User ───────────────────────────────────────────────────────────
  users.users.razen = {
    isNormalUser = true;
    description = "razen";
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
      "docker"
      "lp"
      "storage"
      "tty"
      "rfkill"
      "plugdev"
      "openrazer"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # ── Fonts ──────────────────────────────────────────────────────────
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.iosevka
      monaspace
      dejavu_fonts
      liberation_ttf
      open-sans
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      cantarell-fonts
      inter
      fira-code
      material-symbols
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Inter" "Noto Sans" ];
        serif = [ "Noto Serif" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # ── System packages ────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Core CLI
    git
    wget
    curl
    rsync
    unzip
    unrar
    p7zip
    tree
    less
    pv
    file
    which

    # Editors
    neovim
    helix
    micro

    # System monitoring
    btop
    fastfetch
    duf
    gdu
    pciutils
    usbutils
    lm_sensors
    smartmontools

    # Filesystem
    btrfs-progs
    dosfstools
    e2fsprogs
    ntfs3g

    # Networking
    bind
    ethtool
    inetutils
    openssh

    # Wayland / Niri utilities
    wl-clipboard
    wl-clip-persist
    cliphist
    grim
    slurp
    wf-recorder
    wev
    wtype
    playerctl
    brightnessctl
    hyprpicker

    # Theming / Appearance
    bibata-cursors
    papirus-icon-theme
    adw-gtk3
    gnome-themes-extra
    qt5ct
    qt6ct

    # NVIDIA / GPU
    nvidia-vaapi-driver
    egl-wayland
    vulkan-tools
    vulkan-validation-layers
    vulkan-headers
    cudaPackages.cudatoolkit
    mesa-demos

    # Misc system
    libnotify
    polkit_gnome
    gnome-keyring
  ];

  # ── Environment variables ──────────────────────────────────────────
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    __GL_MaxFramesAllowed = "1";
    __GL_GSYNC_ALLOWED = "0";
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    EDITOR = "nvim";
  };

  # ── Modprobe ───────────────────────────────────────────────────────
  boot.extraModprobeConfig = ''
    options btusb enable_autosuspend=n
    options iwlwifi bt_coex_active=0 power_save=0
    options iwlmvm power_scheme=1
    options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1;PerfLevelSrc=0x2222;PowerMizerLevel=0x1;PowerMizerDefault=0x1;PowerMizerDefaultAC=0x1"
  '';

  system.stateVersion = "25.05";
}
