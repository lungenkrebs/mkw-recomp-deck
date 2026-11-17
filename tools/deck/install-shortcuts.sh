#!/usr/bin/env bash
# Desktop entries for the Deck profiles; add them in Steam (Library -> Add a Non-Steam Game).
set -u
here=$(cd "$(dirname "$0")" && pwd)
chmod +x "$here/play.sh"
d="$HOME/.local/share/applications"
mkdir -p "$d"

entry() {
  name=$1 args=$2 file=$3
  cat > "$d/$file.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=$name
Comment=Mario Kart World (mkw-recomp-deck)
Exec=$here/play.sh $args
Terminal=false
Categories=Game;
EOF
  chmod +x "$d/$file.desktop"
}

entry "MKW Deck · Peak 720/30"  "peak 720 30"  mkw-deck-peak720
entry "MKW Deck · Standard 720/30" "std 720 30" mkw-deck-std720
entry "MKW Deck · Peak 900/30"  "peak 900 30"  mkw-deck-peak900
entry "MKW Deck · Toggle 720/30" "toggle 720 30" mkw-deck-toggle
entry "MKW Deck · Gen3 720/30"  "gen 720 30"   mkw-deck-gen3

ls -1 "$d"/mkw-deck-*.desktop
echo
echo "In Steam: Library -> Add a Non-Steam Game -> the entries above."
echo "The play script needs MKW_BIN/MKW_GAME, or the defaults: build/dist/linux/mkw and ~/Games/Mario Kart World."
