{ pkgs, vars, ... }:

{
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ vars.username ];
  };

  programs.kdeconnect.enable = true;

  programs.ydotool.enable = true;

  users.users.${vars.username}.extraGroups = [ "ydotool" ];

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
}
