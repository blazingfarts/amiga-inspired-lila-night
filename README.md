# Amiga-inspired Lila Night – a COSMIC theme

A dark (but not black) theme for the **COSMIC desktop**, inspired by AmigaOS 3.1 / 4.1:
deep plum windows, lavender accents, a pink frame around the active window, glossy 2008-style
icons, a lilac cloud sky with the famous checkered ball – and a terminal that is easy on the eyes.

![Preview](screenshots/preview.png)

*Deutsch weiter unten.*

## What's inside

| Part | File(s) | Notes |
|---|---|---|
| COSMIC colors (dark + matching light) | `cosmic/` | builder + pre-built theme, no compiling needed |
| Single theme file for *Settings → Appearance → Import* | `cosmic/amiga-inspired-lila-night.ron` | same file as on cosmic-themes.org |
| Terminal colors (COSMIC Terminal) | `terminal/` | *the* highlight – readable dim text, soft pink cursor |
| Wallpapers | `wallpapers/` | lilac clouds with checkered ball (+ darker variant) |
| Glossy icons | `icons/Amiga-Glanz/` | uses **Oxygen** icons, Papirus as fallback, COSMIC apps mapped to Oxygen |
| Big red mouse pointer (optional) | `cursor/make-red-cursor.py` | recolors your local Adwaita cursors, size 48 |
| Claude Code colors (optional) | `claude-code/amiga-night.json` | matching theme for the Claude Code CLI |
| Rebuild tool (optional) | `tools/cosmic-theme-rebuild/` | rebuilds the COSMIC theme after editing builder files, exports `.ron` |

## Install

Requirements: COSMIC (tested with **COSMIC 1.10 on Fedora 44**), `oxygen-icon-theme` and `papirus-icon-theme`
(Fedora: `sudo dnf install oxygen-icon-theme papirus-icon-theme`; Debian/Ubuntu: `oxygen-icon-theme papirus-icon-theme`).

```bash
git clone https://github.com/blazingfarts/amiga-inspired-lila-night
cd amiga-inspired-lila-night
bash install.sh                      # colors, terminal, wallpaper, icons
bash install.sh --with-cursor        # + big red mouse pointer
bash install.sh --with-claude-code   # + Claude Code colors
```

Your current look is backed up to `~/.config/cosmic-backup-<date>/` first. Log out and back in once afterwards.

**Only the colors?** Settings → Appearance → Import → `cosmic/amiga-inspired-lila-night.ron`.
**Only the terminal?** COSMIC Terminal → Settings → Color schemes → Import → `terminal/amiga-inspired-lila-night-terminal.ron`.

## Palette

| | Hex |
|---|---|
| Background | `#262033` |
| Containers | `#312A41` / `#3B3350` |
| Accent (lavender) | `#B48CF2` |
| Active window frame (pink) | `#E57CC4` |
| Success / Warning / Error | `#5CC48A` / `#F0B44C` / `#F06A7A` |
| Terminal background / text | `#1D1828` / `#F0EAF8` |

---

## Deutsch

Ein dunkles (aber nicht schwarzes) Theme für **COSMIC**, angelehnt an AmigaOS 3.1/4.1: Fenster in Pflaume,
Lavendel-Akzente, rosa Rahmen ums aktive Fenster, glänzende Symbole wie 2008, lila Wolkenhimmel mit Boing-Ball –
und ein Terminal, das die Augen schont.

Installation: siehe oben (`bash install.sh`, optional `--with-cursor`, `--with-claude-code`). Vorher wird dein
aktueller Look nach `~/.config/cosmic-backup-<datum>/` gesichert. Danach einmal ab- und anmelden.

## Credits & licenses

- Theme files, scripts and the rebuild tool: **MIT** (see `LICENSE`). The rebuild tool uses libcosmic (MPL-2.0).
- Wallpapers: AI-generated (Google Gemini) and recolored by hand; free to use.
- Icons are **not** included – they come from your distro's Oxygen (LGPL) and Papirus (GPL-3) packages.
- The red cursor is generated locally from your Adwaita cursors (CC-BY-SA 3.0 / LGPL-3); no cursor files are shipped.
- This is a fan theme. *Amiga* and *AmigaOS* are trademarks of their respective owners; not affiliated or endorsed.
