{
  description = "A Template for Haskell Packages";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nix-hs-utils.url = "github:tbidne/nix-hs-utils";
  outputs =
    inputs@{ flake-parts
    , nixpkgs
    , nix-hs-utils
    , self
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = { pkgs, ... }:
        let
          hlib = pkgs.haskell.lib;
          ghc-version = "ghc963";
          # override packages set rather than developPackage's overrides so
          # we can use the same overlay with nix build, dev shell, and apps.
          compiler = pkgs.haskell.packages."${ghc-version}".override {
            overrides = _: prev: {
              hlint = prev.hlint_3_6_1;
              ormolu = prev.ormolu_0_7_2_0;
            };
          };
          mkPkg = returnShellEnv:
            nix-hs-utils.mkHaskellPkg {
              inherit compiler pkgs returnShellEnv;
              name = "hs-template";
              root = ./.;
            };
          compilerPkgs = { inherit compiler pkgs; };
        in
        {
          packages.default = mkPkg false;
          devShells.default = mkPkg true;

          apps = {
            format = nix-hs-utils.format compilerPkgs;
            lint = nix-hs-utils.lint compilerPkgs;
            lintRefactor = nix-hs-utils.lintRefactor compilerPkgs;
          };
        };
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
