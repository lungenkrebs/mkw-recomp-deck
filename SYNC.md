# Keeping this fork up to date

`main` is upstream plus the Deck commits. The upstream remote is set by `tools/deck/sync-upstream.sh`;
the fork's GitHub page also offers **Sync fork** on `main` (one click), which performs the same merge.

## GitHub button

1. Open <https://github.com/lungenkrebs/mkw-recomp-deck>.
2. **Sync fork → Update branch** (merges `adriadam10/mkw-recomp:main` into this `main`).
3. If GitHub reports a conflict, resolve it locally (below); the Deck delta is small: the `DECK[]` table
   in `runtime/core/base/cfg.c`, the glyphs (`runtime/ui/glyphs/`), `settings_tabs.cpp`, `cfg.h`,
   `ui_text.h`, the i18n catalogs and `docs/project/research.md`.

## Locally

```sh
tools/deck/sync-upstream.sh
```

which is:

```sh
git remote add upstream https://github.com/adriadam10/mkw-recomp.git 2>/dev/null || true
git fetch upstream
git merge upstream/main
```

Resolve conflicts by keeping both sides where they touch different things:

- `runtime/core/base/cfg.c`: upstream's `DECK[]` rows (1280x800/fifo/720p) and this fork's
  `GPU_CLOCKS`/`REPLAY_CORE` rows; the `cfg_on_steam_deck` change (if upstream adds its own Deck
  detection, keep one function and the `cfg.h` declaration).
- `runtime/ui/glyphs/`: keep this fork's `deck_sheet.c/png` and the `glyphs.c` paths that use them;
  upstream may add its own glyph styles — keep both.
- `runtime/ui/menu/settings_tabs.cpp`: the Button icons array and its count (6 with Steam Deck).
- i18n: the `UI_MENU_ICONS_STEAM_DECK` context in `i18n/ui/*.po` and `mkw.pot`.

Then rebuild (`tools/build/build.py --dist`) and check Controls → Button icons.

## Upstream changes to watch

- `vk_pstate.c` / `MKW_GPU_CLOCKS`: the Deck profile only sets the value; the mechanism is upstream.
- `REPLAY_CORE`: the profile sets it; upstream's default (6+ cores) is unchanged.
- The glyph system: this fork's white prompts sit on upstream's glyph redraw; a conflict there is
  expected when upstream changes the sheet.
