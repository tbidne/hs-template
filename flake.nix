{
  description = "A Template for Haskell Packages";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nix-hs-utils = {
    url = "github:tbidne/nix-hs-utils";
    inputs.flake-compat.follows = "flake-compat";
  };
  outputs =
    inputs@{ flake-compat
    , flake-parts
    , nixpkgs
    , nix-hs-utils
    , self
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = { pkgs, ... }:
        let
          hlib = pkgs.haskell.lib;
          ghc-version = "ghc944";
          # override packages set rather than developPackage's overrides so
          # we can use the same overlay with nix build, dev shell, and apps.
          compiler = pkgs.haskell.packages."${ghc-version}".override {
            overrides = _: prev: {
              apply-refact = prev.apply-refact_0_11_0_0;
            };
          };
          mkPkg = returnShellEnv:
            nix-hs-utils.mkHaskellPkg {
              inherit compiler pkgs returnShellEnv;
              name = "hs-template";
              root = ./.;
            };
          hs-dirs = "app src";
        in
        {
          packages.default = mkPkg false;
          devShells.default = mkPkg true;

          apps = {
            format = nix-hs-utils.format {
              inherit compiler hs-dirs pkgs;
            };
            lint = nix-hs-utils.lint {
              inherit compiler hs-dirs pkgs;
            };
            lint-refactor = nix-hs-utils.lint-refactor {
              inherit compiler hs-dirs pkgs;
            };
          };
        };
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
