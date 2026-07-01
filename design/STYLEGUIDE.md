# makerSpaceOS — Brand & Logo Guide

Übergabe-Paket für die Entwicklung (Claude Code). Enthält Logo, Farben, Schriften, Favicons und Nutzungsregeln. Visuelles Fundament: **KidsLab Design System** (crayon-Palette, Pixelify Sans, Sticker-/DIY-Charakter).

> **makerSpaceOS** = „Betriebssystem für Makerspaces". Das Zeichen verbindet **Hardware** (Platine / Leiterbahnen mit Lötaugen) und **Software** (Terminal-Prompt `>_`). Modular, offen, Open-Source-tauglich.

---

## 1. Das Logo

Ein offenes Sechseck aus **sechs Leiterbahnen**, jede mit einem **Lötauge (THT-Pad)** an einem Ende, im Uhrzeigersinn angeordnet. Im Kern sitzt der Terminal-Prompt `>_`.

**Aufbau-Regeln (nicht verändern):**
- Lötaugen liegen symmetrisch — oben, Mitte und unten jeweils auf einer Linie.
- Jede Bahn schließt **bündig** an ihr **farbgleiches** Lötauge an und läuft ohne Rundung (`stroke-linecap: butt`) unter die nächste Öse.
- Der Unterstrich des Prompts sitzt **bündig** unter dem `>`.
- Segment-Farben im Uhrzeigersinn ab oben: Orange → Gelb → Teal → Sky → Koralle → Lila.
- `OS` der Wortmarke und der Prompt-Unterstrich nutzen **Teal `#4AB8A6`**.

### Varianten & wann verwenden
| Variante | Datei | Einsatz |
|---|---|---|
| Primär (gestapelt) | `png/lockup-stacked-light.png` · `-dark.png` | Hero, Titelseiten, About, Plakate |
| Horizontal | `png/lockup-horizontal-light.png` · `-dark.png` | Navbar / Header / E-Mail-Signatur |
| Nur Marke (farbig) | `svg/logo-mark-color.svg` | App-Icon, Avatar, Loader, Favicon |
| Monochrom schwarz | `svg/logo-mark-mono.svg` | 1-Farb-Druck, Stempel, Gravur |
| Weiß | `svg/logo-mark-white.svg` | einfarbig auf dunklem/buntem Grund |
| Invers (farbig, weißer Prompt) | `svg/logo-mark-inverse.svg` | farbige Marke auf dunklem Grund |

> **Marke = SVG (skaliert unendlich), Lockups = PNG.** Die Wortmarke ist in **Pixelify Sans** gesetzt; in PNG ist die Schrift fest eingebrannt. Für eine *vektorbasierte* Wortmarke setzt du sie live als HTML-Text (Schrift aus `tokens.css`) — Snippet in §6 — und stellst sie neben `svg/logo-mark-color.svg`. So bleibt alles scharf und editierbar, ohne Schrift in die Datei einbetten zu müssen.

### Schutzraum & Mindestgrößen
- **Schutzraum:** rundherum mind. die Höhe eines Lötauges (≈ ½ Segmentbreite) freihalten.
- **Mindestgröße Vollmarke (mit Wortmarke):** 24 px Höhe.
- **Mindestgröße nur Sechseck:** 16 px. Ab ~20 px die `favicon.svg` nutzen (dickere Bahnen, ohne Prompt — bleibt erkennbar).

### Don'ts
- Segmentfarben oder ‑reihenfolge nicht ändern.
- Marke nicht verzerren, drehen oder mit Schlagschatten/Verlauf versehen.
- Wortmarke nie in einer anderen Schrift als Pixelify Sans setzen.
- Prompt `>_` nicht entfernen (außer in den dafür vorgesehenen Mini-Größen).
- Nicht auf unruhige Fotos legen — nur ruhige Flächen (Papier-Weiß oder `#15171c`).

---

## 2. Farben

