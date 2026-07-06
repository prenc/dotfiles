#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install -m 0755 "$SCRIPT_DIR/autorandr-smart-apply" /usr/local/bin/autorandr-smart-apply
install -m 0755 "$SCRIPT_DIR/autorandr-smart-resume" /usr/lib/systemd/system-sleep/autorandr-smart-resume
install -d -m 0755 /etc/systemd/system/autorandr-lid-listener.service.d
install -m 0644 "$SCRIPT_DIR/lid-listener-override.conf" /etc/systemd/system/autorandr-lid-listener.service.d/override.conf

systemctl daemon-reload
systemctl restart autorandr-lid-listener.service
systemctl status autorandr-lid-listener.service --no-pager
