{ self, inputs, ... }: {
  flake.nixosConfigurations.myMachine = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.myMachineConfiguration
      self.nixosModules.stylix-config
      inputs.stylix.nixosModules.stylix
    ];
  };
}
