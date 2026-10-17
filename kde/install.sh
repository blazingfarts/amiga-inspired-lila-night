#!/usr/bin/env bash
# AUSFÜHREN AUF: KDE Plasma 6 (Wayland/X11) – Amiga-inspired Lila Night installieren
# Installiert Farbschema, Plasma-Stil, Konsole-Profil, Hintergrund (auch Sperrbildschirm),
# Symbole, roten Zeiger, Fensterdeko (türkiser Rahmen + Knöpfe) und Claude-Code-Theme.
set -euo pipefail
cd "$(dirname "$0")/.."   # Repo-Wurzel
msg(){ printf '\033[1;35m» %s\033[0m\n' "$*"; }
WP="file://$PWD/wallpapers/lila-clouds-boing.png"

msg "Farbschema + Plasma-Stil"
mkdir -p ~/.local/share/color-schemes
cp kde/color-schemes/AmigaLilaNight.colors ~/.local/share/color-schemes/
# eigene Akzentfarbe würde Lavendel überschreiben
kwriteconfig6 --file kdeglobals --group General --key AccentColor --delete
kwriteconfig6 --file kdeglobals --group General --key accentColorFromWallpaper false
# Plasma lädt ein Schema mit unverändertem Namen nicht neu → kurz über BreezeDark wechseln
plasma-apply-colorscheme BreezeDark >/dev/null 2>&1 || true
plasma-apply-colorscheme AmigaLilaNight
# „default“ (Breeze) folgt dem Farbschema; andere Plasma-Stile bringen eigene Farben mit
plasma-apply-desktoptheme default

msg "Konsole-Profil + Schema"
mkdir -p ~/.local/share/konsole
cp kde/konsole/LilaNacht.colorscheme kde/konsole/LilaNacht.profile ~/.local/share/konsole/
kwriteconfig6 --file konsolerc --group 'Desktop Entry' --key DefaultProfile 'LilaNacht.profile'

msg "Hintergrund (helle Wolken) + Sperrbildschirm"
plasma-apply-wallpaperimage "$PWD/wallpapers/lila-clouds-boing.png"
kwriteconfig6 --file kscreenlockerrc --group Greeter --key WallpaperPlugin org.kde.image
kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "$WP"

msg "Symbole „Amiga-Glanz“ (Oxygen, Lücken aus Papirus)"
I=~/.local/share/icons/Amiga-Glanz; mkdir -p "$I/128x128/apps"; cp icons/Amiga-Glanz/index.theme "$I/"
[ -d /usr/share/icons/oxygen ] || echo "   ! Oxygen fehlt: sudo pacman -S oxygen-icons papirus-icon-theme (Fedora/Debian: oxygen-icon-theme)"
/usr/lib/plasma-changeicons Amiga-Glanz 2>/dev/null || kwriteconfig6 --file kdeglobals --group Icons --key Theme Amiga-Glanz
gsettings set org.gnome.desktop.interface icon-theme 'Amiga-Glanz' 2>/dev/null || true

msg "Roter Zeiger (Größe 48)"
python3 cursor/make-red-cursor.py
plasma-apply-cursortheme Rot-Zeiger --size 48 || plasma-apply-cursortheme Rot-Zeiger
kwriteconfig6 --file kcminputrc --group Mouse --key cursorSize 48
gsettings set org.gnome.desktop.interface cursor-size 48 2>/dev/null || true
for g in ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini; do
    [ -f "$g" ] && sed -i 's/^gtk-cursor-theme-size=.*/gtk-cursor-theme-size=48/' "$g"
done

msg "Fensterdeko: lila Titel, türkiser Rahmen (3 px) + türkise Knöpfe am aktiven Fenster"
mkdir -p ~/.config/klassy
cp kde/klassy/klassyrc ~/.config/klassy/klassyrc
if [ -f /usr/lib/qt6/plugins/org.kde.kdecoration3/org.kde.klassy.so ]; then
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library org.kde.klassy
    kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme Klassy
else
    echo "   ! Klassy nicht installiert – nutze Breeze (ohne separaten türkisen Rahmen)."
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

msg "Fertig. Offene Konsole-Fenster behalten ihr altes Profil – neu öffnen."
echo "   Firefox-Theme: siehe kde/README-kde.md (Abschnitt Firefox)."
