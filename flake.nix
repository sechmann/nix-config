{
  description = "flake for vegar-nav";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kolide-launcher = {
      url = "github:kolide/nix-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naisdevice = {
      url = "path:/home/vegar/dev/nais/device/";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      kolide-launcher,
      naisdevice,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        nixpkgs.overlays = [ (import ./overlays/wayland.nix) ] ++ naisdevice.overlays;
        vegar-nav = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./system/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
              home-manager.users.vegar = import ./home-manager;
            }

            (import ./system/kolide.nix { inherit inputs; })
            kolide-launcher.nixosModules.kolide-launcher

            (import ./system/naisdevice.nix)
            naisdevice.nixosModules.naisdevice
          ];
        };
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
