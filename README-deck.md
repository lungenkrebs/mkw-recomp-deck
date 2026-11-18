# mkw-recomp-deck

A fork of [mkw-recomp](https://github.com/adriadam10/mkw-recomp) (MIT) with Steam Deck presentation and
a Deck-specific performance profile. Nothing of the game is in this repository: the game code and
assets come from the player's own dump.

## What this fork adds

- **Native Steam Deck button prompts**: Xelu's free CC0 controller prompts, packed into the game's glyph
  grid (`runtime/ui/glyphs/deck_sheet.png`, `deck_sheet.c`), drawn instead of the white badges.
  Controls → Button icons has a **Steam Deck** choice; on Valve's Jupiter/Galileo boards it is picked
  automatically (`cfg_on_steam_deck`).
- **The Deck profile** (`runtime/core/base/cfg.c`, the `DECK[]` table) sets, besides the upstream
  1280x800/fifo/720p defaults:
  - `GPU_CLOCKS = peak`: amdgpu left the half-busy GPU at 200–1040 MHz; the race at 900p/30 went
    **39.4 → 33.8 ms**, 2P **−4.7 ms** (in-run A/B and its inverted twin), on battery −3.0 ms.
  - `REPLAY_CORE = 1`: the replay thread alone on one physical core, −1.2 ms.
  - `MESH_COMPUTE = 0`: native task/mesh shaders instead of the compute emulation RADV takes by default.
    The emulation draws the drift decal of
    [#543](https://github.com/adriadam10/mkw-recomp/issues/543) as huge stretched quads across the track;
    the native path ran three races on a Deck OLED without a device loss and leaves only that one decal
    wrong. `MKW_MESH_COMPUTE=1` returns to the emulation if a Mesa update breaks the native path.
  All can be overridden with `MKW_GPU_CLOCKS=off|standard`, `MKW_REPLAY_CORE=0` and `MKW_MESH_COMPUTE=1`.
- **TDP guidance**: peak draws 15–18 W at the default cap; the `standard` pstate draws 9–12 W and held
  30 fps at 720p (12 W cap: 33.5 ms median, occasional slow-motion at the race start). For 2P or 900p,
  peak is the better choice.
- **`tools/deck/`**: play profiles (peak, standard, auto, toggle, frame generation) and desktop entries
  for Game Mode. See [tools/deck/README.md](tools/deck/README.md).

## Build and play

Build exactly as upstream ([README](README.md), `tools/build/README.md`):

```sh
uv run python recomp/gen.py --exefs game/exefs --out build/generated --jobs 6 --patches recomp/patches-mkw-180.txt
uv run tools/shaders/extract.py && uv run tools/shaders/translate.py
uv run tools/build/build.py --dist
```

Then point `tools/deck/play.sh` at the built binary and the prepared game folder (the folder holding
`mkwgame.so`, `romfs`/`exefs`, `spirv`, `profile`):

```sh
MKW_BIN=~/mkw-recomp-deck/build/dist/linux/mkw MKW_GAME="$HOME/Games/Mario Kart World" \
  tools/deck/play.sh peak 720 30
```

In Game Mode, run `bash tools/deck/install-shortcuts.sh` once and add the entries in Steam
(Library → Add a Non-Steam Game).

## Credits

- Upstream: [adriadam10/mkw-recomp](https://github.com/adriadam10/mkw-recomp), MIT; every file keeps its
  own license and credits.
- GPU clocks: [PR #521](https://github.com/adriadam10/mkw-recomp/pull/521) by AngeloAscheri, MIT; the
  Deck's peak/standard policy and measurements are this fork's.
- Steam Deck prompts: [Xelu's Free Controller & Key Prompts](https://thoseawesomeguys.com/prompts/), CC0.
- The rest of the port: see [docs/project/research.md](docs/project/research.md).

MIT. This project is not affiliated with or endorsed by Nintendo.
