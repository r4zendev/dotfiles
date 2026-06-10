{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    extraConfig.pipewire.buffer = {
      "context.properties" = {
        "default.clock.min-quantum" = 1024;
        "default.clock.quantum" = 1024;
        "default.clock.max-quantum" = 2048;
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 48000 ];
      };
    };

    wireplumber.extraConfig.alsa-tweaks = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "~alsa_*"; } ];
          actions."update-props" = {
            "api.alsa.period-size" = 1024;
            "api.alsa.headroom" = 1024;
            "session.suspend-timeout-seconds" = 0;
          };
        }
      ];
    };

    wireplumber.extraConfig.disable-webcam-mic = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "alsa_input.usb-Razer_Inc_Razer_Kiyo_Pro-02.analog-stereo"; } ];
          actions."update-props"."node.disabled" = true;
        }
      ];
    };
  };
}
