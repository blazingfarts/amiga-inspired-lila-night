# Amiga-inspired Lila Night – KDE Plasma 6

Portierung des COSMIC-Themes auf **KDE Plasma 6** (getestet: Plasma 6.7.5, Wayland, CachyOS).

## Schnellinstallation

```bash
./kde/install.sh
```

Das Skript setzt Farbschema, Plasma-Stil, Konsole-Profil, Hintergrund (auch Sperrbildschirm), Symbole, roten Zeiger, Fensterdeko und das Claude-Code-Theme. Danach ab- und wieder anmelden, damit alles greift.

Voraussetzungen: `oxygen-icons` und `papirus-icon-theme` (Arch/CachyOS; Fedora/Debian: `oxygen-icon-theme`), für den türkisen Rahmen die Fensterdeko Klassy (siehe unten).

## Inhalt

| Datei | Zweck |
|---|---|
| `color-schemes/AmigaLilaNight.colors` | Plasma-Farbschema aus der Lila-Palette, Akzent Lavendel |
| `konsole/LilaNacht.colorscheme` + `.profile` | Terminal „Lila Nacht“ (Schrift: Adwaita Mono, rosa Cursor) |
| `klassy/klassyrc` | Fensterdeko: lila Titel, **türkiser Rahmen** (2 px) und türkise Knöpfe am aktiven Fenster |
| `install.sh` | installiert alles |

Hintergrund (`wallpapers/lila-clouds-boing.png`), Symbole (`icons/Amiga-Glanz`), Zeiger (`cursor/make-red-cursor.py`) und Claude-Theme (`claude-code/amiga-night.json`) kommen aus dem Hauptrepo.

## Warum türkis?

Auf COSMIC 1.10 liest der Compositor den Fensterrahmen aus dem neueren Theme-Format v2, dort steht das COSMIC-Standard-Türkis `#63D0DF`. Der Lila-Look bekommt so einen türkisen Rahmen und türkise Fensterknöpfe. Das sieht gut aus und bleibt so, auch unter KDE. Rosa `#E57CC4` gibt es nur noch als Terminal-Cursor.

## Türkiser Fensterrahmen (Klassy)

Natives Breeze färbt Titelleiste und Rahmen immer gleich. Für **lila Titel mit separatem türkisem Rahmen** wird die Deko [Klassy](https://github.com/paulmcauley/klassy) genutzt. Bauen (Qt6):

```bash
cd klassy-quelle   # Klassy-Quellcode
mkdir -p build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF \
      -DKDE_INSTALL_USE_QT_SYS_PATHS=ON -DBUILD_QT5=OFF -DBUILD_QT6=ON ..
make -j$(nproc)
sudo make install
```

Braucht `extra-cmake-modules` und die KF6-Entwicklungspakete. Ohne Klassy fällt `install.sh` automatisch auf Breeze zurück (kein separater Rahmen).

## Fallen

* `plasma-apply-colorscheme` lädt ein Schema mit **unverändertem Namen nicht neu**. Nach Änderungen an der `.colors`-Datei erst `BreezeDark`, dann wieder `AmigaLilaNight` anwenden (macht `install.sh`).
* Eine eigene **Akzentfarbe** (`AccentColor` in `kdeglobals`) überschreibt das Lavendel des Schemas. `install.sh` entfernt sie.
* Plasma-Stile außer „default“ (z. B. Layan) bringen eigene Leistenfarben mit und ignorieren das Schema.
* Das Symbolthema braucht `FollowsColorScheme=true` in `index.theme`, sonst bleiben die Oxygen-Leistensymbole dunkelgrau auf dunkler Leiste. Nach dem Ändern `systemctl --user restart plasma-plasmashell`.

## Firefox

Arch/CachyOS-Firefox erlaubt wie Fedora unsignierte Themes im Programmordner:

```bash
sudo install -m 644 firefox-amiga-lila-night.xpi \
  /usr/lib/firefox/browser/extensions/amiga-lila-night@blazingfarts.xpi
```

Im Profil `user.js` mit `user_pref("extensions.autoDisableScopes", 11);`, Firefox neu starten, dann *Add-ons und Themes → Themes → Aktivieren*. Alternativ von addons.mozilla.org, sobald freigegeben: https://addons.mozilla.org/firefox/addon/amiga-inspired-lila-night/

## Palette

Siehe Haupt-`README.md`. Kernfarben: Grund `#262033`, Titel `#312A41`, Akzent-Lavendel `#B48CF2`, Rahmen + Knöpfe Türkis `#63D0DF`, Terminal-Grund `#1D1828`, Terminal-Text `#F0EAF8`, Terminal-Cursor Rosa `#E57CC4`.
