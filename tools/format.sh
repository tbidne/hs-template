set -e

export LANG="C.UTF-8"

export hs_dirs="src app"

nixpkgs-fmt ./

cabal-fmt --inplace hs-template.cabal

# shellcheck disable=SC2046,SC2086
ormolu -m inplace $(find $hs_dirs -type f -name '*.hs')