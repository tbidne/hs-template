let
  nix-hs-shells = import
    (fetchGit {
      url = "https://github.com/tbidne/nix-hs-shells/";
      ref = "refs/tags/0.1";
    });
in
{
  inherit nix-hs-shells;
}
