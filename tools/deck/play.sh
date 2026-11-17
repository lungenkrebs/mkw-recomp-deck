#!/usr/bin/env bash
# Play the built fork with a Deck profile.
# usage: play.sh [peak|std|auto|toggle|gen|gen2] [720|900|540] [30|auto|60]
#   peak    GPU at the peak pstate (the Deck profile default; 15-18 W at the default cap)
#   std     GPU at the standard pstate (~1100 MHz; 9-12 W, holds 30 fps at 720p)
#   auto    GPU clocks left to amdgpu (the old behaviour)
#   toggle  peak in 10 s blocks (feel the difference live; requires a race)
#   gen     3x frame generation (30 -> 90 on the OLED), gen2: 2x (30 -> 60)
# MKW_BIN: the built runtime (default build/dist/linux/mkw)
# MKW_GAME: the prepared game folder with mkwgame.so, romfs/exefs, spirv and profile
set -u
mode=${1:-peak}; res=${2:-720}; fps=${3:-30}
here=$(cd "$(dirname "$0")" && pwd)
repo=$(cd "$here/../.." && pwd)
bin=${MKW_BIN:-$repo/build/dist/linux/mkw}
game=${MKW_GAME:-$HOME/Games/Mario Kart World}

case "$mode" in
  peak)   clocks=peak ;;
  std)    clocks=standard ;;
  auto)   clocks=off ;;
  toggle) clocks=ab; export MKW_AB=${MKW_AB:-10} ;;
  gen)    clocks=peak; export MKW_FRAMEGEN=3 MKW_VRR=1 ;;
  gen2)   clocks=peak; export MKW_FRAMEGEN=2 MKW_VRR=1 ;;
  *) echo "usage: play.sh [peak|std|auto|toggle|gen|gen2] [RES] [FPS]" >&2; exit 2 ;;
esac

[ -x "$bin" ] || { echo "play.sh: $bin missing (build: uv run tools/build/build.py --dist)" >&2; exit 1; }
[ -d "$game" ] || { echo "play.sh: game folder $game missing (set MKW_GAME)" >&2; exit 1; }

# the runtime reads its game folder from mkw.ini beside the binary
printf '[launcher]\ngame_dir = "%s/"\n' "$game" > "$(dirname "$bin")/mkw.ini"

export SDL_VIDEODRIVER=x11
export MKW_FULLSCREEN=1 MKW_RESOLUTION="$res" MKW_FPS="$fps"
export MKW_GPU_CLOCKS="$clocks"
export MKW_PERF_OVERLAY="${MKW_PERF_OVERLAY:-fps}"
exec "$bin" --profile "$game/profile" --play
