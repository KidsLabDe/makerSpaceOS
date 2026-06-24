# makerSpaceOS

Eine browserbasierte, visuelle Programmierumgebung für den **Cytron Maker Pi RP2040** –  
gebaut für Kinder und Jugendliche in Makerspaces, Hackdays und Schulen.

---

## Was ist makerSpaceOS?

makerSpaceOS ist eine **Blockly-IDE**, die direkt im Browser läuft – ohne Installation, ohne App, ohne Konto.  
Kinder verbinden bunte Blöcke zu Programmen. Im Hintergrund entsteht echter **CircuitPython**-Code, der per USB auf den Mikrocontroller übertragen wird und sofort läuft.

Das Projekt entstand aus drei Jahren Hackday-Praxis beim KidsLab Nürnberg. Basis ist der Verbrauch von rund 80 Teilnehmer-Projekten: Was wurde wirklich benutzt? Was funktioniert zuverlässig mit Kindern?

---

## Hardware-Plattform

### Cytron Maker Pi RP2040

- RP2040-Chip (2× ARM Cortex-M0+, 133 MHz, 264 KB RAM, 4 MB Flash)
- **7 Grove-Ports** (GP0–GP7, GP16/GP17, GP26–GP28) für Plug-and-Play-Sensoren
- **2 eingebaute Taster** (B1 = GP20, B2 = GP21)
- **2 adressierbare NeoPixel-LEDs** (GP18, onboard)
- **4 Servo-Anschlüsse** (S1–S4 = GP12–GP15)  
- **Eingebauter Motortreiber** für 2 DC-Motoren (M1: GP8/GP9, M2: GP10/GP11)
- **Batteriemessung** (GP29 = VBAT/2 über Spannungsteiler)
- Grove-Ports liefern **3,3 V** (nicht 5 V!)
- Betriebssystem: **CircuitPython 10.x** (kein MicroPython)

---

## Wie es funktioniert

1. `index.html` im Chrome oder Edge öffnen (Web Serial API, kein Firefox/Safari)
2. Blöcke in der Toolbox wählen und auf der Arbeitsfläche verbinden
3. Auf „Hochladen" klicken → Code wird als `code.py` per Web Serial auf das Board übertragen
4. Das Board startet sofort – kein Kompilieren, kein Warten

### Ausführungsmodell

Der generierte Code nutzt **kooperatives Multitasking** (`asyncio` + `makerspaceos.py`):

