#!/usr/bin/env bash
# Amiga-inspired Lila Night – installer for COSMIC (tested with COSMIC 1.10 on Fedora 44)
# Usage: bash install.sh [--with-cursor] [--with-claude-code]
set -euo pipefail
Q="$(cd "$(dirname "$0")" && pwd)"
C="$HOME/.config/cosmic"
WITH_CURSOR=0; WITH_CLAUDE=0
for a in "$@"; do case "$a" in --with-cursor) WITH_CURSOR=1;; --with-claude-code) WITH_CLAUDE=1;; esac; done

echo "1/5 Backup of your current COSMIC look → ~/.config/cosmic-backup-$(date +%Y%m%d-%H%M%S)"
B="$HOME/.config/cosmic-backup-$(date +%Y%m%d-%H%M%S)"; mkdir -p "$B"
for d in com.system76.CosmicTheme.Dark com.system76.CosmicTheme.Dark.Builder com.system76.CosmicTheme.Light \
         com.system76.CosmicTheme.Light.Builder com.system76.CosmicTheme.Mode com.system76.CosmicTerm \
         com.system76.CosmicBackground com.system76.CosmicTk; do
  [ -d "$C/$d" ] && cp -a "$C/$d" "$B/"
done

echo "2/5 Colors (dark + matching light variant)"
for pair in "dark-builder:com.system76.CosmicTheme.Dark.Builder" "dark-theme:com.system76.CosmicTheme.Dark" \
            "light-builder:com.system76.CosmicTheme.Light.Builder" "light-theme:com.system76.CosmicTheme.Light"; do
  src="${pair%%:*}"; dst="$C/${pair#*:}/v1"; mkdir -p "$dst"; cp "$Q/cosmic/$src"/* "$dst/"
done
mkdir -p "$C/com.system76.CosmicTheme.Mode/v1"; printf 'true' > "$C/com.system76.CosmicTheme.Mode/v1/is_dark"

echo "3/5 Terminal colors + wallpaper"
mkdir -p "$C/com.system76.CosmicTerm/v1" "$C/com.system76.CosmicBackground/v1" "$HOME/Pictures/Wallpapers"
cp "$Q/terminal/color_schemes_dark" "$Q/terminal/syntax_theme_dark" "$C/com.system76.CosmicTerm/v1/"
cp "$Q"/wallpapers/*.png "$HOME/Pictures/Wallpapers/"
cat > "$C/com.system76.CosmicBackground/v1/all" <<BG
(
    output: "all",
    source: Path("$HOME/Pictures/Wallpapers/lila-clouds-boing.png"),
    filter_by_theme: false,
    rotation_frequency: 1800,
    filter_method: Lanczos,
    scaling_mode: Zoom,
    sampling_method: Alphanumeric,
)
BG

echo "4/5 Icons (needs oxygen-icon-theme + papirus-icon-theme from your distro)"
I="$HOME/.local/share/icons/Amiga-Glanz"; mkdir -p "$I/128x128/apps"; cp "$Q/icons/Amiga-Glanz/index.theme" "$I/"
O=/usr/share/icons/oxygen/base/128x128
if [ -d "$O" ]; then
  while read -r app src; do [ -f "$O/$src" ] && ln -sf "$O/$src" "$I/128x128/apps/$app.png"; done <<MAP
com.system76.CosmicFiles apps/system-file-manager.png
com.system76.CosmicEdit apps/accessories-text-editor.png
com.system76.CosmicTerm apps/utilities-terminal.png
com.system76.CosmicStore apps/system-software-install.png
com.system76.CosmicSettings categories/preferences-system.png
com.system76.CosmicLauncher actions/system-search.png
com.system76.CosmicWorkspaces apps/preferences-system-windows.png
com.system76.CosmicAppLibrary categories/applications-other.png
MAP
  mkdir -p "$C/com.system76.CosmicTk/v1"; printf '"Amiga-Glanz"' > "$C/com.system76.CosmicTk/v1/icon_theme"
  gsettings set org.gnome.desktop.interface icon-theme 'Amiga-Glanz' 2>/dev/null || true
else
  echo "   Oxygen icons not found – skipped. Install oxygen-icon-theme and run again."
fi

echo "5/5 Optional extras"
if [ $WITH_CURSOR = 1 ]; then
  python3 "$Q/cursor/make-red-cursor.py"
  grep -q 'XCURSOR_THEME=Rot-Zeiger' "$HOME/.bash_profile" 2>/dev/null || printf '\nexport XCURSOR_THEME=Rot-Zeiger\nexport XCURSOR_SIZE=48\n' >> "$HOME/.bash_profile"
  gsettings set org.gnome.desktop.interface cursor-theme 'Rot-Zeiger' 2>/dev/null || true
  echo "   Red cursor active after next login."
fi
if [ $WITH_CLAUDE = 1 ]; then
  mkdir -p "$HOME/.claude/themes"; cp "$Q/claude-code/amiga-night.json" "$HOME/.claude/themes/"
  echo "   Claude Code: run /theme and pick 'Amiga-inspired Lila Night'."
fi
pkill -x cosmic-panel 2>/dev/null || true
echo "Done. Open a new terminal; log out and in once so every app picks up icons and colors."
echo "Undo: copy the folders from $B back to ~/.config/cosmic/ and log out/in."
