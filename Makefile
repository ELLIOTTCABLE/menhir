# This is the main Makefile that is shipped as part of the source package.

# Keep in mind that the hierarchy that is shipped is not identical to the
# hierarchy within the git repository. Some sub-directories are not shipped.
# The documentation (manual.pdf, menhir.1) is pre-built and stored at the root.

# This Makefile can also be used directly in the repository. In that case,
# the documentation and demos are not installed.

# The hierarchy that is shipped includes:
#   demos
#   menhir.1
#   manual.pdf
#   manual.html
#   src
#   Makefile (this one)

# ----------------------------------------------------------------------------

# The following variables must/can be configured.

ifndef PREFIX
  $(error Please define PREFIX)
endif

# ----------------------------------------------------------------------------

# Compilation.

.PHONY: install uninstall

# ----------------------------------------------------------------------------
# Installation.

install:
	@ dune install --prefix=$(PREFIX) menhir

uninstall:
	@ dune uninstall --prefix=$(PREFIX) menhir
