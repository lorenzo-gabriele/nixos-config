{ self, inputs, ... }: {
  flake.nixosModules.home = { config, pkgs, lib, ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.users.redue = {
      home.stateVersion = "25.11";
      home.username = "redue";
      home.homeDirectory = "/home/redue";
      home.file.".config/Antigravity/machineid".text = "6c1ddd78-ea52-431d-a204-22ae85a3f7c2";
      home.file.".config/Antigravity/machineid.backup".text = "6c1ddd78-ea52-431d-a204-22ae85a3f7c2";

      home.file.".config/xfce4/helpers.rc".text = ''
        TerminalEmulator=kitty
      '';

      home.file.".local/share/xfce4/helpers/kitty.desktop".text = ''
        [Desktop Entry]
        Version=1.0
        Icon=kitty
        Type=X-XFCE-Helper
        Name=Kitty
        StartupNotify=false
        X-XFCE-Binaries=kitty;
        X-XFCE-Category=TerminalEmulator
        X-XFCE-Commands=%B;
        X-XFCE-CommandsWithParameter=%B -e %s;
      '';

      home.sessionVariables = {
        EDITOR = "micro";
        VISUAL = "micro";
        TERMINAL = "kitty";
      };

      services.udiskie.enable = true;
      services.udiskie.tray = "always";
      services.udiskie.notify = false;

      programs.bash.enable = true;
      programs.starship.enable = true;
      programs.fzf.enable = true;

      # Persist live Noctalia UI changes back to the repo, then rebuild to lock them in
      home.shellAliases.noctalia-save = "nix run ~/NIX#myNoctalia -- ipc call state all > /tmp/noctalia-save.json && mv /tmp/noctalia-save.json ~/NIX/modules/features/noctalia.json";

      # Force dark mode preference for apps Stylix can't directly theme
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      gtk.iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      gtk.gtk4.theme = null;

      programs.kitty = {
        enable = true;
        settings = {
          confirm_os_window_close = 0;
          background_opacity = lib.mkForce "0.95";
          shell = "bash --noprofile";
        };
      };

      home.packages = with pkgs; [
        gh
        thunar
        yazi
        kdePackages.kate
        kdePackages.filelight
        gcc
        valgrind
        micro
	fastfetch
        sublime4
        spotify
        cowsay
        godot
        blender
        qbittorrent
        antigravity
     ];
    };
  };
}
