DUNEBUILD := dune build --no-print-directory

.PHONY: test speed trustme

test:
	@ $(DUNEBUILD) --display short @@test

gen:
	@ echo > dune.inc
	@ $(DUNEBUILD) @gen --auto-promote || :

speed:
	@ $(DUNEBUILD) --force --no-buffer @speed

trustme:
	@ $(DUNEBUILD) @@test --auto-promote
