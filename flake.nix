{
  description = "flake for vegar-nav";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-zoom.url = "github:NixOS/nixpkgs/98053e7c05285b3079af95e99aef97d9455faef7";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    kolide-launcher.url = "github:kolide/nix-agent";
    kolide-launcher.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    minimal-tmux.url = "github:niksingh710/minimal-tmux-status";
    minimal-tmux.inputs.nixpkgs.follows = "nixpkgs";

    # naisdevice.url = "path:/home/vegar/dev/nais/device/";
    naisdevice.url = "github:nais/device";
    naisdevice.inputs.nixpkgs.follows = "nixpkgs";

    nais-cli.url = "github:nais/cli";
    nais-cli.inputs.nixpkgs.follows = "nixpkgs";

    narc-cli.url = "github:nais/narcos";
    narc-cli.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:MarceColl/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    pyproject-nix.url = "github:nix-community/pyproject.nix";
    pyproject-nix.inputs.nixpkgs.follows = "nixpkgs";
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
    overlays = import ./overlays {
      inherit inputs;
      nixpkgs-zoom = import inputs.nixpkgs-zoom {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      vegar-nav = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {nixpkgs.overlays = [overlays.additions overlays.modifications];}
          ./system/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit system;
            };
            home-manager.users.vegar = {
              imports = [
                ./home
              ];
            };
          }

          (import ./system/kolide.nix {inherit inputs;})
          kolide-launcher.nixosModules.kolide-launcher

          {
            services.naisdevice.enable = true;
            environment.systemPackages = [
              naisdevice.packages.${system}.naisdevice
              inputs.nais-cli.packages.${system}.default
              inputs.narc-cli.packages.${system}.default
            ];
          }
          naisdevice.nixosModules.naisdevice
        ];
      };
    };
    formatter.x86_64-linux = treeFmtEval.config.build.wrapper;
    checks.x86_64-linux.formatting = treeFmtEval.config.build.check self;
  };
}
