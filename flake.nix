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
          buildTools = c: [
            c.cabal-install
            pkgs.gnumake
            pkgs.zlib
          ];
          devTools = c: [
            (hlib.dontCheck c.ghcid)
            (hlib.dontCheck c.haskell-language-server)
          ];
          formatters = c: [
            (hlib.dontCheck c.cabal-fmt)
            (hlib.dontCheck c.hlint)
            (hlib.dontCheck c.ormolu)
            pkgs.nixpkgs-fmt
          ];
          hlib = pkgs.haskell.lib;
          ghc-version = "ghc944";
          compiler = pkgs.haskell.packages."${ghc-version}";
          mkPkg = returnShellEnv: withDevTools:
            compiler.developPackage {
              inherit returnShellEnv;
              name = "hs-template";
              root = ./.;
              modifier = drv:
                pkgs.haskell.lib.addBuildTools drv
                  (buildTools compiler ++
                    (if returnShellEnv then formatters compiler else [ ]) ++
                    (if withDevTools then devTools compiler else [ ]));
            };
        in
        {
          packages.default = mkPkg false false;
          devShells.default = mkPkg true true;
          devShells.ci = mkPkg true false;
        };
      systems = [
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
