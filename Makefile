.PHONY: build clean repl watch ;\
	cic ci formatc format lint lintc ;\
	haddock hackage

# core

T = ""

build:
	if [ -z "$(T)" ]; then \
		cabal build; \
	else \
		cabal build $(T); \
	fi

clean:
	cabal clean

repl:
	if [ -z "$(T)" ]; then \
		cabal repl hs-template; \
	else \
		cabal repl $(T); \
	fi

watch:
	if [ -z "$(T)" ]; then \
		ghcid --command "cabal repl hs-template"; \
	else \
		ghcid --command "cabal repl $(T)"; \
	fi

# ci

cic: formatc lintc

ci: lint format

# formatting

formatc:
	nix run github:tbidne/nix-hs-tools/0.8#cabal-fmt -- --check ;\
	nix run github:tbidne/nix-hs-tools/0.8#ormolu -- --mode check ;\
	nix run github:tbidne/nix-hs-tools/0.8#nixpkgs-fmt -- --check

format:
	nix run github:tbidne/nix-hs-tools/0.8#cabal-fmt -- --inplace ;\
	nix run github:tbidne/nix-hs-tools/0.8#ormolu -- --mode inplace ;\
	nix run github:tbidne/nix-hs-tools/0.8#nixpkgs-fmt

# linting

lint:
	nix run github:tbidne/nix-hs-tools/0.8#hlint -- --refact

lintc:
	nix run github:tbidne/nix-hs-tools/0.8#hlint

# generate docs for main package, copy to docs/
haddock:
	cabal haddock --haddock-hyperlink-source --haddock-quickjump ;\
	mkdir -p docs/ ;\
	find docs/ -type f | xargs -I % sh -c "rm -r %" ;\
	cp -r dist-newstyle/build/x86_64-linux/ghc-9.2.4/hs-template-0.1/opt/doc/html/hs-template/* docs/

.PHONY: hackage
hackage:
	cabal sdist ;\
	cabal haddock --haddock-for-hackage --enable-doc
