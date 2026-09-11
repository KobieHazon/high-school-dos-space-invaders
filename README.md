# DOS Space Invaders

My high-school DOS assembly game.

## Project Summary

This historical project implements a Space Invaders-style game in 16-bit x86 assembly. It includes menu, story, rules, win/lose screens, keyboard input, bitmap rendering, scoring, enemy movement, shooting, and PC-speaker music experiments.

## Project background

I built this game in high school; the recovered project folder dates to 2015. `src/SPACE_V1.asm`, `src/SPACE_V2.asm`, `src/TEST.asm`, and `src/MUSIC.asm` preserve the source snapshots. I also created the seven bitmap screens in `assets/`.

The bitmap files retain their original bytes. The assembly source uses LF line endings.

## Files

- `src/SPACE_V2.asm` is the latest recovered main game source.
- `src/SPACE_V1.asm` is an earlier recovered version.
- `src/TEST.asm` contains development experiments.
- `src/MUSIC.asm` contains a PC-speaker music experiment.
- `*.bmp` files are the screens loaded by the game.

## Validate

```sh
make check
```

The check verifies the complete selected file set, basic bitmap structure, expected assembly markers, and the absence of private or generated artifacts. It does not claim a runtime pass: faithful execution still requires compatible 16-bit DOS assembly and interactive graphics, keyboard, mouse, and speaker emulation.

## Omitted Recovered Material

Compiled `.com` output, debugger/listing/symbol files, office documents, and course instructions were intentionally excluded. The original archive remains the local source of record.

## Repository layout

- `src/`: the main game versions and historical assembly experiments.
- `assets/`: the seven original bitmap screens.
- `scripts/`: validation and DOS staging helpers.
- `build/dos/`: ignored, disposable staging output; never committed.

Run `make stage` to copy the assembly and bitmap files together into `build/dos/` without changing their bytes. Mount that directory as the working drive of the separately configured DOS/assembler environment, then build and run there. The original assembly refers to bitmap basenames, so do not run the game from `src/` or the repository root. Staging is not a claim that assembly or interactive DOS execution has been validated.
