#!/usr/bin/env bash
# deploy/autodeploy.sh – Auto-Deploy für mso.kidslab.de
#
# Zieht das Repo UND das Editor-Submodul (jeweils main) und baut den Container
# nur dann neu, wenn sich wirklich etwas geändert hat. Gedacht für einen
# Cron-/systemd-Timer alle 5 Minuten – ohne Änderungen kostet ein Lauf nur
# zwei "git fetch".
#
# Einrichten auf dem Server (Beispiel, Repo liegt unter /srv/makerspaceos):
#   crontab -e
#   */5 * * * * /srv/makerspaceos/deploy/autodeploy.sh >> /var/log/makerspaceos-deploy.log 2>&1

set -euo pipefail
cd "$(dirname "$0")/.."

# Nie zwei Builds parallel (Cron-Überlappung, wenn ein Build > 5 min dauert)
exec 9>"/tmp/makerspaceos-deploy.lock"
flock -n 9 || exit 0

before=$(git rev-parse HEAD)
sub_before=$(git -C makerSpaceOS-Editor rev-parse HEAD 2>/dev/null || echo "none")

# Eltern-Repo auf origin/main bringen (nur Fast-Forward, lokale Commits blocken)
git fetch --quiet origin
git merge --ff-only --quiet origin/main

# Editor-Submodul auf den neuesten Stand seines main-Branches bringen
# (nicht nur auf den im Eltern-Repo eingetragenen Commit)
git submodule sync --quiet
git submodule update --init --remote --quiet makerSpaceOS-Editor

after=$(git rev-parse HEAD)
sub_after=$(git -C makerSpaceOS-Editor rev-parse HEAD)

if [ "$before" = "$after" ] && [ "$sub_before" = "$sub_after" ]; then
  exit 0   # nichts Neues → kein Build
fi

echo "[$(date -Is)] Neu: Repo ${before:0:7}→${after:0:7}, Editor ${sub_before:0:7}→${sub_after:0:7} – baue…"
docker compose up -d --build
docker image prune -f >/dev/null
echo "[$(date -Is)] Deploy fertig."
