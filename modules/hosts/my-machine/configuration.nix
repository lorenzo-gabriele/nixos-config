{ self, inputs, ... }: {

  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.myMachineHardware
      self.nixosModules.niri
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Rome";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "it_IT.UTF-8";
      LC_IDENTIFICATION = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_NAME = "it_IT.UTF-8";
      LC_NUMERIC = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
      LC_TELEPHONE = "it_IT.UTF-8";
      LC_TIME = "it_IT.UTF-8";
    };

    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.xkb = {
      layout = "it";
      variant = "";
    };

    console.keyMap = "it2";

    services.printing.enable = true;

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users.redue = {
      isNormalUser = true;
      description = "Lorenzo";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [];
    };

    programs.firefox.enable = true;

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      git
      kitty
      brightnessctl
      lxqt.lxqt-policykit
      xdg-utils
      libnotify
      wireplumber
      nix-tree
      nomacs
      yazi
      dust
      thunar
      antigravity
    ];

    system.stateVersion = "25.11";
  };

}
