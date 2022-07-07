let
  compilerVersion = "ghc902";

  lockJson = builtins.fromJSON (builtins.readFile ../flake.lock);
  nixpkgsKey = lockJson.nodes.root.inputs.nixpkgs;
  hash = lockJson.nodes.${nixpkgsKey}.locked.rev;

  pkgs = import
    (fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${hash}.tar.gz";
      sha256 = lockJson.nodes.${nixpkgsKey}.locked.narHash;
    })
    { };
  compiler = pkgs.haskell.packages."${compilerVersion}";
in
pkgs.haskell.lib.buildStackProject {
  name = "hs-template";

  buildInputs = with pkgs; [
    git
    stack
    zlib.dev
    zlib.out
  ];

  ghc = compiler.ghc;
}
