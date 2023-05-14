<div align="center">

# hs-template

[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tbidne/hs-template?include_prereleases&sort=semver)](https://github.com/tbidne/hs-template/releases/)
[![ci](http://img.shields.io/github/actions/workflow/status/tbidne/hs-template/ci.yaml?branch=main)](https://github.com/tbidne/hs-template/actions/workflows/ci.yaml)
[![MIT](https://img.shields.io/github/license/tbidne/hs-template?color=blue)](https://opensource.org/licenses/MIT)

</div>

---

### Table of Contents
- [Introduction](#introduction)
- [Structure](#structure)
  - [Haskell](#haskell)
    - [Cabal](#cabal)
    - [HS Misc](#hs-misc)
  - [Nix](#nix)
  - [CI](#ci)
  - [misc](#misc)

# Introduction

`hs-template` is a template for haskell projects with `cabal` and `nix` integration.

# Structure

## Haskell

* `app/`: Haskell executable code. This should be as light as possible, ideally one small module (`Main.hs`), maybe two (e.g. `Args.hs` for CLI args).
* `src/`: Haskell library code. Whether the application is an executable or library, most of the logic should go here.
* `hs-template.cabal`: The primary file used for building a project. This should always be in version control even if it is generated by an external tool (e.g. `hpack` and `project.yaml`).

### Cabal

* `cabal.project`: This project adds additional options that are used at build time. Here we use it to turn various warnings on.

### HS Misc

* `hie.yaml`: This file helps with IDE integration via the `haskell-language-server`.
* `CHANGELOG.md`

## Nix

* `flake.nix / flake.lock`: For `nix` users. A nix shell can be entered with `nix develop` that will give the tools necessary for haskell development with `cabal`. We also define several nix apps for formatting and linting e.g. `nix run .#format`.

* For a minimal nix setup (i.e. no flakes), see https://github.com/tbidne/nix-hs-shells. The default setup can be used as a basic nix shell.

## CI

* `.github/workflows/`: Several github actions are defined that verify:
  * Build / Tests with `cabal` and multiple ghc versions.
  * Build / Test with nix directly (i.e. `nix build`).
  * Linting (e.g. formatting).

## Misc

* `tools/haddock.sh`: Generates haddock docs at `docs/`.
