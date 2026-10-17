# Amiga-inspired Lila Night – KDE Plasma 6

Portierung des COSMIC-Themes auf **KDE Plasma 6** (getestet: Plasma 6.7.5, Wayland, CachyOS).

## Schnellinstallation

```bash
./kde/install.sh
```

Das Skript setzt Farbschema, Konsole-Profil, Hintergrund, roten Zeiger, Fensterdeko und das Claude-Code-Theme. Danach ab- und wieder anmelden, damit alles greift.

## Inhalt

| Datei | Zweck |
|---|---|
| `color-schemes/AmigaLilaNight.colors` | Plasma-Farbschema aus der Lila-Palette |
| `konsole/LilaNacht.colorscheme` + `.profile` | Terminal „Lila Nacht“ (Schrift: Adwaita Mono) |
| `klassy/klassyrc` | Fensterdeko: lila Titel + **rosa Rahmen** (2,5 px) am aktiven Fenster |
| `install.sh` | installiert alles |

Hintergrund (`wallpapers/lila-clouds-boing.png`), Zeiger (`cursor/make-red-cursor.py`) und Claude-Theme (`claude-code/amiga-night.json`) kommen aus dem Hauptrepo.

## Rosa Fensterrahmen (Klassy)

Natives Breeze färbt Titelleiste und Rahmen immer gleich. Für **lila Titel mit separatem rosa Rahmen** wird die Deko [Klassy](https://github.com/paulmcauley/klassy) genutzt. Bauen (Qt6):

```bash
cd klassy-quelle   # Klassy-Quellcode
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF \
      -DKDE_INSTALL_USE_QT_SYS_PATHS=ON -DBUILD_QT5=OFF -DBUILD_QT6=ON ..
make -j$(nproc)
sudo make install
```

Braucht `extra-cmake-modules` und die KF6-Entwicklungspakete. Ohne Klassy fällt `install.sh` automatisch auf Breeze zurück (lila Rahmen ohne separates Rosa).

## Firefox

Das Theme aus dem Hauptrepo (`firefox-amiga-lila-night.xpi`) über die Mozilla-Add-ons-Seite installieren, sobald freigegeben:
https://addons.mozilla.org/firefox/addon/amiga-inspired-lila-night/

## Palette

Siehe Haupt-`README.md`. Kernfarben: Grund `#262033`, Akzent-Lavendel `#B48CF2`, Rahmen-Rosa `#E57CC4`, Terminal-Grund `#1D1828`, Terminal-Text `#F0EAF8`.
