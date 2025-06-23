{
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nix-stable.url = "github:nixos/nixpkgs/nixos-25.05";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    
    outputs = inputs@{ nixpkgs, nix-stable, home-manager, hyprland, nixvim, ... }:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
        };
        stable = import nix-stable {
            inherit system;
            config.allowUnfree = true;
        };
    in
    {
        nixosConfigurations = {
            hriddhit = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    {
                        _module.args = { inherit stable inputs; };
                    }
                    home-manager.nixosModules.home-manager
                    {
                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            extraSpecialArgs = { inherit stable inputs nixvim; };
                            users.hriddhit = import ./home.nix;
                        };
                    }
                ];
            };
        };
    };
}
