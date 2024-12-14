{
  self,
  pkgs,
  config,
  ...
}: {
  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.defaults = {
    dock.autohide = true;
    loginwindow.GuestEnabled = false;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
  };

  environment.systemPackages =
    [
      pkgs.mkalias
      pkgs.alacritty
    ];

  homebrew = {
    enable = true;
    brews = [
      "mas"
    ];
    casks = [
      "raycast"
      "discord"
    ];
    masApps = {
      "Windows" = 1295203466;
    };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
}
