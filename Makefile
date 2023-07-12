PWSH = pwsh

.PHONY: build
build:
	cabal v2-build

.PHONY: build-deps
build-deps:
	cabal v2-build --only-dependencies

.PHONY: test
test: doctest spec

.PHONY: doctest
doctest:
	cabal v2-test doctest

.PHONY: spec
spec:
	cabal v2-test spec

.PHONY: repl
repl:
	cabal v2-repl

.PHONY: freeze
freeze:
	$(PWSH) -Command '&{\
	  $$file = "cabal.project.$$(ghc --numeric-version).freeze";\
	  if (Test-Path $$file) { Remove-Item $$file };\
	  cabal freeze;\
	  Move-Item cabal.project.freeze $$file;\
	}'

.PHONY: format
format:
	stylish-haskell --inplace --recursive src app test

.PHONY: lint
lint:
	hlint src app

.PHONY: doc
doc:
	cabal v2-haddock

.PHONY: clean
clean:
	cabal v2-clean

.PHONY: targets
targets:
	$(PWSH) -Command "& { Get-Content .\Makefile | Where-Object { $$_ -like '.PHONY*' } | ForEach-Object { $$_.Substring(8) } }"