| Token | Hex | Rolle |
|---|---|---|
| `--brand-orange` | `#F39A1B` | Segment 1 |
| `--brand-yellow` | `#F7D94C` | Segment 2 / Highlight |
| `--brand-teal`   | `#4AB8A6` | Segment 3 · **OS + Prompt-Leitfarbe** |
| `--brand-sky`    | `#4FBFE8` | Segment 4 |
| `--brand-purple` | `#A57BC3` | Segment 5 |
| `--brand-coral`  | `#E98685` | Segment 6 |
| `--brand-red`    | `#E24D3D` | Alert / Urgency |
| `--ink`          | `#111111` | Text, Outlines, Prompt `>` |
| `--paper`        | `#FBF8F3` | Standard-Hintergrund (warmes Weiß) |
| `--surface-dark` | `#15171c` | dunkler Grund / theme-color |

Die sechs crayon-Farben sind für **Akzente, Tags, Sektions-Marker** — nicht für Fließtext-Kontrast. Hintergründe lehnen ins **warme Off-White**, nicht reines Grau/Weiß.

Alle Tokens liegen einsatzbereit in **`tokens.css`**.

---

## 3. Schriften

| Rolle | Familie | Verwendung |
|---|---|---|
| Display | **Pixelify Sans** (600) | nur H1–H6, Logo-Wortmarke, Display-Fragmente. **Nie** für Fließtext/Buttons. |
| Body / UI | **Inter** (400–800) | Fließtext, UI, Buttons, Labels |
| Mono | **JetBrains Mono** (500/700) | Code, Prompt-/Terminal-Optik, Hex-Werte |

Fallback Pixelify: `ui-rounded, 'Marker Felt', cursive, system-ui`.
Geladen via Google Fonts (`@import` in `tokens.css`). Für Self-Hosting die `.woff2` ablegen und `@import` durch `@font-face` ersetzen.

---

## 4. Favicons & App-Icons

Ordner `favicon/`. Einbindung: Inhalt von **`favicon/head-snippet.html`** in den `<head>` kopieren.

| Datei | Zweck |
|---|---|
| `favicon.svg` | moderner Vektor-Favicon (skaliert scharf) |
| `favicon-16.png` … `favicon-512.png` | PNG-Fallbacks |
| `apple-touch-icon.png` (180) | iOS Homescreen |
| `icon-maskable-192/512.png` | Android/PWA maskable (dunkle Kachel, Safe-Padding) |
| `app-tile-light/dark-512.png` | abgerundete Showcase-Kacheln |
| `site.webmanifest` | PWA-Manifest (Pfade ggf. an Web-Root anpassen) |

> Hinweis: Eine binäre `favicon.ico` ist nicht enthalten — moderne Browser nutzen `favicon.svg` + die PNGs. Falls eine `.ico` zwingend nötig ist, aus `favicon-32.png`/`-16.png` erzeugen (z. B. via ImageMagick `convert`).

---

## 5. Datei-Index

```
export/
  STYLEGUIDE.md            ← dieses Dokument
  tokens.css               ← Farben + Schriften als CSS-Variablen
  svg/                     ← Vektor-Marke (farbig/mono/weiß/invers) + favicon.svg
  png/                     ← Marke @64–1024, Lockups (horizontal/stacked, light/dark)
  favicon/                 ← Favicons, App-Icons, Manifest, head-snippet
```

PNG-Lockups sind auf hellem (`-light`) bzw. dunklem (`-dark`) Grund gerendert. Für freie Platzierung auf beliebigem Grund: **Marke-SVG + Live-Wortmarke** (§6) kombinieren.

---

## 6. Quick-Start für die Integration

```html
<head>
  <link rel="stylesheet" href="/tokens.css">
  <!-- Inhalt von favicon/head-snippet.html hier einfügen -->
</head>
```

```css
h1, h2, h3 { font-family: var(--font-display); color: var(--ink); }
body { font-family: var(--font-body); background: var(--paper); color: var(--ink); }
.os-accent { color: var(--brand-teal); }
```

Wortmarke in HTML (statt Bild, wenn live benötigt):
```html
<span style="font-family:var(--font-display);font-weight:600">makerSpace <span style="color:var(--brand-teal)">OS</span></span>
```
