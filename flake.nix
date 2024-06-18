{
  description = "flake for vegar-nav";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    kolide-launcher.url = "github:kolide/nix-agent";
    kolide-launcher.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    naisdevice.url = "path:/home/vegar/dev/nais/device/";

    wezterm.url = "github:wez/wezterm?dir=nix";
    wezterm.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    kolide-launcher,
    naisdevice,
    treefmt-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    treeFmtEval = treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix;
  in {
    nixosConfigurations = {
      vegar-nav = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {nixpkgs.overlays = [(import ./overlays/packages.nix)];}
          ./system/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit system;
            };
            home-manager.users.vegar = import ./home;
          }

          (import ./system/kolide.nix {inherit inputs;})
          kolide-launcher.nixosModules.kolide-launcher

          {
            services.naisdevice.enable = true;
            environment.systemPackages = [naisdevice.packages.${system}.naisdevice];
          }
          naisdevice.nixosModules.naisdevice
        ];
      };
    };
    formatter.x86_64-linux = treeFmtEval.config.build.wrapper;
    checks.x86_64-linux.formatting = treeFmtEval.config.build.check self;
  };
}
