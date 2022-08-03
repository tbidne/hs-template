{ ghc-version
, stack-yaml
, hash ? null
}:

(import ./lib.nix).nix-hs-shells.stack-shell {
  inherit
    ghc-version
    stack-yaml
    hash;

  name = "hs-template";
  flake-path = ../flake.lock;
}
