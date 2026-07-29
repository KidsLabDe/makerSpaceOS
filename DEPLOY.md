# Deployment — makerSpaceOS Landing Page

Statische Landing Page (`index.html`) + Editor unter `/editor/`, ausgeliefert per nginx,
veröffentlicht über Traefik unter **https://mso.kidslab.de**.

## Aufbau

| Pfad | Inhalt |
|---|---|
| `index.html` | Landing Page (self-contained: lokale Fonts in `assets/fonts/`, keine externen CDN-Requests) |
| `design/` | Logos, Favicons, Styleguide |
| `assets/` | Bilder (Editor-Screenshot) + lokale Web-Fonts |
| `makerSpaceOS-Editor/` | Editor-Submodul → im Image nach `/editor/` kopiert |
| `Dockerfile` · `nginx.conf` | nginx:alpine, liefert `/` (Landing) und `/editor/` (Editor) |
| `docker-compose.yml` | Service + Traefik-Labels |

## Lokal testen

```bash
docker compose up -d --build
# Landing:  http://localhost  (sofern Port 80 frei / via Traefik)
# Editor:   /editor/
docker compose down
```

Schneller Smoke-Test ohne Traefik:

```bash
docker build -t makerspaceos .
docker run --rm -p 8080:80 makerspaceos
# → http://localhost:8080/  und  http://localhost:8080/editor/
```

> Hinweis: Der Editor-Link zeigt auf das absolute `/editor/`. Die reine Landing-Page-Vorschau
> per `python3 -m http.server` funktioniert, der Editor-Klick aber nur im Docker-/Server-Kontext.

## Produktion (Traefik)

Das Setup folgt dem `kidslab.de`-Stack: externes Netzwerk `proxy`, entrypoints `web`/`websecure`,
certresolver `myresolver`. DNS-Eintrag `mso.kidslab.de` auf den Server zeigen lassen, dann:

```bash
docker compose up -d --build
```

Traefik holt automatisch das Let's-Encrypt-Zertifikat. Anpassen, falls dein Traefik andere
Namen nutzt: `traefik.docker.network`, `entryPoints` und `tls.certresolver` in `docker-compose.yml`.

### Optional: Image aus der Registry

Statt lokalem Build (`build: .`) kann ein vorgebautes Image gezogen werden — dafür in
`docker-compose.yml` die `image:`-Zeile auf die Registry (z. B. `ghcr.io/kidslabde/makerspaceos:latest`)
setzen und `build: .` entfernen.

## Auto-Deploy: alle 5 Minuten neu aus Git

`deploy/autodeploy.sh` zieht das Repo **und** das Editor-Submodul (jeweils `main`)
und baut den Container nur, wenn sich etwas geändert hat — ein Lauf ohne Änderungen
kostet nur zwei `git fetch`. Ein Lock verhindert überlappende Builds.

Einmalig auf dem Server (Repo z. B. unter `/srv/makerspaceos`):

```bash
git clone --recurse-submodules https://github.com/KidsLabDe/makerSpaceOS.git /srv/makerspaceos
crontab -e
```

> **Kein Key nötig:** Repo und Editor-Submodul sind öffentlich und werden per
> HTTPS geladen. Sollte das Repo später auf privat gestellt werden, auf dem
> Server einen Key erzeugen (`ssh-keygen -t ed25519`) und den Public Key auf
> GitHub als **Deploy Key** (nur Lesen) hinterlegen: Repo → Settings → Deploy
> keys; die Clone-URL dann auf `git@github.com:KidsLabDe/makerSpaceOS.git`
> umstellen.

Cron-Zeile (als Benutzer mit Docker-Rechten):

```cron
*/5 * * * * /srv/makerspaceos/deploy/autodeploy.sh >> /var/log/makerspaceos-deploy.log 2>&1
```

Fertig — jeder Push auf `main` (Landing **oder** Editor) ist nach spätestens
5 Minuten live. Manuell anstoßen: einfach das Skript direkt ausführen.

Alternative statt Cron: systemd-Timer (Logs landen dann im Journal):

```ini
# /etc/systemd/system/makerspaceos-deploy.service
[Unit]
Description=makerSpaceOS Auto-Deploy
[Service]
Type=oneshot
ExecStart=/srv/makerspaceos/deploy/autodeploy.sh

# /etc/systemd/system/makerspaceos-deploy.timer
[Unit]
Description=makerSpaceOS Auto-Deploy alle 5 Minuten
[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
[Install]
WantedBy=timers.target
```

```bash
sudo systemctl enable --now makerspaceos-deploy.timer
journalctl -u makerspaceos-deploy.service -f   # Logs ansehen
```

> **Hinweis Submodul:** Das Skript nutzt `git submodule update --remote`, folgt also
> immer dem `main`-Branch des Editors (`branch = main` in `.gitmodules`) — der im
> Eltern-Repo eingetragene Submodul-Commit muss dafür nicht bei jedem Editor-Push
> aktualisiert werden.
