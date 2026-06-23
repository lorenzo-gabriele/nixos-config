{ self, inputs, ... }: {
  flake.nixosModules.stylix-config = { pkgs, ... }: {
    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

	  targets.gtk.enable = true;
	  
      polarity = "dark";

      opacity = {
        popups = 0.9;
      };

      fonts = {
        monospace = {
          package = pkgs.maple-mono.NF;
          name = "MapleMono NF";
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
      # The specific cursor name can be specified in niri.nix only but this seem to be needed here
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };
  };
}
