# tools/deck

Play profiles for the Deck build in this fork. They start the runtime built from this repository against
a prepared game folder; they do not include any game file.

## Expected layout

- `MKW_BIN`: the built runtime, default `build/dist/linux/mkw` (from `tools/build/build.py --dist`).
- `MKW_GAME`: the prepared game folder, default `~/Games/Mario Kart World`, holding `mkwgame.so`,
  `romfs`/`exefs` (or the dump links), `spirv` and `profile`.

The script writes the runtime's `mkw.ini` beside the binary with that game folder.

## Profiles

```sh
tools/deck/play.sh peak   720 30   # GPU peak pstate (15-18 W at the default cap)
tools/deck/play.sh std    720 30   # standard pstate, ~9-12 W, holds 30 fps at 720p
tools/deck/play.sh auto   720 30   # GPU clocks left to amdgpu
tools/deck/play.sh toggle 720 30   # peak in 10 s blocks (in a race)
tools/deck/play.sh gen    720 30   # 3x frame generation (30 -> 90 on the OLED)
tools/deck/play.sh gen2   720 30   # 2x frame generation (30 -> 60)
```

`MKW_PERF_OVERLAY=fps|full|off` picks the overlay (default `fps`). For a 12 W TDP cap, `std 720 30` is
the power-saving choice; for 2P or 900p, `peak` is the better one.

## Game Mode

```sh
bash tools/deck/install-shortcuts.sh
```

Then add the entries in Steam (Library → Add a Non-Steam Game). If the game or the build lives
elsewhere, edit the desktop entry's `Exec` or set `MKW_BIN`/`MKW_GAME` in the command.

## Updating

See [../../SYNC.md](../../SYNC.md) or run `tools/deck/sync-upstream.sh`.