- Jeder „Für immer"-Block läuft als eigene parallele Schleife
- Ereignis-Blöcke („Wenn Taster gedrückt…") werden flankengetriggert ausgelöst
- Kein `time.sleep()` – nur `await asyncio.sleep()` damit alle Tasks gleichzeitig laufen
- Die Laufzeit-Bibliothek `lib/makerspaceos.py` muss einmalig auf `CIRCUITPY/lib/` kopiert werden

---

## Architektur (Entwickler)

```
makerSpaceOS-Editor/
├── index.html              Einstiegspunkt, lädt alle Skripte
├── js/
│   ├── boards.js           Board-Profil: Pins, Grove-Ports, Servos, Motoren
│   ├── toolbox.js          Statische Kategorien (Steuerung, Logik, Mathe …)
│   ├── block_builder.js    Registriert alle Hardware-Blöcke aus blocks_db.js
│   ├── blocks_db.js        GENERIERT aus components/*.md – nicht manuell bearbeiten
│   ├── generator.js        Blockly → CircuitPython Transpiler
│   ├── app.js              Workspace-Init, UI-Events, Serial-Upload
│   └── blocks/
│       ├── control.js      Setup- und Für-Immer-Blöcke
│       ├── events.js       Ereignis-Hut-Blöcke (when_*, loop_parallel)
│       └── matrix.js       8×8-NeoPixel-Matrix (eigener Block-Editor)
├── components/
│   ├── catalog.json        Toolbox-Kategorien und Farben
│   ├── sensors/*.md        Sensor-Block-Definitionen (Markdown + YAML-Frontmatter)
│   └── actuators/*.md      Aktor-Block-Definitionen
├── scripts/
│   └── build_blocks.js     Baut components/*.md → blocks_db.js (node scripts/build_blocks.js)
├── lib/
│   ├── makerspaceos.py     Laufzeit: immer(), wenn(), start()
│   └── grove_rgb_lcd.py    LCD-Treiber (V4 und V5)
└── css/style.css           Dunkles Theme
```

Neue Hardware-Blöcke werden als `.md`-Datei angelegt (kein JS nötig), dann `node scripts/build_blocks.js` ausführen.

---

## Toolbox – alle Blöcke im Überblick

### Steuerung (violett)
| Block | Funktion |
|-------|----------|
| Beim Start | Setup-Code, läuft einmalig |
| Für immer | Endlosschleife (läuft parallel zu anderen Stapeln) |
| Warte … Sekunden | Nicht-blockierende Pause |
| Ausgabe (Print) | Text auf die serielle Konsole ausgeben |
| Wiederhole … mal | Zählschleife |
| Wiederhole solange | Bedingungsschleife |

### Ereignisse (amber)
| Block | Funktion |
|-------|----------|
| Schleife (läuft parallel) | Eigene Endlosschleife, gleichzeitig mit anderen |
| Wenn Taster … | Onboard B1/B2 oder externer Taster, gedrückt oder losgelassen |
| Wenn Drehgeber … ↑/↓ | Drehgeber dreht sich hoch oder runter (KY-040) |
| Wenn Geräusch erkannt | Digitaler Geräuschsensor (KY-038) |
| Wenn berührt | Kapazitiver Touch-Sensor |
| Wenn Abstand … cm | Ultraschall-Abstandssensor mit Schwellwert |
| Wenn Helligkeit … % | Lichtsensor mit Schwellwert |
| Wenn Temperatur … °C | DHT11 Temperatursensor mit Schwellwert |
| Wenn Luftfeuchtigkeit … % | DHT11 Feuchtigkeitssensor mit Schwellwert |

### Logik (hellblau – MakeCode-Stil)
| Block | Funktion |
|-------|----------|
| Wenn … dann | Bedingungsblock |
| Wenn … dann … sonst | Bedingungsblock mit Else |
| Vergleiche (< > =) | Vergleichsoperatoren |
| und / oder | Logische Verknüpfung |
| nicht | Logische Negation |
| wahr / falsch | Boolesche Werte |

### Mathe (grün)
Grundrechenarten, Runden, Zufallszahl, Begrenzen, mathematische Funktionen

### Variablen (gold)
Blockly-Standard-Variablen (beliebige Namen)

### Text (cyan)
Text-Literal, Text verbinden, Textlänge

---

### Sensoren (blau)

**Temperatur & Feuchte** (DHT11 / KY-015)
| Block | Wert |
|-------|------|
| 🌡️ DHT11 Temperatur (°C) | Lufttemperatur als Zahl |
| 💧 DHT11 Luftfeuchte (%) | Relative Luftfeuchtigkeit als Zahl |

**Abstand & Licht**
| Block | Wert |
|-------|------|
| 📡 Abstand (cm) | Ultraschall-Distanz, Grove-Digital-Port |
| ☀️ Helligkeit (0–100 %) | LDR-Lichtsensor, Grove-Analog-Port |

**Weitere**
| Block | Wert |
|-------|------|
| 🔘 Taster gedrückt? | Wahr/Falsch – Onboard B1/B2 oder externer Taster |
| 🔄 Drehgeber Position | Zählwert (↑ positiv, ↓ negativ, ab 0) |
| 🌱 Bodenfeuchte (0–100 %) | Kapazitiver Feuchtesensor |
| 🔋 Batteriespannung (V) | Spannung der angeschlossenen Batterie |

**Ereignisse** (inline, für Wenn-Blöcke in Schleifen)
| Block | Auslöser |
|-------|----------|
| 🔘 Wenn Taster | Taster-Zustandsänderung, für Schleifenlogik |
| ☀️ Wenn Helligkeit | Lichtwert-Schwellwert |
| 🌡️ Wenn Temperatur | Temperatur-Schwellwert |
| 📡 Wenn Abstand | Abstands-Schwellwert |

---

### Aktionen (rot)

**LED**
| Block | Funktion |
|-------|----------|
| 💡 LED | LED an einem Grove-Port ein- oder ausschalten |
| 💡 LED blinken | LED blinkt mit einstellbarer Frequenz |

**Ton**
| Block | Funktion |
|-------|----------|
| 🔔 Buzzer Ton | Passiven Buzzer (KY-006) mit Frequenz und Dauer spielen |
| 🔔 Buzzer aus | Buzzer stoppen |
| 🔊 Ton abspielen | ISD1820-Sprachmodul abspielen *(Zusatzmodul nötig)* |
| ⏺ Aufnehmen | ISD1820 Aufnahme starten *(Zusatzmodul nötig)* |

**Servo & Pumpe**
| Block | Funktion |
|-------|----------|
| ⚙️ Servo | Servo auf einen Winkel (0–180°) fahren, Servo-Port S1–S4 |

**Motor**
| Block | Funktion |
|-------|----------|
| 🚗 Motor vorwärts | DC-Motor M1 oder M2 mit Geschwindigkeit (0–100 %) |
| 🚗 Motor rückwärts | DC-Motor M1 oder M2 rückwärts |
| 🛑 Motor stopp | Motor anhalten |

---

### Lichter (pink)

**Onboard** (2 NeoPixel auf GP18)
| Block | Funktion |
|-------|----------|
| 🌈 NeoPixel alle | Beide onboard LEDs in einer Farbe |
| 🌈 NeoPixel alle aus | Beide onboard LEDs ausschalten |
| 🌈 NeoPixel LED Nr. | Einzelne onboard LED (1 oder 2) in einer Farbe |

**Streifen** (externer WS2812B-Streifen, Grove-Port)
| Block | Funktion |
|-------|----------|
| 🌈 Streifen ganz füllen | Alle LEDs des Streifens in einer Farbe |
| 🌈 Streifen aus | Alle LEDs ausschalten |
| 🌈 Streifen LED setzen | Einzelne LED des Streifens setzen |

**8×8 Matrix** (WS2812B 64-LED-Matrix, Servo-Port S1–S4)
| Block | Funktion |
|-------|----------|
| 💡 Matrix anschalten | Alle 64 LEDs in einer Farbe |
| 🔳 Matrix ausschalten | Alle LEDs aus |
| ☀️ Helligkeit | Helligkeit in % (0–100, cap 0,3 für Augenschutz) |
| 🔣 zeige Symbol | Vordefiniertes Symbol (Herz, Smiley, Stern, Pfeile …) |
| 🖊️ zeige LEDs | Pixel-Editor: 8×8-Grid selbst zeichnen |

Farbauswahl überall einheitlich: 🔴 Rot / 🟠 Orange / 🟡 Gelb / 🟢 Grün / 🩵 Cyan / 🔵 Blau / 🟣 Lila / 🩷 Pink / ⚪ Weiß / ⚫ Aus

---

### Anzeigen (dunkelgrün)

| Block | Funktion |
|-------|----------|
| 📟 LCD anzeigen | Grove RGB LCD 1602 – 2 Zeilen Text + Hintergrundfarbe |
| 🔢 7-Seg Zahl anzeigen | TM1637 4-stelliges 7-Segment-Display |
| ⬛ 7-Seg ausschalten | TM1637 ausschalten |

---

### Pins (grau – generisch/fortgeschritten)

| Block | Funktion |
|-------|----------|
| 🔌 Digital | Grove-Port digital HIGH (AN) oder LOW (AUS) setzen |
| 🔌 Digital lesen | Grove-Port lesen → Wahr/Falsch (mit Pull-Up) |
| 📊 Analog lesen | Grove-Analog-Port lesen → 0–100 % |

---

## Farb-Dropdown für LEDs (alle Blöcke einheitlich)

| Emoji | Name | Hex |
|-------|------|-----|
| 🔴 | Rot | #FF0000 |
| 🟠 | Orange | #FF6600 |
| 🟡 | Gelb | #FFFF00 |
| 🟢 | Grün | #00FF00 |
| 🩵 | Cyan | #00FFFF |
| 🔵 | Blau | #0000FF |
| 🟣 | Lila | #8000FF |
| 🩷 | Pink | #FF00FF |
| ⚪ | Weiß | #FFFFFF |
| ⚫ | Aus | #000000 |

---

## Sicherheitsmechanismen (für Kinder)

- **„Bitte auswählen"**-Platzhalter in allen Hardware-Dropdowns: Ein Block ohne gewählten Port erzeugt keinen Code, sondern einen Warnhinweis am Block
- **NeoPixel-Helligkeit** auf max. 0,3 (30 %) begrenzt – verhindert Überstrom und schützt Augen
- **Kein `time.sleep()`** im generierten Code – verhindert eingefrorene Boards
- **Pull-Up** bei generischen Digital-Eingängen automatisch gesetzt

---

## Abhängigkeiten (auf dem Board, `CIRCUITPY/lib/`)

| Datei | Woher |
|-------|-------|
| `makerspaceos.py` | Dieses Repo (`lib/`) |
| `grove_rgb_lcd.py` | Dieses Repo (`lib/`) |
| `adafruit_dht.mpy` | Adafruit CircuitPython Bundle |
| `neopixel.mpy` | Adafruit CircuitPython Bundle |
| `adafruit_motor/` | Adafruit CircuitPython Bundle |
| `asyncio/` | Adafruit CircuitPython Bundle |
| `adafruit_ticks.mpy` | Adafruit CircuitPython Bundle |
| `adafruit_tm1637.mpy` | Adafruit CircuitPython Bundle |
| `adafruit_bmp280.mpy` | Adafruit CircuitPython Bundle (optional) |
| `grove_ultrasonic.py` | Dieses Repo (`lib/`) |

---

## Abgleich mit dem Modul-Raster (MakeSpaceOS_Module.md)

| Modul-Komponente | Im Editor | Hinweis |
|-----------------|-----------|---------|
| Maker Pi RP2040 | ✅ | Board-Profil in `boards.js` |
| Robo ESP32 | ⬜ | Geplant – Funk/WLAN-Variante |
| LCD 1602 I2C | ✅ | V4 + V5 unterstützt |
| Buzzer (KY-006) | ✅ | Passiv, mit Frequenz |
| NeoPixel 8×8 Matrix | ✅ | Eigener Pixel-Editor |
| NeoPixel Streifen | ✅ | |
| NeoPixel Onboard (2 LEDs) | ✅ | Im Modul-Dok noch nicht gelistet |
| Taster (KY-004) | ✅ | B1/B2 onboard + extern Grove |
| Ultraschall-Abstand | ✅ | |
| Lichtsensor (KY-018/LDR) | ✅ | Analog-Port |
| DHT11 Temp/Feuchte | ✅ | Getrennte Blöcke für °C und % |
| Bodenfeuchte (kapazitiv) | ✅ | |
| Sound/Lautstärke (KY-038) | ⚠️ | Nur als Ereignis-Block, kein Messwert-Block |
| PIR-Bewegung | ❌ | Aus Editor entfernt (zu unzuverlässig für Kinder) |
| Rotary Encoder (KY-040) | ✅ | Position + Ereignis ↑/↓ |
| Capacitive Touch Keypad | ⬜ | Noch nicht implementiert |
| TT-Motor (Fahrantrieb) | ✅ | M1 + M2, vorwärts/rückwärts/stopp |
| Servo (SG90) | ✅ | 0–180° |
| Schrittmotor | ⬜ | Aufbaustufe, geplant |
| Wasserpumpe | ❌ | Nicht als eigener Block – über Motor-Blöcke steuerbar |
| TM1637 7-Segment | ✅ | Im Modul-Dok noch nicht gelistet |
| ISD1820 Sprachmodul | ✅ | Als „Erweiterung auf Anfrage" |
| Generische Pins (Digital/Analog) | ✅ | Für fortgeschrittene Aufbauten |

**Wichtige Korrektur zum Modul-Dok:**  
Das Modul-Dok nennt „MicroPython" als Codegen-Ziel. Der Editor erzeugt **CircuitPython**-Code (nicht MicroPython). Der Unterschied ist erheblich: andere Bibliotheken, andere Import-Syntax, andere Pin-Abstraktion. CircuitPython wurde gewählt wegen besserer Bibliotheks-Ökosystem (Adafruit Bundle), einfacherem Drag-and-Drop-Upload und stabileren Hardware-Treibern für Kinder.

---

## Nicht im Standard-Editor (Erweiterung auf Anfrage)

Wie im Modul-Dok: RFID, Farbsensor, Joystick, IR-Fernbedienung, RTC, mechanisches Keypad, Schiebepoti, Neigungsschalter, Vibrationsmotor, BMP280 Luftdruck (im Generator vorhanden, aber nicht in der Toolbox).

---

## Offene Punkte / Roadmap

- [ ] **Robo ESP32** Board-Profil (WLAN, ESP-NOW)
- [ ] **Speichern/Laden** von Projekten (Browser-LocalStorage)
- [ ] **PIR-Sensor** optional wieder einbinden (mit Debounce-Hinweis)
- [ ] **Sound/KY-038** Messwert-Block ergänzen
- [ ] **Schrittmotor** (28BYJ-48 + ULN2003)
- [ ] **Capacitive Touch Keypad** (Grove UART)
- [ ] **IR-Fernbedienung** als Ereignis-Block
- [ ] **Mehrsprachigkeit** (aktuell: Deutsch)
- [ ] **Board-Auswahl** im UI (aktuell hardcodiert auf Maker Pi RP2040)
- [ ] **Blockly-Workspace exportieren/importieren** (XML)

---

## Projekt-Info

- **Zielgruppe:** Kinder und Jugendliche ab ca. 9 Jahren, Makerspaces, Schulen
- **Sprache:** Deutsch (alle Blöcke, Tooltips, Fehlermeldungen)
- **Browser:** Chrome oder Edge (Web Serial API)
- **Kein Build-Schritt** für die App – reine statische HTML/JS/CSS
- **Block-System:** markdown-getrieben (`components/*.md` → `build_blocks.js` → `blocks_db.js`)
- **Lizenz:** tbd
- **Kontakt:** gw@communitylabs.de
