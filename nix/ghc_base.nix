{ compilerVersion
, hash ? (builtins.fromJSON (builtins.readFile ../flake.lock)).nodes.nixpkgs.locked.rev
}:

let
  pkgs = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz";
    })
    { };
  compiler = pkgs.haskell.packages."${compilerVersion}";
in
pkgs.mkShell {
  buildInputs =
    [
      pkgs.cabal-install
      compiler.ghc
    ];
}
