# Installation

## Requirements

You need OCaml 4.02 or later, dune 2.0 or later, and GNU make.

## Configuration Choices

### `PREFIX`

The value of the `PREFIX` variable can be changed to control where the software,
the standard library, and the documentation are stored. These files are copied
to the following places:

```
  $PREFIX/bin/
  $PREFIX/share/menhir/
  $PREFIX/share/doc/menhir/
  $PREFIX/share/man/man1/
```

`PREFIX` must be set when invoking `make all` and `make install` (see below).

## Compilation and Installation

Compile and install as follows:

```
       make -f Makefile PREFIX=/usr/local all
  sudo make -f Makefile PREFIX=/usr/local install
```

If necessary, adjust `PREFIX` as described above.
