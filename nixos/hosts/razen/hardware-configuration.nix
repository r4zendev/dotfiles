{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ── CPU ────────────────────────────────────────────────────────────
  hardware.cpu.amd.updateMicrocode = true;

  # ── Kernel ─────────────────────────────────────────────────────────
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];

  # ── Filesystems ────────────────────────────────────────────────────
  # Adjust UUIDs to match your actual install
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ae93ee76-dd51-4eb6-991e-1ce3d11a58c6";
    fsType = "btrfs";
    options = [ "subvol=/@" "defaults" "noatime" "compress=zstd" "commit=120" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ae93ee76-dd51-4eb6-991e-1ce3d11a58c6";
    fsType = "btrfs";
    options = [ "subvol=/@home" "defaults" "noatime" "compress=zstd" "commit=120" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/ae93ee76-dd51-4eb6-991e-1ce3d11a58c6";
    fsType = "btrfs";
    options = [ "subvol=/@log" "defaults" "noatime" "compress=zstd" "commit=120" ];
  };

  fileSystems."/var/cache" = {
    device = "/dev/disk/by-uuid/ae93ee76-dd51-4eb6-991e-1ce3d11a58c6";
    fsType = "btrfs";
    options = [ "subvol=/@cache" "defaults" "noatime" "compress=zstd" "commit=120" ];
  };

  fileSystems."/var/tmp" = {
    device = "/dev/disk/by-uuid/ae93ee76-dd51-4eb6-991e-1ce3d11a58c6";
    fsType = "btrfs";
    options = [ "subvol=/@tmp" "defaults" "noatime" "compress=zstd" "commit=120" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DC39-6906";
    fsType = "vfat";
    options = [ "defaults" "umask=0077" ];
  };

  swapDevices = [ ];

  # zram swap
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
