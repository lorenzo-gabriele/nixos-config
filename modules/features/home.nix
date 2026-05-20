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

      home.file.".config/xfce4/helpers.rc".text = ''
        TerminalEmulator=kitty
        FileManager=thunar
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
        NIXOS_OZONE_WL = "1";
      };

      home.sessionPath = [
        "$HOME/.local/bin"
        "$HOME/.lmstudio/bin"
      ];

      services.udiskie.enable = true;
      services.udiskie.tray = "always";
      services.udiskie.notify = false;
      services.udiskie.settings = {
        program_options.appindicator = true;
        icon_names.media = [ "udiskie-media" ];
      };

      home.file.".local/share/icons/hicolor/64x64/apps/udiskie-media.png".source = pkgs.runCommand "udiskie-media.png" {
        nativeBuildInputs = [ pkgs.librsvg ];
      } ''
        rsvg-convert -w 64 -h 64 -f png ${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/64x64@2x/devices/drive-removable-media.svg > $out
      '';

      programs.bash.enable = true;
      programs.starship.enable = true;
      programs.fzf.enable = true;

      # Add ~/.local/bin to PATH (for patched hermes wrapper)
      home.sessionVariables.PATH = "$HOME/.local/bin:$PATH";

      # Persist live Noctalia UI changes back to the repo, then rebuild to lock them in
      home.shellAliases.noctalia-save = "nix run ~/NIX#myNoctalia -- ipc call state all > /tmp/noctalia-save.json && mv /tmp/noctalia-save.json ~/NIX/modules/features/noctalia.json";

      # Force dark mode preference for apps Stylix can't directly theme
      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };


      programs.mpv = {
        enable = true;
        scripts = [ pkgs.mpvScripts.mpris ];
      };

      xdg.desktopEntries.spotify = {
        name = "Spotify";
        exec = "spotify --enable-features=UseOzonePlatform --ozone-platform=x11 %U";
        terminal = false;
        type = "Application";
        icon = "spotify-client";
        categories = [ "Audio" "Music" "Player" ];
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
          shell = "bash --noprofile";
          hide_window_decorations = "yes";

          cursor_trail = 3;
        };
      };

      home.packages = with pkgs; [

      	maple-mono.NF

      	# Utils
        gh
        btop
        ffmpeg

        # C stuff
        gcc
        valgrind
        gdb

        # Text editors
        micro
        sublime4
        kdePackages.kate

        # Apps
        libreoffice
        spotatui
        spotify
        godot
        blender
        pinta
        qbittorrent
        quickemu
        lmstudio
        ollama
        inputs.llm-agents.packages.${pkgs.system}.hermes-agent

        # Terminal toys
        fastfetch
        asciiquarium
        cowsay
        pipes
        cbonsai
        lolcat
        fortune
        cava
      ];

    };
  };
}
