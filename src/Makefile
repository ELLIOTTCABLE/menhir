# ----------------------------------------------------------------------------
# Dune tool and settings.

DUNE      := dune
DUNEBUILD := $(DUNE) build --no-print-directory

# ----------------------------------------------------------------------------
# For everyday development.
# Typing "make" will perform just stage 1. This is enough to ensure that
# the source code is correct.

.PHONY: everyday
everyday: stage1

# ----------------------------------------------------------------------------
# Building Menhir from scratch (a.k.a. bootstrapping).

bootstrap: stage3
	@ if ! $(DUNEBUILD) --force @bootstrap ; then \
	  echo "Bootstrap FAILED: $$i did not reach a fixed point."; exit 1 ; \
	fi ; \
	echo "Bootstrap successful."

# ----------------------------------------------------------------------------
# Stage 1.
# Build Menhir using ocamlyacc.

.PHONY: stage1
stage1:
	@ $(DUNEBUILD) @stage1/all

# ----------------------------------------------------------------------------
# Updating the auto-generated comments in parserMessages.messages.
# We use Menhir (from stage 1).

.PHONY: update
update:
	@ $(DUNEBUILD) @update-messages --auto-promote

# ----------------------------------------------------------------------------
# Stage 2.
# Build Menhir using Menhir (from stage 1).

.PHONY: stage2
stage2:
	@ $(DUNEBUILD) @stage2/all

# ----------------------------------------------------------------------------
# Stage 3 (optional).
# Re-generate Menhir's parser using Menhir (from stage 2) and check that it
# is identical to the stage 2 parser.

.PHONY: stage3
stage3:
	@ $(DUNEBUILD) @stage3/all

# ----------------------------------------------------------------------------
# Building menhirSdk.

.PHONY: sdk
sdk:
	@ $(DUNEBUILD) @sdk/all
