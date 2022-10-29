.PHONY: build clean repl watch ;\
	test ;\
	cic ci formatc format lint lintc haddockc ;\
	haddock hackage

# core

ARGS = ""

build:
	if [ -z "$(ARGS)" ]; then \
		cabal build; \
	else \
		cabal build $(ARGS); \
	fi

clean:
	cabal clean

test:
	if [ -z "$(ARGS)" ]; then \
		cabal test; \
	else \
		cabal test $(ARGS); \
	fi

repl:
	if [ -z "$(ARGS)" ]; then \
		cabal repl hs-template; \
	else \
		cabal repl $(ARGS); \
	fi

watch:
	if [ -z "$(ARGS)" ]; then \
		ghcid --command "cabal repl hs-template"; \
	else \
		ghcid --command "cabal repl $(ARGS)"; \
	fi

# ci

cic: formatc lintc haddockc

ci: lint format

# formatting

formatc:
	nix run github:tbidne/nix-hs-tools/0.7#cabal-fmt -- --check ;\
	nix run github:tbidne/nix-hs-tools/0.7#ormolu -- --mode check ;\
	nix run github:tbidne/nix-hs-tools/0.7#nixpkgs-fmt -- --check

format:
	nix run github:tbidne/nix-hs-tools/0.7#cabal-fmt -- --inplace ;\
	nix run github:tbidne/nix-hs-tools/0.7#ormolu -- --mode inplace ;\
	nix run github:tbidne/nix-hs-tools/0.7#nixpkgs-fmt

# linting

lint:
	nix run github:tbidne/nix-hs-tools/0.7#hlint -- --refact

lintc:
	nix run github:tbidne/nix-hs-tools/0.7#hlint

# generate docs for main package, copy to docs/
haddock:
	cabal haddock --haddock-hyperlink-source --haddock-quickjump ;\
	mkdir -p docs/ ;\
	find docs/ -type f | xargs -I % sh -c "rm -r %" ;\
	cp -r dist-newstyle/build/x86_64-linux/ghc-9.2.4/hs-template-0.1/opt/doc/html/hs-template/* docs/

haddockc:
	nix run github:tbidne/nix-hs-tools/0.7#haddock-cov -- .

.PHONY: hackage
hackage:
	cabal sdist ;\
	cabal haddock --haddock-for-hackage --enable-doc
