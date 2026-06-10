{ pkgs, ... }:

{
  security.polkit.enable = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];
  services.geoclue2.enable = true;
  services.automatic-timezoned.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.accounts-daemon.enable = true;
  services.udisks2.enable = true;
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
}
