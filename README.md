# luigi

Nim bindings for the barebones single-header GUI library for Win32, X11, and[Essence](https://gitlab.com/nakst/essence): [Luigi](https://github.com/nakst/luigi). Please do note that while Win32 and X11 have been tested, Essence has not, so it might not work using this library.

## Current State of the Bindings

Currently the bindings are *kinda* low-level, but this shouldn't be a problem. However, in the future I will create high-level bindings like I have done for [uing](https://github.com/neroist/uing). Unlike uing however, these bindings do *not* support choosing how to add/link the library to your application. Static compilation is the only option currently and I plan it to stay that way, as its honestly much easier (for me atleast). In addition, Luigi isn't *fully* 100% cross-platform, as it supports Essence instead of MacOS, so you should keep that in mind.

###### Though you *should* check out Essence OS: <https://nakst.gitlab.io/essence>

Also Freetype support is currently being worked on; it doesn't work right now out-of-the-box.

## Installation

You can install via nimble:

```sh
nimble install luigi

```

## Documenation

As for right now, you can read Luigi's README [here](https://github.com/nakst/luigi/tree/main#readme) as for how to get started. The function names are generally the same with the "`UI`" prefix removed. Also, there's a few examples in the [`examples/`](examples/) directory.

Also, side note, if you ever need to enter any data where it would be of the type `ptrdiff_t` in C (generally found on text-related funcs, usually called `bytes` or something similar), **enter a integer cast to a pointer.**

Like so:

```nim
let label = labelCreate(addr panel.e, 0, "Label", cast[pointer](-1))
```

If you just need to put in `-1`, use the `castInt` const instead of casting (though it should be default on most functions).
