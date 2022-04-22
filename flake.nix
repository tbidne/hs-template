{
  description = "A Template for Haskell Packages";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs =
    { flake-utils
    , nixpkgs
    , self
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      compilerVersion = "ghc922";
      compiler = pkgs.haskell.packages."${compilerVersion}";
      mkPkg = returnShellEnv:
        compiler.developPackage {
          inherit returnShellEnv;
          name = "hs-template";
          root = ./.;
          modifier = drv:
            pkgs.haskell.lib.addBuildTools drv (with compiler; [
              cabal-install
              cabal-plan
              haskell-language-server
              hlint
              ghcid
              ormolu
              pkgs.zlib
            ]);
        };
    in
    {
      defaultPackage = mkPkg false;

      devShell = mkPkg true;
    });
}
