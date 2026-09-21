# DOS Space Invaders

My high-school DOS assembly game.

## Project Summary

This historical project implements a Space Invaders-style game in 16-bit x86 assembly. It includes menu, story, rules, win/lose screens, keyboard input, bitmap rendering, scoring, enemy movement, shooting, and PC-speaker music experiments.

## Project background

I built this game in high school; the project folder dates to 2015. `src/SPACE_V1.asm`, `src/SPACE_V2.asm`, `src/TEST.asm`, and `src/MUSIC.asm` preserve the source snapshots. I also created the seven bitmap screens in `assets/`.

The bitmap files retain their original bytes. The assembly source uses LF line endings.

## Files

- `src/SPACE_V2.asm` is the latest main game source.
- `src/SPACE_V1.asm` is an earlier version.
- `src/TEST.asm` contains development experiments.
- `src/MUSIC.asm` contains a PC-speaker music experiment.
- `*.bmp` files are the screens loaded by the game.

## Build and test

Install Docker and run:

```sh
make test
```

The image builds a pinned JWasm assembler and runs DOSBox on a virtual display with networking disabled. The test assembles `SPACE_V2.asm`, checks that the menu and story bitmaps render, enters gameplay, and verifies right-arrow movement and shooting from the rendered frames.

`scripts/build_dos.py` adapts the EMU8086 syntax for JWasm in a temporary build copy: it declares the code segment/CPU, places macros before their uses, normalizes procedure endings and the exit label, and treats an explanatory ellipsis as a comment. The assembly source snapshots are unchanged.

This is a short gameplay test, not a complete playthrough or an audio-quality test. For interactive play, `make stage` places source and bitmaps together in `build/dos/`; use a DOS emulator and a compatible assembler. `make check` checks source and bitmap structure.

## Repository layout

- `src/`: the main game versions and assembly experiments.
- `assets/`: the seven bitmap screens.
- `docs/`: the project report.
- `scripts/`: assembly, emulator-test, and staging helpers.
- `docker/`: the assembler/emulator environment.

## Project report

[The project report](docs/project-report.pdf) covers the design, implementation, interface, and testing.
