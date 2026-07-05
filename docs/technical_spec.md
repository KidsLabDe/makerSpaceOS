# Technische Spezifikation - Modulstruktur

Diese Spezifikation basiert auf den Verbrauchsdaten 2023–2026 und definiert die Standard-Komponenten des makerSpaceOS.

## 1. Steuerung (Boards)
- **Maker Pi RP2040:** Lokal / Robotik, kein Funk ($\rightarrow$ MicroPython).
- **Robo ESP32:** Funk (WLAN/BT/ESP-NOW), Internet ($\rightarrow$ MicroPython).
*Beide Boards verfügen über integrierte Motortreiber und Grove-/Pin-Anschlüsse.*

## 2. Ausgabe & Display
- **LCD 1602 I2C:** Textanzeigen.
- **Buzzer (KY-006):** Tonausgabe.
- **NeoPixel 8x8 Matrix & Streifen:** Adressierbares Licht/Animationen.

## 3. Sensoren Basic (Umwelt)
- **Taster (KY-004):** Digitaler Eingang.
- **Ultraschall-Abstand (HC-SR04):** Distanzmessung.
- **Lichtsensor (KY-018 LDR):** Helligkeit.
- **Temperatur/Feuchte (DHT11 / KY-015):** Klima.
- **Bodenfeuchte:** Kapazitive Sonde v1.2 (keine resistiven Sonden).

## 4. Sensoren Mensch (Interaktion)
- **Sound/Lautstärke (KY-038):** Mikrofon.
- **PIR-Bewegung (HC-SR501):** Präsenzerkennung.
- **Rotary Encoder (KY-040):** Dreh-Eingang mit Taster.
- **Capacitive Touch Keypad:** 12-Tasten-Eingabe (bewusste Grove-Ausnahme).

## 5. Motoren & Antrieb
- **TT-Getriebemotor m. Rad:** Standard Fahrantrieb (meistgenutztes Teil).
- **Servo (SG90):** Stellantrieb.
- **Schrittmotor (28BYJ-48 + ULN2003):** Präziser Antrieb.
- **Wasserpumpe:** Mini-Tauchpumpe 3–6 V (über externe Treiber).

## Erweiterungen (Auf Anfrage)
RFID, Farbsensoren, Luftqualität, UV, Gas, Wasserstand, Magnetschalter etc.
