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
      compilerVersion = "ghc923";
      compiler = pkgs.haskell.packages."${compilerVersion}";
      mkPkg = returnShellEnv:
        compiler.developPackage {
          inherit returnShellEnv;
          name = "hs-template";
          root = ./.;
          modifier = drv:
            # add tools like hlint, ormolu, ghci here if you want them
            # on the PATH
            pkgs.haskell.lib.addBuildTools drv (with compiler; [
              cabal-install
              haskell-language-server
              pkgs.gnumake
              pkgs.zlib
            ]);
        };
    in
    {
      package.default = mkPkg false;

      devShell = mkPkg true;
    });
}
