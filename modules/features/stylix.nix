{ self, inputs, ... }: {
  flake.nixosModules.stylix-config = { pkgs, ... }: {
    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

      polarity = "dark";

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.inter;
          name = "Inter";
        };
        serif = {
          package = pkgs.noto-fonts;
          name = "Noto Serif";
        };
        sizes = {
          terminal = 12;
          applications = 11;
        };
      };

      # When changing cursor here, also change it in niri.nix
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };
  };
}
