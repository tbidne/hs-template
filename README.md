<div align="center">

# hs-template

[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/tbidne/hs-template?include_prereleases&sort=semver)](https://github.com/tbidne/hs-template/releases/)
[![MIT](https://img.shields.io/github/license/tbidne/hs-template?color=blue)](https://opensource.org/licenses/MIT)

[![nix](https://img.shields.io/github/workflow/status/tbidne/hs-template/nix/main?label=nix%209.2&&logo=nixos&logoColor=85c5e7&labelColor=2f353c)](https://github.com/tbidne/hs-template/actions/workflows/nix_ci.yaml)
[![stack](https://img.shields.io/github/workflow/status/tbidne/hs-template/stack/main?label=stack%2019&logoColor=white&labelColor=2f353c)](https://github.com/tbidne/hs-template/actions/workflows/stack_ci.yaml)
[![style](https://img.shields.io/github/workflow/status/tbidne/hs-template/style/main?label=style&logoColor=white&labelColor=2f353c)](https://github.com/tbidne/hs-template/actions/workflows/style_ci.yaml)

[![8.10](https://img.shields.io/github/workflow/status/tbidne/hs-template/8.10/main?label=8.10&logo=haskell&logoColor=904d8c&labelColor=2f353c)](https://github.com/tbidne/hs-template/actions/workflows/ghc_8-10.yaml)
[![9.0](https://img.shields.io/github/workflow/status/tbidne/hs-template/9.0/main?label=9.0&logo=haskell&logoColor=904d8c&labelColor=2f353c)](https://github.com/tbidne/hs-template/actions/workflows/ghc_9-0.yaml)
[![9.2](https://img.shields.io/github/workflow/status/tbidne/hs-template/9.2/main?label=9.2&logo=haskell&logoColor=904d8c&labelColor=2f353c)](https://github.com/tbidne/hs-template/actions/workflows/ghc_9-2.yaml)

</div>

---

### Table of Contents
- [Introduction](#introduction)
- [Structure](#structure)
  - [Haskell](#haskell)
    - [Cabal](#cabal)
    - [Stack](#stack)
    - [HS Misc](#hs-misc)
  - [Nix](#nix)
  - [CI](#ci)
  - [misc](#misc)

# Introduction

`hs-template` is a template for haskell projects with `cabal`, `stack` and `nix` integration.

# Structure

## Haskell

* `app/`: Haskell executable code. This should be as light as possible, ideally one small module (`Main.hs`), maybe two (e.g. `Args.hs` for CLI args).
* `src/`: Haskell library code. Whether the application is an executable or library, most of the logic should go here.

* `hs-template.cabal`: The primary file used for building a project. This should always be in version control even if the primary build tool is `stack`.

### Cabal

* `cabal.project`: This project adds additional options that are used at build time. Here we use it to turn various warnings on.

### Stack

* `stack.yaml / stack.yaml.lock`: These files are used for building with stack, with the latter generated by `stack build`. `stack.yaml` is analogous to `cabal.project.`

### HS Misc

* `hie.yaml`: This file helps with IDE integration via the `haskell-language-server`.
* `CHANGELOG.md`: Changelog.

## Nix

* `flake.nix / flake.lock`: For `nix` users. A nix shell can be entered with `nix develop` that will give the tools necessary for haskell development with `cabal`. Cabal can be traded for `stack` if desired.

## CI

* `.github/workflows/`: Several github actions are defined that verify:
  * Build / Tests with multiple ghc versions with `cabal`.
  * Build / Tests with `stack` on the latest LTS.
  * Build / Test with nix directly (i.e. `nix build`).
  * Linting (e.g. formatting).

* `nix/`: This directory contains minimal nix shell files used for the CI jobs e.g. one action will load a nix shell with `nix/ghc_X-Y.nix` and test building with `ghc_X-Y`. The `stack.nix` file is not currently used for CI, as there is a stack-specific action. It exists to make it easier for non-stack users to keep update the lock file (i.e. `nix-shell nix/stack.nix && rm stack.yaml.lock && stack build`).

## Misc

* `Makefile`: A makefile that provides useful shortcuts for cabal commands. For example, the most common `cabal` commands are provided, along with multiple formatters/linters. The formatting/linting uses tools from https://github.com/tbidne/nix-hs-tools and requires nix. If this is not desired, they can be changed to use the tool directly e.g.

    ```Makefile
    # from
    .PHONY: hsformat
    hsformat:
    	nix run github:tbidne/nix-hs-tools/0.6#ormolu -- --mode inplace

    # to
    .PHONY: hsformat
    hsformat:
    	ormolu -- --mode inplace
    ```

    And of course they can be deleted/swapped out as desired.