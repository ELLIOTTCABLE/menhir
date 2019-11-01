DUNEBUILD := dune build --no-print-directory

.PHONY: all test expected

all:
	@ $(DUNEBUILD)

test:
	@ $(DUNEBUILD) --display short @test

expected:
	@ $(DUNEBUILD) @test --auto-promote

gen:
	@ echo > dune.inc
	@ $(DUNEBUILD) @gen --auto-promote || :

list:
	@ $(DUNEBUILD) --force --no-buffer @list
