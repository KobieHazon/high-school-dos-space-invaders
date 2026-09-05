# DOS Space Invaders

My high-school DOS assembly game.

## Project Summary

This historical project implements a Space Invaders-style game in 16-bit x86 assembly. It includes menu, story, rules, win/lose screens, keyboard input, bitmap rendering, scoring, enemy movement, shooting, and PC-speaker music experiments.

## Provenance and Authorship

- Era: high school, recovered from a 2015 project folder.
- `SPACE_V1.asm`, `SPACE_V2.asm`, `TEST.asm`, and `MUSIC.asm` are the recovered project source snapshots.
- The BMP files are the game-specific assets recovered alongside and referenced by the source.
- No collaborator attribution was found in the recovered source or project metadata.

## Files

- `SPACE_V2.asm` is the latest recovered main game source.
- `SPACE_V1.asm` is an earlier recovered version.
- `TEST.asm` contains development experiments.
- `MUSIC.asm` contains a PC-speaker music experiment.
- `*.bmp` files are the screens loaded by the game.

## Validate

```sh
make check
```

The check verifies the complete selected file set, basic bitmap structure, expected assembly markers, and the absence of private or generated artifacts. It does not claim a runtime pass: faithful execution still requires compatible 16-bit DOS assembly and interactive graphics, keyboard, mouse, and speaker emulation.

## Omitted Recovered Material

Compiled `.com` output, debugger/listing/symbol files, office documents, and course instructions were intentionally excluded. The original archive remains the local source of record.
