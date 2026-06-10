{ vars, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  networking.hostName = vars.hostname;
  i18n.defaultLocale = vars.locale;

  system.stateVersion = "25.05";
}
