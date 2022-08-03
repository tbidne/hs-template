{ ghc-version
, hash ? null
}:

(import ./lib.nix).nix-hs-shells.cabal-shell {
  inherit ghc-version hash;
  flake-path = ../flake.lock;
}
