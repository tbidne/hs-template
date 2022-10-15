.PHONY: build clean test repl watch cic ci formatc format lint lintc haddock haddockc hackage

# core

ARGS = ""

.PHONY: build
build:
	if [ -z "$(ARGS)" ]; then \
		cabal build; \
	else \
		cabal build $(ARGS); \
	fi

.PHONY: clean
clean:
	cabal clean

.PHONY: test
test:
	if [ -z "$(ARGS)" ]; then \
		cabal test; \
	else \
		cabal test $(ARGS); \
	fi

.PHONY: repl
repl:
	if [ -z "$(ARGS)" ]; then \
		cabal repl; \
	else \
		cabal repl $(ARGS); \
	fi

.PHONY: watch
watch:
	ghcid --command "cabal repl $(ARGS)"

# ci

.PHONY: cic
cic: formatc lintc haddockc

.PHONY: ci
ci: lint format

# formatting

formatc:
	nix run github:tbidne/nix-hs-tools/0.6.1#cabal-fmt -- --check ;\
	nix run github:tbidne/nix-hs-tools/0.6.1#ormolu -- --mode check ;\
	nix run github:tbidne/nix-hs-tools/0.6.1#nixpkgs-fmt -- --check

format:
	nix run github:tbidne/nix-hs-tools/0.6.1#cabal-fmt -- --inplace ;\
	nix run github:tbidne/nix-hs-tools/0.6.1#ormolu -- --mode inplace ;\
	nix run github:tbidne/nix-hs-tools/0.6.1#nixpkgs-fmt

# linting

lint:
	nix run github:tbidne/nix-hs-tools/0.6.1#hlint -- --refact

lintc:
	nix run github:tbidne/nix-hs-tools/0.6.1#hlint

# generate docs for main package, copy to docs/
.PHONY: haddock
haddock:
	cabal haddock --haddock-hyperlink-source --haddock-quickjump ;\
	mkdir -p docs/ ;\
	find docs/ -type f | xargs -I % sh -c "rm -r %" ;\
	cp -r dist-newstyle/build/x86_64-linux/ghc-9.2.3/hs-template-0.1/opt/doc/html/hs-template/* docs/

.PHONY: haddockc
haddockc:
	nix run github:tbidne/nix-hs-tools/0.6.1#haddock-cov -- .

# generate dist and docs suitable for hackage
.PHONY: hackage
hackage:
	cabal sdist ;\
	cabal haddock --haddock-for-hackage --enable-doc
