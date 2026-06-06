# MakeSpaceOS – Modul- & Komponentenstruktur (MVP-Seed)

Stand: 2026-06-05
Grundlage: MYS-Verbrauchsdaten 2023–2026 (3 Jahre Hackdays), sortiert nach **Funktion**, nicht nach roher Stückzahl.

## Leitprinzipien

- Die Auswahl folgt der Verbrauchshäufigkeit über 3 Jahre, übersetzt auf die neue Plattform: Python, Cytron-Boards, KY/Joy-IT statt Grove/Arduino.
- Einweg-/Hackday-Modell: Preis und Einfachheit vor Robustheit.
- „Kuratiert” heißt weglassen. Einzelprojekt-Teile gehören in „Erweiterung auf Anfrage”, nicht in jeden Karton.
- KY/Joy-IT ist Primärquelle; das Grove-Altteil bleibt als verlinkte Alternative in der Datenbank.
- Hinweis zur KY/Joy-IT-Spalte: Nummern mit „?” sind noch am Joy-IT-Katalog auf Pinbelegung und Verfügbarkeit zu prüfen. Nicht ungeprüft bestellen.

-----

## Module

### 1. Boards (Steuerung)

Bewusst nur zwei Einträge — das ist die Plattform-Entscheidung, nicht auf 3–5 aufgefüllt.

|Komponente     |Rolle                           |Verbrauch 3J|Python     |
|---------------|--------------------------------|------------|-----------|
|Maker Pi RP2040|lokal / Robotik, kein Funk      |12          |MicroPython|
|Robo ESP32     |Funk (WLAN/BT/ESP-NOW), Internet|neu         |MicroPython|

Beide mit eingebautem Motortreiber und Grove-/Pin-Anschlüssen. Codegen-Ziel einheitlich MicroPython.

### 2. Ausgabe & Display

|Komponente         |Funktion                       |Verbrauch 3J   |Teil / Quelle     |KY/Joy-IT (Plan)|
|-------------------|------------------------------|---------------|------------------|----------------|
|LCD 1602 I2C       |Text-Anzeige                   |40 (kombiniert)|Standard I2C-Modul|— (Standardteil)|
|Buzzer             |Ton                            |14             |KY-006 (passiv)   |KY-006          |
|NeoPixel 8×8 Matrix|adressierbares Licht, Animation|neu            |WS2812B           |— (Standardteil)|
|NeoPixel Streifen  |adressierbares Licht, linear   |1              |WS2812B           |— (Standardteil)|

Einzel-LED als absoluter Einstieg optional ergänzbar (KY-016 RGB / einfache LED, 12× genutzt).

### 3. Sensoren Basic (Umwelt)

|Komponente         |Funktion             |Verbrauch 3J|Teil / Quelle                  |KY/Joy-IT (Plan)|
|-------------------|-----------|------------|-------------------------------|----------------|
|Taster             |digitaler Eingang    |28          |KY-004                         |KY-004 ?        |
|Ultraschall-Abstand|Distanz              |13          |HC-SR04                        |— (Standardteil)|
|Lichtsensor        |Helligkeit          |9           |KY-018 (LDR)                   |KY-018          |
|Temperatur/Feuchte |Klima                |5           |DHT11                          |KY-015 ?        |
|Bodenfeuchte       |Gießbedarf (Pflanzen)|4           |kapazitive v1.2 (nicht resistiv)|— (Standardteil)|

Hinweis Bodenfeuchte: kapazitive Sonde statt resistiv — resistive Sonden korrodieren und sind für mehrfach genutzte Aufbauten ungeeignet.

### 4. Sensoren Mensch (Interaktion)

|Komponente             |Funktion               |Verbrauch 3J       |Teil / Quelle                          |KY/Joy-IT (Plan)       |
|-----------------------|-----------------|-------------------|---------------------------------------|-------------|
|Sound / Lautstärke     |Gerä\\sch              |7                  |KY-038 (Mikro)                         |KY-038                 |
|PIR-Bewegung           |Präsenz               |6                  |HC-SR501                               |— (Standardteil)|
|Rotary Encoder         |Dreh-Eingang mit Taster|(neu, gewünscht)   |KY-040                                 |KY-040                 |
|Capacitive Touch Keypad|12-Tasten-Eingabe (3×4)|4 (mech. Vorgänger)|Grove SEE-101020636, Grove-UART, 6,95 €|bewusste Grove-Ausnahme|

### 5. Motoren & Antrieb (Robotik)

|Komponente              |Funktion         |Verbrauch 3J    |Teil / Quelle        |Hinweis                                                         |
|------------------------|-----------------|----------------|---------------------|--------------------------------------------------|
|TT-Getriebemotor mit Rad|Fahrantrieb      |50              |Standard TT 3–6 V    |meistgenutztes Teil der ganzen Liste                            |
|Servo                   |Stellantrieb     |(neu)           |SG90 o. ä.           |direkt vom Board getrieben                                      |
|Schrittmotor + Treiber  |präziser Antrieb |15              |28BYJ-48 + ULN2003  |eher Aufbaustufe                                               |
|Wasserpumpe             |Gießen (Pflanzen)|(neu, gewünscht)|Mini-Tauchpumpe 3–6 V|nicht direkt an GPIO; über Motorkanal oder Relais/MOSFET treiben|

Separater Motortreiber entfällt: Maker Pi RP2040 und Robo ESP32 haben ihn eingebaut (Grove I2C-Treiber war mit 17× genutzt — wird überflüssig).

-----

## Bewusst nicht im Standard-Kit (Erweiterung auf Anfrage)

Alle 1–4× in Einzelprojekten genutzt — verfügbar machen, aber nicht in jeden Karton:

RFID-Reader, Farbsensor, Luftqualität, UV, Gas, Wasserstandssensor, Magnetschalter, Elektromagnet, RTC (DS1307), Sprachrekorder (ISD1820), Keypad mechanisch, Schiebeschalter, Schiebepoti, Drehwinkel-Poti, Neigeschalter, Joystick (KY-023), IR-Linienverfolgung, IR-Hinderniserkennung, Vibrationsmotor.

Grenzfall: IR-Fernbedienung + Empfänger (10×) — als Robotik-Extra anbietbar.

-----

## Offene Punkte / nächste Schritte

1. **KY/Joy-IT-Mapping abschließen**: die mit „?” markierten Nummern am Joy-IT Katalog auf Pinbelegung und Lieferbarkeit (Conrad/Reichelt, Schulrechnung) prüfen. Erst dann bestellen.
1. **Funk ist eine Wette**: ESP-NOW/Board-zu-Board hat in 3 Jahren MYS null Verbrauchshistorie. Differenzierungs-Feature, kein belegter Bedarf.
1. **Strom NeoPixel**: 8×8-Matrix = 64 LEDs. Nicht aus dem 3,3-V-Regler des Boards speisen; über 5 V/USB versorgen und Helligkeit per Default begrenzen.
1. **Keypad**: bewusste Grove-Ausnahme (Grove-UART, 6,95 €) in einem sonst KY-/Pin-basierten Kit.
1. **Sensor-Benennung offen**: „Basic/Mensch” vs. „Umwelt/Interaktion” — entscheidet, wie Schüler im Editor suchen.
