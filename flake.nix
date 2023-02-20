{
  description = "A Template for Haskell Packages";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    inputs@{ flake-compat
    , flake-parts
    , nixpkgs
    , self
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = { pkgs, ... }:
        let
          buildTools = c: with c; [
            cabal-install
            pkgs.gnumake
            pkgs.zlib
          ];
          devTools = c: with c; [
            # do not run ghcid tests, as they require stack
            (pkgs.haskell.lib.dontCheck ghcid)
            haskell-language-server
          ];
          ghc-version = "ghc944";
          compiler = pkgs.haskell.packages."${ghc-version}";
          mkPkg = returnShellEnv:
            compiler.developPackage {
              inherit returnShellEnv;
              name = "hs-template";
              root = ./.;
              modifier = drv:
                pkgs.haskell.lib.addBuildTools drv
                  (buildTools compiler ++ devTools compiler);
            };
        in
        {
          packages.default = mkPkg false;

          devShells.default = mkPkg true;
        };
      systems = [
        "x86_64-linux"
      ];
    };
}
