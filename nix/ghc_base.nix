{ compilerVersion
, hash ? null
}:

let
  # If a hash is not provided, read it from the flake.lock's top-level
  # nixpkgs.
  hash' =
    if hash == null
    then
      let
        lockJson = builtins.fromJSON (builtins.readFile ../flake.lock);
        # The hash referred to by "nixpkgs" in flake.lock does not necessarily
        # correspond to "nixpkgs" in flake.nix. We have to retrieve it via
        # 'root'.
        nixpkgsKey = lockJson.nodes.root.inputs.nixpkgs;
      in
      lockJson.nodes.${nixpkgsKey}.locked.rev
    else hash;
  pkgs = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${hash'}.tar.gz";
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
