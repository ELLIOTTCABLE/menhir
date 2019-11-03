# The following demos require coq-menhirlib:
#   coq-minicalc

DUNEBUILD := dune build --no-print-directory
DEMOS     := coq-minicalc

.PHONY: all clean test

all::
	@ $(DUNEBUILD) @all

test::
	@ $(DUNEBUILD) @test

all clean test::
	@ for i in $(DEMOS) ; do \
	  $(MAKE) --no-print-directory -C $$i $@ ; \
	done
