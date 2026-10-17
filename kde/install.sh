#!/usr/bin/env bash
# AUSFÜHREN AUF: KDE Plasma 6 (Wayland/X11) – Amiga-inspired Lila Night installieren
# Installiert Farbschema, Konsole-Profil, Hintergrund, roten Zeiger und Claude-Code-Theme.
set -euo pipefail
cd "$(dirname "$0")/.."   # Repo-Wurzel
msg(){ printf '\033[1;35m» %s\033[0m\n' "$*"; }

msg "Farbschema"
mkdir -p ~/.local/share/color-schemes
cp kde/color-schemes/AmigaLilaNight.colors ~/.local/share/color-schemes/
plasma-apply-colorscheme AmigaLilaNight

msg "Konsole-Profil + Schema"
mkdir -p ~/.local/share/konsole
cp kde/konsole/LilaNacht.colorscheme kde/konsole/LilaNacht.profile ~/.local/share/konsole/
kwriteconfig6 --file konsolerc --group 'Desktop Entry' --key DefaultProfile 'LilaNacht.profile'

msg "Hintergrund (helle Wolken)"
plasma-apply-wallpaperimage "$PWD/wallpapers/lila-clouds-boing.png"

msg "Roter Zeiger (Größe 48)"
python3 cursor/make-red-cursor.py
plasma-apply-cursortheme Rot-Zeiger --size 48 || plasma-apply-cursortheme Rot-Zeiger
kwriteconfig6 --file kcminputrc --group Mouse --key cursorSize 48

msg "Fensterdeko: lila Titel + rosa Rahmen am aktiven Fenster"
mkdir -p ~/.config/klassy
cp kde/klassy/klassyrc ~/.config/klassy/klassyrc
if [ -f /usr/lib/qt6/plugins/org.kde.kdecoration3/org.kde.klassy.so ]; then
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.klassy
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme Klassy
else
    echo "   ! Klassy nicht installiert – nutze Breeze (lila Rahmen ohne separates Rosa)."
    echo "     Klassy bauen: siehe kde/README-kde.md. Fallback jetzt:"
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.breeze
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme Breeze
fi
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key BorderSize Normal
kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key BorderSizeAuto false
qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true

msg "Claude Code Theme"
mkdir -p ~/.claude/themes
cp claude-code/amiga-night.json ~/.claude/themes/
echo "   → in Claude Code: /theme → Amiga-inspired Lila Night"

msg "Fertig. Firefox-Theme: siehe README (AMO-Link)."
